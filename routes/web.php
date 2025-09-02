<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\SubjectController;
use App\Http\Controllers\TopicController;
use App\Http\Controllers\LessonController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\Admin\PaymentSettingsController;
use App\Http\Controllers\Admin\SiteContentController;
use App\Http\Controllers\Admin\SystemSettingsController;
use App\Http\Controllers\EnrollmentController;
use App\Http\Controllers\SubjectDetailController;
use App\Models\User;
use App\Models\StudentStory;
use App\Models\AccessDuration;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    // Get student count with error handling
    try {
        $studentCount = User::where('role', 'student')->count();
    } catch (Exception $e) {
        $studentCount = 500;
    }
    
    // Get featured student stories from database (fallback to default if none)
    try {
        $studentStories = StudentStory::getFeatured();
    } catch (Exception $e) {
        $studentStories = collect([]);
    }
    
    // Get access durations from database
    try {
        $accessDurations = AccessDuration::where('is_active', true)
            ->orderBy('sort_order')
            ->get();
    } catch (Exception $e) {
        $accessDurations = collect([]);
    }
    
    // Get subjects from database
    try {
        $subjects = \App\Models\Subject::where('is_active', true)->get()->map(function ($subject) {
            return [
                'id' => $subject->id,
                'name' => $subject->name,
                'description' => $subject->description,
                'department' => $subject->department,
                'grade_level' => $subject->grade_level,
                'icon' => match($subject->name) {
                    'English' => '📚',
                    'Chichewa' => '📖',
                    'Mathematics' => '📐',
                    'Life Skills' => '🧠',
                    'Biology' => '🧬',
                    'Physical Science' => '⚗️',
                    'Chemistry' => '🧪',
                    'Physics' => '⚡',
                    'Geography' => '🗺️',
                    'History' => '🏛️',
                    'Social Studies' => '🌍',
                    'Bible Knowledge' => '✝️',
                    'Agriculture' => '🌾',
                    'Home Economics' => '🏠',
                    'Technical Drawing' => '📏',
                    'Business Studies' => '💼',
                    'French' => '🇫🇷',
                    'Computer Studies' => '💻',
                    default => '📚'
                },
                'type' => match($subject->department) {
                    'Languages' => 'core',
                    'General Studies' => 'core',
                    'Sciences' => 'science',
                    'Humanities' => 'humanities',
                    'Technical' => 'technical',
                    'Commerce' => 'commerce',
                    'Technology' => 'technology',
                    default => 'optional'
                }
            ];
        });
    } catch (Exception $e) {
        // Fallback if database query fails
        $subjects = collect([]);
    }

    // Sample testimonials (fallback for testimonial cards)
    $testimonials = [
        [
            'name' => 'Sarah Phiri',
            'location' => 'London, UK',
            'message' => 'StudySeco helped me maintain my connection to Malawian education while living abroad. The teachers are excellent!',
            'rating' => 5,
            'avatar' => 'SP'
        ],
        [
            'name' => 'John Mwale',
            'location' => 'Cape Town, South Africa',
            'message' => 'The MANEB curriculum alignment is perfect. My son passed his MSCE with flying colors thanks to StudySeco.',
            'rating' => 5,
            'avatar' => 'JM'
        ],
        [
            'name' => 'Grace Banda',
            'location' => 'Toronto, Canada',
            'message' => 'Flexible scheduling allowed me to study while working. The online library is incredibly comprehensive.',
            'rating' => 5,
            'avatar' => 'GB'
        ]
    ];

    // Get active payment methods grouped by region
    try {
        $paymentMethods = \App\Models\PaymentMethod::active()->get()->groupBy('region');
    } catch (Exception $e) {
        $paymentMethods = collect([]);
    }

    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
        'subjects' => $subjects,
        'studentCount' => max($studentCount, 500), // Show at least 500
        'testimonials' => $testimonials,
        'studentStories' => $studentStories,
        'accessDurations' => $accessDurations,
        'paymentMethods' => $paymentMethods
    ]);
})->name('welcome');

// Subject detail routes (public)
Route::get('/subject/{id}', [SubjectDetailController::class, 'show'])->name('subject.detail');

// Enrollment routes (public)
Route::post('/enroll', [EnrollmentController::class, 'store'])->name('enrollment.store');
Route::get('/enrollment/success', [EnrollmentController::class, 'success'])->name('enrollment.success');

