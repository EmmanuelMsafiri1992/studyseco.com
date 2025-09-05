<?php

namespace App\Http\Controllers;

use App\Models\EnrollmentPayment;
use App\Models\PaymentMethod;
use App\Models\AccessDuration;
use App\Models\Enrollment;
use App\Models\Subject;
use App\Services\AuditService;
use App\Notifications\PaymentApproved;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Carbon\Carbon;

class PaymentController extends Controller
{
    /**
     * Display a listing of payments for admin (pending verification)
     */
    public function index()
    {
        $user = auth()->user();

        // Admin sees all payments for verification
        if ($user->role === 'admin') {
            $payments = EnrollmentPayment::with(['enrollment.user'])
                ->latest()
                ->paginate(20);

            // Calculate stats
            $stats = [
                'total_payments' => EnrollmentPayment::count(),
                'pending_payments' => EnrollmentPayment::where('status', 'pending')->count(),
                'verified_payments' => EnrollmentPayment::where('status', 'verified')->count(),
                'rejected_payments' => EnrollmentPayment::where('status', 'rejected')->count(),
                'total_revenue' => EnrollmentPayment::where('status', 'verified')->sum('amount'),
                'pending_revenue' => EnrollmentPayment::where('status', 'pending')->sum('amount'),
            ];

            return Inertia::render('Payments/Admin/Index', [
                'payments' => $payments,
                'stats' => $stats
            ]);
        }

        // Students see their own payment history
        $enrollment = Enrollment::where('user_id', $user->id)->orWhere('email', $user->email)->first();
        $payments = collect([]);
        
        if ($enrollment) {
            $payments = EnrollmentPayment::where('enrollment_id', $enrollment->id)
                ->with(['paymentMethod'])
                ->latest()
                ->get()
                ->map(function ($payment) {
                    return [
                        'id' => $payment->id,
                        'amount' => $payment->amount,
                        'currency' => $payment->currency,
                        'status' => $payment->status,
                        'payment_method' => $payment->paymentMethod->code ?? $payment->payment_method,
                        'payment_method_name' => $payment->paymentMethod->name ?? 'Unknown',
                        'reference_number' => $payment->reference_number,
                        'access_duration_days' => $payment->extension_months ? $payment->extension_months * 30 : 30,
                        'access_expires_at' => $payment->status === 'verified' ? $payment->enrollment->access_expires_at : null,
                        'created_at' => $payment->created_at,
                        'verified_at' => $payment->verified_at,
                        'admin_notes' => $payment->admin_notes,
                        'rejection_reason' => $payment->admin_notes && $payment->status === 'rejected' ? $payment->admin_notes : null,
                    ];
                });
        }

        // Create pagination-like structure for the frontend
        $paginatedPayments = (object) [
            'data' => $payments,
            'total' => $payments->count(),
            'current_page' => 1,
            'last_page' => 1,
            'per_page' => $payments->count(),
            'links' => []
        ];

        $hasValidAccess = $enrollment && $enrollment->access_expires_at && $enrollment->access_expires_at->greaterThan(Carbon::now());

        // Get stats for sidebar (if admin)
        $stats = [];
        if ($user->role === 'admin') {
            try {
                $stats = [
                    'total_students' => \App\Models\User::where('role', 'student')->count(),
                    'total_teachers' => \App\Models\User::where('role', 'teacher')->count(),
                    'total_subjects' => \App\Models\Subject::where('is_active', true)->count(),
                    'pending_enrollments' => \App\Models\Enrollment::where('status', 'pending')->count(),
                ];
            } catch (\Exception $e) {
                // Fallback if queries fail
                $stats = [
                    'total_students' => 0,
                    'total_teachers' => 0,
                    'total_subjects' => 0,
                    'pending_enrollments' => 0,
                ];
            }
        }

        return Inertia::render('Payments/Index', [
            'payments' => $paginatedPayments,
            'hasValidAccess' => $hasValidAccess,
            'stats' => $stats
        ]);
    }

