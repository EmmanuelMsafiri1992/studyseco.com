<?php

namespace App\Http\Controllers\Student;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Models\Enrollment;
use App\Models\Subject;
use App\Models\AccessDuration;

class EnrollmentController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        $enrollment = Enrollment::where('user_id', $user->id)
            ->orWhere('email', $user->email)
            ->first();

        $availableSubjects = Subject::where('is_active', true)
            ->orderBy('department')
            ->orderBy('name')
            ->get()
            ->map(function ($subject) {
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
                ];
            });

        $accessDurations = AccessDuration::where('is_active', true)
            ->orderBy('sort_order')
            ->get();

        return Inertia::render('Student/Enrollment/Index', [
            'enrollment' => $enrollment,
            'availableSubjects' => $availableSubjects,
            'accessDurations' => $accessDurations,
            'enrollmentStatus' => $enrollment ? [
                'status' => $enrollment->status,
                'is_trial' => $enrollment->is_trial,
                'subjects_count' => count($enrollment->selected_subjects ?: []),
                'access_expires_at' => $enrollment->access_expires_at,
                'access_days_remaining' => $enrollment->access_days_remaining,
            ] : null
        ]);
    }

    public function show()
    {
        $user = auth()->user();
        $enrollment = Enrollment::where('user_id', $user->id)
            ->orWhere('email', $user->email)
            ->first();

        if (!$enrollment) {
            return redirect()->route('student.enrollment.index')
                ->with('error', 'No enrollment found. Please enroll first.');
        }

        return Inertia::render('Student/Enrollment/Show', [
            'enrollment' => $enrollment,
            'enrollmentDetails' => [
                'id' => $enrollment->id,
                'status' => $enrollment->status,
                'is_trial' => $enrollment->is_trial,
                'subjects' => $enrollment->selected_subjects ?: [],
                'created_at' => $enrollment->created_at,
                'access_expires_at' => $enrollment->access_expires_at,
                'access_days_remaining' => $enrollment->access_days_remaining,
                'is_access_expired' => $enrollment->is_access_expired,
            ]
        ]);
    }
}