// Verification routes (public)
Route::get('/verification/{enrollment}', [\App\Http\Controllers\VerificationController::class, 'show'])->name('verification.show');
Route::post('/verification/{enrollment}/email/send', [\App\Http\Controllers\VerificationController::class, 'sendEmailVerification'])->name('verification.email.send');
Route::post('/verification/{enrollment}/phone/send', [\App\Http\Controllers\VerificationController::class, 'sendPhoneVerification'])->name('verification.phone.send');
Route::post('/verification/{enrollment}/email/verify', [\App\Http\Controllers\VerificationController::class, 'verifyEmail'])->name('verification.email.verify');
Route::post('/verification/{enrollment}/phone/verify', [\App\Http\Controllers\VerificationController::class, 'verifyPhone'])->name('verification.phone.verify');
Route::get('/verification/{enrollment}/status', [\App\Http\Controllers\VerificationController::class, 'status'])->name('verification.status');

// Protected enrollment routes
Route::middleware('auth')->group(function () {
    Route::post('/enrollment/extend', [EnrollmentController::class, 'extend'])->name('enrollment.extend');
    Route::get('/enrollment/check-extension', [EnrollmentController::class, 'checkExtension'])->name('enrollment.check-extension');
});

Route::get('/dashboard', function () {
    $user = auth()->user();
    $data = ['auth' => ['user' => $user]];
    
    if ($user->role === 'admin') {
        // Get real statistics for admin dashboard
        try {
            // Calculate real revenue data
            $monthlyRevenue = \App\Models\EnrollmentPayment::where('status', 'verified')
                ->whereMonth('created_at', now()->month)
                ->whereYear('created_at', now()->year)
                ->sum('amount');
                
            $totalRevenue = \App\Models\EnrollmentPayment::where('status', 'verified')
                ->sum('amount');
                
            $pendingPayments = \App\Models\EnrollmentPayment::where('status', 'pending')
                ->sum('amount');
            
            $data['stats'] = [
                'total_students' => \App\Models\User::where('role', 'student')->count(),
                'total_teachers' => \App\Models\User::where('role', 'teacher')->count(),
                'total_subjects' => \App\Models\Subject::where('is_active', true)->count(),
                'pending_enrollments' => \App\Models\Enrollment::where('status', 'pending')->count(),
                'total_enrollments' => \App\Models\Enrollment::count(),
                'active_enrollments' => \App\Models\Enrollment::where('status', 'approved')
                    ->whereDate('access_expires_at', '>', now())->count(),
                'expired_enrollments' => \App\Models\Enrollment::where('status', 'approved')
                    ->whereDate('access_expires_at', '<=', now())->count(),
                'monthly_revenue' => $monthlyRevenue,
                'total_revenue' => $totalRevenue,
                'pending_revenue' => $pendingPayments,
                'pending_payments_count' => \App\Models\EnrollmentPayment::where('status', 'pending')->count(),
            ];
            
            // Recent enrollments for activity feed (admin sees all)
            $data['recent_enrollments'] = \App\Models\Enrollment::with('user')
                ->orderBy('created_at', 'desc')
                ->limit(5)
                ->get()
                ->map(function ($enrollment) {
                    return [
                        'id' => $enrollment->id,
                        'student_name' => $enrollment->user ? $enrollment->user->name : $enrollment->name,
                        'email' => $enrollment->email,
                        'status' => $enrollment->status,
                        'created_at' => $enrollment->created_at->diffForHumans(),
                        'type' => 'enrollment',
                        'description' => 'New enrollment for ' . count($enrollment->selected_subjects ?: []) . ' subjects'
                    ];
                });
                
            // Recent payments for activity feed (admin sees all)
            $data['recent_payments'] = \App\Models\EnrollmentPayment::with('enrollment.user')
                ->orderBy('created_at', 'desc')
                ->limit(5)
                ->get()
                ->map(function ($payment) {
                    return [
                        'id' => $payment->id,
                        'student_name' => $payment->enrollment->user ? $payment->enrollment->user->name : $payment->enrollment->name,
                        'amount' => $payment->amount,
                        'currency' => $payment->currency,
                        'status' => $payment->status,
                        'created_at' => $payment->created_at->diffForHumans(),
                        'type' => 'payment',
                        'description' => 'Payment of ' . $payment->currency . ' ' . number_format($payment->amount, 2)
                    ];
                });
                
            // Subject distribution for chart
            $data['subject_distribution'] = \App\Models\Subject::selectRaw('department, COUNT(*) as count')
                ->where('is_active', true)
                ->groupBy('department')
                ->get()
                ->map(function ($item) {
                    return [
                        'department' => $item->department,
                        'count' => $item->count
                    ];
                });
                
        } catch (Exception $e) {
            // Fallback to dummy data if database queries fail
            $data['stats'] = [
                'total_students' => 1850,
                'total_teachers' => 125,
                'total_subjects' => 45,
                'pending_enrollments' => 7,
                'total_enrollments' => 2000,
                'active_enrollments' => 1500,
                'expired_enrollments' => 350,
            ];
            $data['recent_enrollments'] = [];
            $data['recent_payments'] = [];
            $data['subject_distribution'] = [];
        }
    } elseif ($user->role === 'student') {
        // Get student-specific data
        try {
            $enrollment = \App\Models\Enrollment::where('user_id', $user->id)->orWhere('email', $user->email)->with('subjects')->first();
            $data['enrollment'] = $enrollment;
            $data['enrolled_subjects'] = $enrollment ? $enrollment->subjects : collect([]);
            $data['access_remaining'] = $enrollment ? $enrollment->access_days_remaining : 0;
            $data['access_expired'] = $enrollment ? $enrollment->is_access_expired : true;
            
            // Add stats object for students with enrollment status
            $data['stats'] = [
                'enrollment_status' => $enrollment ? ($enrollment->is_trial ? 'trial' : $enrollment->status) : 'not_enrolled',
                'total_subjects' => $enrollment ? count($enrollment->selected_subjects ?: []) : 0,
                'access_remaining_days' => $enrollment ? $enrollment->access_days_remaining : 0,
                'is_trial' => $enrollment ? $enrollment->is_trial : false,
            ];
            
            // Student-specific recent activities (only their own data)
            $data['recent_activities'] = collect();
            
            if ($enrollment) {
                // Student's own enrollment activity
                $data['recent_activities']->push([
                    'id' => 'enrollment_' . $enrollment->id,
                    'type' => 'enrollment',
                    'title' => 'Course Enrollment',
                    'description' => 'Enrolled in ' . count($enrollment->selected_subjects ?: []) . ' subjects',
                    'created_at' => $enrollment->created_at->diffForHumans(),
                    'status' => $enrollment->status
                ]);
                
                // Student's own payment activities
                $studentPayments = \App\Models\EnrollmentPayment::where('enrollment_id', $enrollment->id)
                    ->orderBy('created_at', 'desc')
                    ->limit(3)
                    ->get();
                    
                foreach ($studentPayments as $payment) {
                    $data['recent_activities']->push([
                        'id' => 'payment_' . $payment->id,
                        'type' => 'payment',
                        'title' => 'Payment ' . ucfirst($payment->status),
                        'description' => 'Payment of ' . $payment->currency . ' ' . number_format($payment->amount, 2),
                        'created_at' => $payment->created_at->diffForHumans(),
                        'status' => $payment->status,
                        'amount' => $payment->amount,
                        'currency' => $payment->currency
                    ]);
                }
            }
            
            // Sort activities by date
            $data['recent_activities'] = $data['recent_activities']->sortByDesc('created_at')->take(5);
            
        } catch (Exception $e) {
            $data['enrollment'] = null;
            $data['enrolled_subjects'] = collect([]);
            $data['access_remaining'] = 0;
            $data['access_expired'] = true;
            $data['recent_activities'] = collect([]);
            $data['stats'] = [
                'enrollment_status' => 'not_enrolled',
                'total_subjects' => 0,
                'access_remaining_days' => 0,
                'is_trial' => false,
            ];
        }
    } elseif ($user->role === 'teacher') {
        // Get teacher-specific data
        try {
            // Get assigned students (students assigned to this teacher)
            $assignedEnrollments = \App\Models\Enrollment::where('assigned_tutor_id', $user->id)
                ->with('user')
                ->where('status', 'approved')
                ->get();
                
            $data['assigned_students'] = $assignedEnrollments->map(function ($enrollment) {
                return [
                    'id' => $enrollment->user ? $enrollment->user->id : null,
                    'name' => $enrollment->user ? $enrollment->user->name : $enrollment->name,
                    'email' => $enrollment->email,
                    'enrollment_id' => $enrollment->id,
                    'subjects_count' => count($enrollment->selected_subjects ?: []),
                    'access_expires_at' => $enrollment->access_expires_at,
                    'is_trial' => $enrollment->is_trial,
                    'status' => $enrollment->status,
                    'tutor_assigned_at' => $enrollment->tutor_assigned_at
                ];
            });
            
            $data['teacher_subjects'] = \App\Models\Subject::where('is_active', true)->limit(5)->get();
            $data['student_count'] = $assignedEnrollments->count();
            
            // Teacher stats
            $data['stats'] = [
                'assigned_students' => $assignedEnrollments->count(),
                'active_students' => $assignedEnrollments->where('access_expires_at', '>', now())->count(),
                'trial_students' => $assignedEnrollments->where('is_trial', true)->count(),
                'subjects_teaching' => $data['teacher_subjects']->count()
            ];
            
            // Recent student activities for teacher dashboard
            $data['recent_activities'] = collect();
            
            foreach ($assignedEnrollments->take(5) as $enrollment) {
                $data['recent_activities']->push([
                    'id' => 'assignment_' . $enrollment->id,
                    'type' => 'assignment',
                    'title' => 'Student Assigned',
                    'description' => ($enrollment->user ? $enrollment->user->name : $enrollment->name) . ' was assigned to you',
                    'created_at' => $enrollment->tutor_assigned_at ? \Carbon\Carbon::parse($enrollment->tutor_assigned_at)->diffForHumans() : $enrollment->created_at->diffForHumans(),
                    'student_name' => $enrollment->user ? $enrollment->user->name : $enrollment->name
                ]);
            }
            
        } catch (Exception $e) {
            $data['assigned_students'] = collect([]);
            $data['teacher_subjects'] = collect([]);
            $data['student_count'] = 0;
            $data['recent_activities'] = collect([]);
            $data['stats'] = [
                'assigned_students' => 0,
                'active_students' => 0,
                'trial_students' => 0,
                'subjects_teaching' => 0
            ];
        }
    }
    
    return Inertia::render('Dashboard', $data);
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    // Community Feed Routes
    Route::prefix('community')->name('community.')->group(function () {
        Route::get('/', [\App\Http\Controllers\CommunityController::class, 'index'])->name('index');
        Route::get('/create', [\App\Http\Controllers\CommunityController::class, 'create'])->name('create');
        Route::post('/', [\App\Http\Controllers\CommunityController::class, 'store'])->name('store');
        Route::get('/{post}', [\App\Http\Controllers\CommunityController::class, 'show'])->name('show');
        Route::get('/{post}/edit', [\App\Http\Controllers\CommunityController::class, 'edit'])->name('edit');
        Route::patch('/{post}', [\App\Http\Controllers\CommunityController::class, 'update'])->name('update');
        Route::delete('/{post}', [\App\Http\Controllers\CommunityController::class, 'destroy'])->name('destroy');
        Route::post('/{post}/react', [\App\Http\Controllers\CommunityController::class, 'toggleReaction'])->name('react');
        Route::post('/{post}/comment', [\App\Http\Controllers\CommunityController::class, 'storeComment'])->name('comment');
        Route::post('/{post}/vote', [\App\Http\Controllers\CommunityController::class, 'votePoll'])->name('vote');
        Route::post('/comment/{comment}/solution', [\App\Http\Controllers\CommunityController::class, 'markSolution'])->name('markSolution');
        Route::post('/share-resource', [\App\Http\Controllers\CommunityController::class, 'shareResource'])->name('shareResource');
        Route::get('/resource/{resource}/download', [\App\Http\Controllers\CommunityController::class, 'downloadResource'])->name('downloadResource');
    });

    // Student Extension Routes
    Route::get('/student/extension', [\App\Http\Controllers\ExtensionController::class, 'index'])->name('student.extension');
    Route::post('/student/extension', [\App\Http\Controllers\ExtensionController::class, 'store'])->name('student.extension.store');

    // Profile Routes
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    // Admin-Only School Management Routes
    Route::middleware('role:admin')->group(function () {
        Route::get('/students', [\App\Http\Controllers\StudentController::class, 'index'])->name('students.index');
        Route::get('/students/create', [\App\Http\Controllers\StudentController::class, 'create'])->name('students.create');
        Route::post('/students', [\App\Http\Controllers\StudentController::class, 'store'])->name('students.store');
        Route::get('/students/{user}', [\App\Http\Controllers\StudentController::class, 'show'])->name('students.show');
        Route::get('/students/{user}/edit', [\App\Http\Controllers\StudentController::class, 'edit'])->name('students.edit');
        Route::put('/students/{user}', [\App\Http\Controllers\StudentController::class, 'update'])->name('students.update');
        Route::delete('/students/{user}', [\App\Http\Controllers\StudentController::class, 'destroy'])->name('students.destroy');
    });

    // Teacher Management Routes (Admin and Teachers can access)
    Route::middleware('role:admin,teacher')->group(function () {
        Route::get('/teachers', [\App\Http\Controllers\TeacherController::class, 'index'])->name('teachers.index');
        Route::get('/teachers/{user}', [\App\Http\Controllers\TeacherController::class, 'show'])->name('teachers.show');
    });
    
    // Admin-only teacher management operations
    Route::middleware('role:admin')->group(function () {
        Route::get('/teachers/create', [\App\Http\Controllers\TeacherController::class, 'create'])->name('teachers.create');
        Route::post('/teachers', [\App\Http\Controllers\TeacherController::class, 'store'])->name('teachers.store');
        Route::get('/teachers/{user}/edit', [\App\Http\Controllers\TeacherController::class, 'edit'])->name('teachers.edit');
        Route::put('/teachers/{user}', [\App\Http\Controllers\TeacherController::class, 'update'])->name('teachers.update');
        Route::delete('/teachers/{user}', [\App\Http\Controllers\TeacherController::class, 'destroy'])->name('teachers.destroy');
    });

    // Subject Management Routes
    Route::resource('subjects', SubjectController::class);
    
    // Topic Management Routes (API)
    Route::prefix('api')->group(function () {
        Route::post('topics', [TopicController::class, 'store'])->name('topics.store');
        Route::get('topics/{topic}', [TopicController::class, 'show'])->name('topics.show');
        Route::put('topics/{topic}', [TopicController::class, 'update'])->name('topics.update');
        Route::delete('topics/{topic}', [TopicController::class, 'destroy'])->name('topics.destroy');
        Route::patch('topics/{topic}/reorder', [TopicController::class, 'reorder'])->name('topics.reorder');
        
        // Lesson Management Routes (API)
        Route::post('lessons', [LessonController::class, 'store'])->name('lessons.store');
        Route::put('lessons/{lesson}', [LessonController::class, 'update'])->name('lessons.update');
        Route::delete('lessons/{lesson}', [LessonController::class, 'destroy'])->name('lessons.destroy');
        Route::patch('lessons/{lesson}/publish', [LessonController::class, 'publish'])->name('lessons.publish');
        Route::patch('lessons/{lesson}/unpublish', [LessonController::class, 'unpublish'])->name('lessons.unpublish');
    });
    
    // Lesson Player Route
    Route::get('lessons/{lesson}', [LessonController::class, 'show'])->name('lessons.show');

    Route::get('/fees', function () {
        return Inertia::render('Fees/Index', [
            'fees' => []
        ]);
    })->name('fees.index');

    Route::get('/fees/create', function () {
        return Inertia::render('Fees/Create');
    })->name('fees.create');

    // Payment Management Routes (Admin-only viewing, students can only create)
    Route::get('/payments', [PaymentController::class, 'index'])->middleware('role:admin')->name('payments.index');
    Route::get('/payments/create', [PaymentController::class, 'create'])->name('payments.create');
    Route::post('/payments', [PaymentController::class, 'store'])->name('payments.store');
    Route::get('/payments/{payment}', [PaymentController::class, 'show'])->name('payments.show');
    Route::post('payments/{payment}/verify', [PaymentController::class, 'verify'])->middleware('role:admin')->name('payments.verify');
    Route::get('payments/statistics', [PaymentController::class, 'statistics'])->middleware('role:admin')->name('payments.statistics');
    Route::get('api/payments/check-access', [PaymentController::class, 'checkAccess'])->name('payments.check-access');

    // Admin Payment Settings Routes
    Route::prefix('admin/payment-settings')->name('admin.payment-settings.')->group(function () {
        Route::get('/', [PaymentSettingsController::class, 'index'])->name('index');
        
        // Payment Methods
        Route::post('/payment-methods', [PaymentSettingsController::class, 'storePaymentMethod'])->name('payment-methods.store');
        Route::put('/payment-methods/{paymentMethod}', [PaymentSettingsController::class, 'updatePaymentMethod'])->name('payment-methods.update');
        Route::delete('/payment-methods/{paymentMethod}', [PaymentSettingsController::class, 'destroyPaymentMethod'])->name('payment-methods.destroy');
        Route::patch('/payment-methods/order', [PaymentSettingsController::class, 'updatePaymentMethodOrder'])->name('payment-methods.order');
        
        // Access Durations
        Route::post('/access-durations', [PaymentSettingsController::class, 'storeAccessDuration'])->name('access-durations.store');
        Route::put('/access-durations/{accessDuration}', [PaymentSettingsController::class, 'updateAccessDuration'])->name('access-durations.update');
        Route::delete('/access-durations/{accessDuration}', [PaymentSettingsController::class, 'destroyAccessDuration'])->name('access-durations.destroy');
        Route::patch('/access-durations/order', [PaymentSettingsController::class, 'updateAccessDurationOrder'])->name('access-durations.order');
    });

    // Admin Site Content Management Routes
    Route::prefix('admin/site-content')->name('admin.site-content.')->group(function () {
        Route::get('/', [SiteContentController::class, 'index'])->name('index');
        
        // Site Content
        Route::post('/contents', [SiteContentController::class, 'storeContent'])->name('contents.store');
        Route::put('/contents/{content}', [SiteContentController::class, 'updateContent'])->name('contents.update');
        Route::delete('/contents/{content}', [SiteContentController::class, 'destroyContent'])->name('contents.destroy');
        Route::patch('/contents/order', [SiteContentController::class, 'updateContentOrder'])->name('contents.order');
        
        // Student Stories
        Route::post('/student-stories', [SiteContentController::class, 'storeStudentStory'])->name('student-stories.store');
        Route::put('/student-stories/{story}', [SiteContentController::class, 'updateStudentStory'])->name('student-stories.update');
        Route::delete('/student-stories/{story}', [SiteContentController::class, 'destroyStudentStory'])->name('student-stories.destroy');
        Route::patch('/student-stories/order', [SiteContentController::class, 'updateStoryOrder'])->name('student-stories.order');
    });

    // Admin System Settings Routes
    Route::prefix('admin/system-settings')->name('admin.system-settings.')->middleware('role:admin')->group(function () {
        Route::get('/', [SystemSettingsController::class, 'index'])->name('index');
        Route::post('/', [SystemSettingsController::class, 'update'])->name('update');
    });

    // Support Chat Routes (formerly Complaints) - Live chat system
    Route::get('/complaints', [\App\Http\Controllers\ComplaintController::class, 'index'])
         ->middleware('role:admin,teacher')->name('complaints.index');
    Route::get('/complaints/create', [\App\Http\Controllers\ComplaintController::class, 'create'])
         ->middleware('role:admin,teacher')->name('complaints.create');
    Route::post('/complaints', [\App\Http\Controllers\ComplaintController::class, 'store'])
         ->middleware('role:admin,teacher')->name('complaints.store');
    
    // Live Chat Routes
    Route::get('/complaints/chat/{sessionId}', [\App\Http\Controllers\ComplaintController::class, 'chat'])
         ->middleware('role:admin,teacher')->name('complaints.chat');
    Route::post('/complaints/chat/{sessionId}/assign', [\App\Http\Controllers\ComplaintController::class, 'assignChat'])
         ->middleware('role:admin,teacher')->name('complaints.assign');
    Route::post('/complaints/chat/{sessionId}/close', [\App\Http\Controllers\ComplaintController::class, 'closeChat'])
         ->middleware('role:admin,teacher')->name('complaints.close');
    Route::post('/complaints/chat/{sessionId}/message', [\App\Http\Controllers\ComplaintController::class, 'sendMessage'])
         ->middleware('role:admin,teacher')->name('complaints.message');
    
    // Legacy route redirect
    Route::get('/complaints/{complaint}', [\App\Http\Controllers\ComplaintController::class, 'show'])->name('complaints.show');

    // Reports Routes - Admin only
    Route::get('/reports', [\App\Http\Controllers\ReportController::class, 'index'])->middleware('role:admin')->name('reports.index');

    // Settings Routes - Admin only for system settings, users for personal settings
    Route::get('/settings', [\App\Http\Controllers\SettingController::class, 'index'])->middleware('role:admin')->name('settings.index');
    Route::post('/settings', [\App\Http\Controllers\SettingController::class, 'update'])->middleware('role:admin')->name('settings.update');

    // Role Management Routes - Admin only
    Route::middleware('role:admin')->prefix('admin/roles')->name('admin.roles.')->group(function () {
        Route::get('/', [\App\Http\Controllers\Admin\RoleController::class, 'index'])->name('index');
        Route::get('/create', [\App\Http\Controllers\Admin\RoleController::class, 'create'])->name('create');
        Route::post('/', [\App\Http\Controllers\Admin\RoleController::class, 'store'])->name('store');
        Route::get('/{role}', [\App\Http\Controllers\Admin\RoleController::class, 'show'])->name('show');
        Route::get('/{role}/edit', [\App\Http\Controllers\Admin\RoleController::class, 'edit'])->name('edit');
        Route::put('/{role}', [\App\Http\Controllers\Admin\RoleController::class, 'update'])->name('update');
        Route::delete('/{role}', [\App\Http\Controllers\Admin\RoleController::class, 'destroy'])->name('destroy');
        Route::post('/{role}/toggle', [\App\Http\Controllers\Admin\RoleController::class, 'toggle'])->name('toggle');
        
        // User role assignment
        Route::post('/assign', [\App\Http\Controllers\Admin\RoleController::class, 'assignRole'])->name('assign');
        Route::post('/revoke', [\App\Http\Controllers\Admin\RoleController::class, 'revokeRole'])->name('revoke');
    });

    Route::get('/notifications', [\App\Http\Controllers\NotificationController::class, 'index'])->name('notifications.index');
    Route::post('/notifications/{notification}/read', [\App\Http\Controllers\NotificationController::class, 'markAsRead'])->name('notifications.read');
    Route::post('/notifications/read-all', [\App\Http\Controllers\NotificationController::class, 'markAllAsRead'])->name('notifications.read-all');
    Route::get('/api/notifications/count', [\App\Http\Controllers\NotificationController::class, 'getUnreadCount'])->name('notifications.count');

    // Account Settings Route (from dropdown)
    Route::get('/account-settings', function () {
        return Inertia::render('Profile/AccountSettings');
    })->name('account.settings');

    // Admin enrollment management (only for admin users)
    Route::middleware(['auth', 'role:admin'])->prefix('admin')->name('admin.')->group(function () {
        Route::get('/enrollments', [EnrollmentController::class, 'index'])->name('enrollments.index');
        Route::get('/enrollments/{enrollment}', [EnrollmentController::class, 'show'])->name('enrollments.show');
        Route::patch('/enrollments/{enrollment}/approve', [EnrollmentController::class, 'approve'])->name('enrollments.approve');
        Route::patch('/enrollments/{enrollment}/reject', [EnrollmentController::class, 'reject'])->name('enrollments.reject');
        Route::get('/enrollments/{enrollment}/payment-proof', [EnrollmentController::class, 'viewPaymentProof'])->name('enrollments.payment-proof');
        
        // Admin extension management
        Route::post('/extensions/{payment}/approve', [\App\Http\Controllers\ExtensionController::class, 'approve'])->name('extensions.approve');
        
        // Admin payment methods management
        Route::resource('payment-methods', \App\Http\Controllers\Admin\PaymentMethodController::class);
        Route::post('payment-methods/{paymentMethod}/toggle', [\App\Http\Controllers\Admin\PaymentMethodController::class, 'toggle'])->name('payment-methods.toggle');
    });

    // Chat Routes
    Route::prefix('chat')->name('chat.')->group(function () {
        Route::get('/', [\App\Http\Controllers\ChatController::class, 'index'])->name('index');
        Route::get('/create', [\App\Http\Controllers\ChatController::class, 'create'])->name('create');
        Route::post('/', [\App\Http\Controllers\ChatController::class, 'store'])->name('store');
        Route::get('/{chatGroup}', [\App\Http\Controllers\ChatController::class, 'show'])->name('show');
        Route::post('/{chatGroup}/messages', [\App\Http\Controllers\ChatController::class, 'storeMessage'])->name('storeMessage');
        Route::get('/{chatGroup}/messages', [\App\Http\Controllers\ChatController::class, 'getMessages'])->name('getMessages');
        Route::post('/{chatGroup}/join', [\App\Http\Controllers\ChatController::class, 'join'])->name('join');
        Route::post('/{chatGroup}/leave', [\App\Http\Controllers\ChatController::class, 'leave'])->name('leave');
        Route::post('/{chatGroup}/add-member', [\App\Http\Controllers\ChatController::class, 'addMember'])->name('addMember');
        Route::delete('/{chatGroup}/remove-member/{user}', [\App\Http\Controllers\ChatController::class, 'removeMember'])->name('removeMember');
    });

    // Library Routes
    Route::prefix('library')->name('library.')->group(function () {
        Route::get('/', [\App\Http\Controllers\LibraryController::class, 'index'])->name('index');
        Route::get('/books', [\App\Http\Controllers\LibraryController::class, 'books'])->name('books');
        Route::get('/past-papers', [\App\Http\Controllers\LibraryController::class, 'pastPapers'])->name('pastPapers');
        Route::get('/search', [\App\Http\Controllers\LibraryController::class, 'search'])->name('search');
        Route::get('/{resource}', [\App\Http\Controllers\LibraryController::class, 'show'])->name('show');
        Route::get('/{resource}/stream', [\App\Http\Controllers\LibraryController::class, 'stream'])->name('stream');
    });
    
    // Admin Library Management Routes
    Route::middleware('role:admin')->prefix('admin/library')->name('admin.library.')->group(function () {
        Route::get('/', [\App\Http\Controllers\Admin\LibraryController::class, 'index'])->name('index');
        Route::get('/create', [\App\Http\Controllers\Admin\LibraryController::class, 'create'])->name('create');
        Route::post('/', [\App\Http\Controllers\Admin\LibraryController::class, 'store'])->name('store');
        Route::get('/{resource}', [\App\Http\Controllers\Admin\LibraryController::class, 'show'])->name('show');
        Route::get('/{resource}/edit', [\App\Http\Controllers\Admin\LibraryController::class, 'edit'])->name('edit');
        Route::put('/{resource}', [\App\Http\Controllers\Admin\LibraryController::class, 'update'])->name('update');
        Route::delete('/{resource}', [\App\Http\Controllers\Admin\LibraryController::class, 'destroy'])->name('destroy');
        Route::patch('/{resource}/toggle', [\App\Http\Controllers\Admin\LibraryController::class, 'toggle'])->name('toggle');
        
        // Bulk operations
        Route::post('/bulk-upload', [\App\Http\Controllers\Admin\LibraryController::class, 'bulkUpload'])->name('bulk-upload');
        Route::patch('/bulk-action', [\App\Http\Controllers\Admin\LibraryController::class, 'bulkAction'])->name('bulk-action');
        
        // Categories and metadata
        Route::get('/categories/manage', [\App\Http\Controllers\Admin\LibraryController::class, 'manageCategories'])->name('categories.manage');
        Route::post('/categories', [\App\Http\Controllers\Admin\LibraryController::class, 'storeCategory'])->name('categories.store');
        Route::delete('/categories/{category}', [\App\Http\Controllers\Admin\LibraryController::class, 'destroyCategory'])->name('categories.destroy');
    });

    // Achievement Routes
    Route::prefix('achievements')->name('achievements.')->group(function () {
        Route::get('/', [\App\Http\Controllers\AchievementController::class, 'index'])->name('index');
        Route::get('/leaderboard', [\App\Http\Controllers\AchievementController::class, 'leaderboard'])->name('leaderboard');
        Route::get('/{achievement}', [\App\Http\Controllers\AchievementController::class, 'show'])->name('show');
    });

    // School Selection Routes (Students only)
    Route::prefix('school-selections')->name('school-selections.')->group(function () {
        Route::get('/', [\App\Http\Controllers\SchoolSelectionController::class, 'index'])->name('index');
        Route::post('/', [\App\Http\Controllers\SchoolSelectionController::class, 'store'])->name('store');
        Route::put('/{selection}', [\App\Http\Controllers\SchoolSelectionController::class, 'update'])->name('update');
        Route::delete('/{selection}', [\App\Http\Controllers\SchoolSelectionController::class, 'destroy'])->name('destroy');
    });

    // Admin School Selection Management
    Route::middleware('role:admin')->prefix('admin/school-selections')->name('admin.school-selections.')->group(function () {
        Route::get('/', [\App\Http\Controllers\SchoolSelectionController::class, 'adminIndex'])->name('index');
        Route::patch('/{selection}', [\App\Http\Controllers\SchoolSelectionController::class, 'adminUpdate'])->name('update');
    });

    // Teacher Routes
    Route::middleware('role:teacher')->prefix('teacher')->name('teacher.')->group(function () {
        Route::get('/students', function () {
            $user = auth()->user();
            $assignedEnrollments = \App\Models\Enrollment::where('assigned_tutor_id', $user->id)
                ->with('user')
                ->where('status', 'approved')
                ->get();
                
            $assignedStudents = $assignedEnrollments->map(function ($enrollment) {
                return [
                    'id' => $enrollment->user ? $enrollment->user->id : null,
                    'name' => $enrollment->user ? $enrollment->user->name : $enrollment->name,
                    'email' => $enrollment->email,
                    'enrollment_id' => $enrollment->id,
                    'subjects_count' => count($enrollment->selected_subjects ?: []),
                    'access_expires_at' => $enrollment->access_expires_at,
                    'is_trial' => $enrollment->is_trial,
                    'status' => $enrollment->status,
                    'tutor_assigned_at' => $enrollment->tutor_assigned_at
                ];
            });

            return Inertia::render('Teacher/Students/Index', [
                'assignedStudents' => $assignedStudents,
                'stats' => [
                    'assigned_students' => $assignedEnrollments->count(),
                    'active_students' => $assignedEnrollments->where('access_expires_at', '>', now())->count(),
                    'trial_students' => $assignedEnrollments->where('is_trial', true)->count(),
                ]
            ]);
        })->name('students.index');
    });
});

require __DIR__.'/auth.php';