    /**
     * Show the payment submission form
     */
    public function create(Request $request)
    {
        $user = auth()->user();

        // Check if user has pending payment through enrollment
        $enrollment = Enrollment::where('user_id', $user->id)->orWhere('email', $user->email)->first();
        $hasPendingPayment = $enrollment && EnrollmentPayment::where('enrollment_id', $enrollment->id)
            ->where('status', 'pending')
            ->exists();

        // Get active payment methods and access durations from database
        $paymentMethods = PaymentMethod::active()->get();
        $accessDurations = AccessDuration::active()->get();

        // Ensure we have some subjects in the database
        $this->ensureSubjectsExist();
        
        // Get available subjects
        $availableSubjects = Subject::where('is_active', true)
            ->orderBy('department')
            ->orderBy('name')
            ->get()
            ->map(function ($subject) {
                return [
                    'id' => (int) $subject->id, // Ensure it's an integer
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
                ];
            });

        // Add user country to user object for frontend filtering
        $userWithCountry = $user->toArray();
        $userWithCountry['country'] = $user->country ?? 'Malawi'; // Default to Malawi if not set

        // Check if this is an upgrade request
        $isUpgrade = $request->has('upgrade') && $request->get('upgrade') === 'true';

        // Debug: Log what subjects we're sending to frontend
        \Log::info('Subjects being sent to frontend:', [
            'count' => $availableSubjects->count(),
            'ids' => $availableSubjects->pluck('id')->toArray()
        ]);

        return Inertia::render('Payments/Create', [
            'auth' => ['user' => $userWithCountry],
            'hasPendingPayment' => $hasPendingPayment,
            'paymentMethods' => $paymentMethods,
            'accessDurations' => $accessDurations,
            'availableSubjects' => $availableSubjects,
            'enrollment' => $enrollment,
            'isUpgrade' => $isUpgrade,
        ]);
    }

