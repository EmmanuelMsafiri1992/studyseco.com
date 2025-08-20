<?php

use App\Http\Controllers\ProfileController;
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

    Route::get('/subjects', function () {
        return Inertia::render('Subjects/Index', [
            'subjects' => []
        ]);
    })->name('subjects.index');

    Route::get('/subjects/create', function () {
        return Inertia::render('Subjects/Create');
    })->name('subjects.create');

    Route::get('/fees', function () {
        return Inertia::render('Fees/Index', [
            'fees' => []
        ]);
    })->name('fees.index');

    Route::get('/fees/create', function () {
        return Inertia::render('Fees/Create');
    })->name('fees.create');

    Route::get('/payments', function () {
        return Inertia::render('Payments/Index', [
            'payments' => []
        ]);
    })->name('payments.index');

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
