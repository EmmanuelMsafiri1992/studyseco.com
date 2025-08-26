<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\SubjectController;
use App\Http\Controllers\TopicController;
use App\Http\Controllers\LessonController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\Admin\PaymentSettingsController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::get('/dashboard', function () {
    return Inertia::render('Dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    // Profile Routes
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    // School Management Routes
    Route::get('/students', function () {
        return Inertia::render('Students/Index', [
            // You can pass mock data here later
            'students' => []
        ]);
    })->name('students.index');

    Route::get('/students/create', function () {
        return Inertia::render('Students/Create');
    })->name('students.create');

    Route::get('/teachers', function () {
        return Inertia::render('Teachers/Index', [
            'teachers' => []
        ]);
    })->name('teachers.index');

    Route::get('/teachers/create', function () {
        return Inertia::render('Teachers/Create');
    })->name('teachers.create');

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

    // Payment Management Routes
    Route::resource('payments', PaymentController::class)->except(['edit', 'update', 'destroy']);
    Route::post('payments/{payment}/verify', [PaymentController::class, 'verify'])->name('payments.verify');
    Route::get('payments/statistics', [PaymentController::class, 'statistics'])->name('payments.statistics');
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

    Route::get('/complaints', function () {
        return Inertia::render('Complaints/Index', [
            'complaints' => []
        ]);
    })->name('complaints.index');

    Route::get('/complaints/create', function () {
        return Inertia::render('Complaints/Create');
    })->name('complaints.create');

    Route::get('/reports', function () {
        return Inertia::render('Reports/Index');
    })->name('reports.index');

    Route::get('/settings', function () {
        return Inertia::render('Settings/Index');
    })->name('settings.index');

    Route::get('/notifications', function () {
        return Inertia::render('Notifications/Index', [
            'notifications' => []
        ]);
    })->name('notifications.index');

    // Account Settings Route (from dropdown)
    Route::get('/account-settings', function () {
        return Inertia::render('Profile/AccountSettings');
    })->name('account.settings');
});

require __DIR__.'/auth.php';