    /**
     * Store a newly created payment submission
     */
    public function store(Request $request)
    {
        // Get valid payment method codes and access duration IDs
        $validPaymentMethodCodes = PaymentMethod::active()->pluck('code')->toArray();
        $validAccessDurationIds = AccessDuration::active()->pluck('id')->toArray();

        // Debug: Log the request data
        \Log::info('Payment request data:', $request->all());
        \Log::info('Available subjects:', Subject::where('is_active', true)->pluck('id')->toArray());
        
        // Check if this is an upgrade request
        $isUpgrade = $request->boolean('upgrade') || 
                     $request->has('selected_subjects') || 
                     $request->get('upgrade') === 'true';
        
        $rules = [
            'payment_method' => ['required', Rule::in($validPaymentMethodCodes)],
            'amount' => 'required|numeric|min:1|max:999999.99',
            'reference_number' => 'required|string|max:255',
            'proof_screenshot' => 'nullable|image|mimes:jpeg,png,jpg|max:5120', // 5MB max
            'access_duration_id' => ['required', Rule::in($validAccessDurationIds)],
        ];
        
        // Get valid subject IDs for validation
        $validSubjectIds = Subject::where('is_active', true)->pluck('id')->toArray();
        
        // Only require subject selection for upgrades
        if ($isUpgrade) {
            $rules['selected_subjects'] = 'required|array|min:1';
            $rules['selected_subjects.*'] = ['integer', Rule::in($validSubjectIds)];
        } else {
            $rules['selected_subjects'] = 'nullable|array';
            $rules['selected_subjects.*'] = ['integer', Rule::in($validSubjectIds)];
        }
        
        // Check if subjects table has data
        $subjectCount = Subject::where('is_active', true)->count();
        if ($isUpgrade && $subjectCount === 0) {
            return back()->withErrors(['error' => 'No active subjects available. Please contact support.']);
        }
        
        // Debug: Check what subjects are being sent vs what exists
        if ($request->has('selected_subjects') && is_array($request->get('selected_subjects'))) {
            $requestedSubjects = $request->get('selected_subjects');
            $validSubjects = Subject::where('is_active', true)->pluck('id')->toArray();
            $invalidSubjects = array_diff($requestedSubjects, $validSubjects);
            
            if (!empty($invalidSubjects)) {
                \Log::error('Invalid subjects requested:', [
                    'requested' => $requestedSubjects,
                    'valid_subjects' => $validSubjects,
                    'invalid' => $invalidSubjects
                ]);
            }
        }
        
        $validated = $request->validate($rules);

        $user = auth()->user();

        // Get or create enrollment
        $enrollment = Enrollment::where('user_id', $user->id)->orWhere('email', $user->email)->first();
        if (!$enrollment) {
            return back()->withErrors(['error' => 'Enrollment not found. Please enroll first.']);
        }

        // Update enrollment with selected subjects (for premium upgrade)
        if (!empty($validated['selected_subjects'])) {
            $enrollment->update([
                'selected_subjects' => $validated['selected_subjects'],
                'is_trial' => false, // Upgrade to premium
            ]);
        }

        // Check if user already has pending payment
        if (EnrollmentPayment::where('enrollment_id', $enrollment->id)->where('status', 'pending')->exists()) {
            return back()->withErrors(['error' => 'You already have a pending payment. Please wait for verification.']);
        }

        // Handle screenshot upload
        $paymentProofPath = null;
        if ($request->hasFile('proof_screenshot')) {
            $paymentProofPath = $request->file('proof_screenshot')->store('payment-proofs', 'public');
        }

        // Get access duration details
        $accessDuration = AccessDuration::find($validated['access_duration_id']);

        // Create enrollment payment record
        $payment = EnrollmentPayment::create([
            'enrollment_id' => $enrollment->id,
            'payment_method_id' => PaymentMethod::where('code', $validated['payment_method'])->first()?->id,
            'reference_number' => $validated['reference_number'],
            'amount' => $validated['amount'],
            'currency' => 'MWK',
            'payment_proof_path' => $paymentProofPath,
            'extension_months' => $accessDuration->months ?? ($accessDuration->days / 30),
            'status' => 'pending'
        ]);

        // Log the payment creation
        AuditService::logPayment($payment, 'created');

        return redirect()->route('payments.index')->with('success', 'Payment submitted successfully! Your payment is being verified. You will receive access once approved.');
    }


    /**
     * Display the specified payment
     */
    public function show(EnrollmentPayment $payment)
    {
        $user = auth()->user();

        // Only admin or payment owner can view
        if ($user->role !== 'admin' && $payment->enrollment->user_id !== $user->id) {
            abort(403);
        }

        $payment->load(['enrollment.user', 'verifiedBy', 'paymentMethod']);

        return Inertia::render('Payments/Show', [
            'payment' => $payment
        ]);
    }

    /**
     * Verify/Approve a payment (admin only)
     */
    public function verify(Request $request, EnrollmentPayment $payment)
    {
        if (auth()->user()->role !== 'admin') {
            abort(403, 'Only administrators can verify payments.');
        }

        $request->validate([
            'action' => 'required|in:approve,reject',
            'notes' => 'nullable|string|max:500',
            'rejection_reason' => 'required_if:action,reject|string|max:500'
        ]);

        if ($request->action === 'approve') {
            $payment->update([
                'status' => 'verified',
                'verified_at' => now(),
                'verified_by' => auth()->id(),
                'admin_notes' => $request->notes
            ]);

            // Update enrollment access
            $enrollment = $payment->enrollment;
            if ($enrollment) {
                $enrollment->update([
                    'status' => 'approved',
                    'approved_at' => now(),
                    'approved_by' => auth()->id()
                ]);
                
                // Send congratulatory notification
                $enrollment->user->notify(new PaymentApproved($enrollment, $payment));
                
                // Log access granted
                AuditService::logAccess($enrollment->user, true);
            }

            // Log payment verification
            AuditService::logPayment($payment, 'approved');

            return redirect()->back()->with('success', 'Payment verified and access granted successfully.');
        } else {
            $payment->update([
                'status' => 'rejected',
                'verified_at' => now(),
                'verified_by' => auth()->id(),
                'admin_notes' => $request->rejection_reason
            ]);

            // Log payment rejection
            AuditService::logPayment($payment, 'rejected');

            return redirect()->back()->with('success', 'Payment rejected successfully.');
        }
    }

    /**
     * Get payment statistics for admin dashboard
     */
    public function statistics()
    {
        if (auth()->user()->role !== 'admin') {
            abort(403, 'Only administrators can view payment statistics.');
        }

        $stats = [
            'pending_count' => EnrollmentPayment::where('status', 'pending')->count(),
            'approved_today' => EnrollmentPayment::where('status', 'verified')->whereDate('verified_at', today())->count(),
            'total_revenue' => EnrollmentPayment::where('status', 'verified')->sum('amount'),
            'pending_revenue' => EnrollmentPayment::where('status', 'pending')->sum('amount'),
            'active_subscriptions' => Enrollment::where('status', 'approved')
                ->where('access_expires_at', '>', Carbon::now())
                ->count()
        ];

        return response()->json($stats);
    }

    /**
     * Check if user has valid access
     */
    public function checkAccess()
    {
        $user = auth()->user();
        $enrollment = Enrollment::where('user_id', $user->id)->orWhere('email', $user->email)->first();
        
        $hasAccess = $enrollment && $enrollment->access_expires_at && $enrollment->access_expires_at->greaterThan(Carbon::now());

        return response()->json([
            'hasAccess' => $hasAccess,
            'expiresAt' => $enrollment?->access_expires_at,
            'daysRemaining' => $enrollment?->access_days_remaining ?? 0,
            'isTrialExpired' => $enrollment?->is_trial_expired ?? false
        ]);
    }
    
    /**
     * Ensure basic subjects exist in the database
     */
    private function ensureSubjectsExist()
    {
        // Check if subjects table is empty
        if (Subject::count() === 0) {
            $subjects = [
                ['name' => 'English', 'code' => 'ENG', 'department' => 'Languages', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'Chichewa', 'code' => 'CHI', 'department' => 'Languages', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'Mathematics', 'code' => 'MATH', 'department' => 'Sciences', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'Life Skills', 'code' => 'LIFE', 'department' => 'General', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'Biology', 'code' => 'BIO', 'department' => 'Sciences', 'grade_level' => 'Form 3-4', 'is_active' => true],
                ['name' => 'Physical Science', 'code' => 'PHYS', 'department' => 'Sciences', 'grade_level' => 'Form 1-2', 'is_active' => true],
                ['name' => 'Chemistry', 'code' => 'CHEM', 'department' => 'Sciences', 'grade_level' => 'Form 3-4', 'is_active' => true],
                ['name' => 'Physics', 'code' => 'PHY', 'department' => 'Sciences', 'grade_level' => 'Form 3-4', 'is_active' => true],
                ['name' => 'Geography', 'code' => 'GEO', 'department' => 'Humanities', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'History', 'code' => 'HIST', 'department' => 'Humanities', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'Social Studies', 'code' => 'SOC', 'department' => 'Humanities', 'grade_level' => 'Form 1-2', 'is_active' => true],
                ['name' => 'Bible Knowledge', 'code' => 'BK', 'department' => 'Religious', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'Agriculture', 'code' => 'AGR', 'department' => 'Practical', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'Home Economics', 'code' => 'HE', 'department' => 'Practical', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'Technical Drawing', 'code' => 'TD', 'department' => 'Technical', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'Business Studies', 'code' => 'BUS', 'department' => 'Commercial', 'grade_level' => 'Form 1-4', 'is_active' => true],
                ['name' => 'Computer Studies', 'code' => 'CS', 'department' => 'Technical', 'grade_level' => 'Form 1-4', 'is_active' => true],
            ];

            foreach ($subjects as $subject) {
                Subject::create($subject);
            }
        }
    }
}
