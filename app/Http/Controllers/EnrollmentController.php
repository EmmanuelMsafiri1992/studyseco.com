<?php

namespace App\Http\Controllers;

use App\Models\Enrollment;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Inertia\Inertia;

class EnrollmentController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'phone' => 'required|string|max:20',
            'address' => 'required|string|max:500',
            'selected_subjects' => 'required|array|min:1',
            'selected_subjects.*' => 'integer|min:1|max:12',
            'payment_method' => 'required|in:tnm_mpamba,airtel_money,bank_transfer',
            'payment_reference' => 'required|string|max:255',
            'payment_proof' => 'required|file|mimes:jpg,jpeg,png,pdf|max:5120' // 5MB max
        ]);

        if ($validator->fails()) {
            return back()->withErrors($validator)->withInput();
        }

        $validated = $validator->validated();

        // Calculate total amount (MKW 50,000 per subject)
        $subjectPrice = 50000;
        $totalAmount = count($validated['selected_subjects']) * $subjectPrice;

        // Handle payment proof upload
        $paymentProofPath = null;
        if ($request->hasFile('payment_proof')) {
            $paymentProofPath = $request->file('payment_proof')->store('payment_proofs', 'public');
        }

        // Create enrollment record
        $enrollment = Enrollment::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'phone' => $validated['phone'],
            'address' => $validated['address'],
            'selected_subjects' => $validated['selected_subjects'],
            'total_amount' => $totalAmount,
            'payment_method' => $validated['payment_method'],
            'payment_reference' => $validated['payment_reference'],
            'payment_proof_path' => $paymentProofPath,
            'status' => 'pending'
        ]);

        return redirect()->route('enrollment.success')->with('enrollment_id', $enrollment->id);
    }

    public function success(Request $request)
    {
        $enrollmentId = session('enrollment_id');
        if (!$enrollmentId) {
            return redirect()->route('welcome');
        }

        $enrollment = Enrollment::find($enrollmentId);
        if (!$enrollment) {
            return redirect()->route('welcome');
        }

        return Inertia::render('EnrollmentSuccess', [
            'enrollment' => $enrollment,
            'subjectNames' => $enrollment->selected_subjects_names
        ]);
    }

    // Admin methods
    public function index()
    {
        $enrollments = Enrollment::with('user')
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        return Inertia::render('Admin/Enrollments/Index', [
            'enrollments' => $enrollments
        ]);
    }

    public function show(Enrollment $enrollment)
    {
        $enrollment->load('user');
        
        return Inertia::render('Admin/Enrollments/Show', [
            'enrollment' => $enrollment,
            'subjectNames' => $enrollment->selected_subjects_names
        ]);
    }

    public function approve(Enrollment $enrollment)
    {
        $enrollment->update(['status' => 'approved']);

        // Optionally create user account if doesn't exist
        $user = User::where('email', $enrollment->email)->first();
        if (!$user) {
            $user = User::create([
                'name' => $enrollment->name,
                'email' => $enrollment->email,
                'password' => bcrypt('temporary_password_' . rand(100000, 999999)),
                'role' => 'student'
            ]);
            
            $enrollment->update(['user_id' => $user->id]);
        }

        return redirect()->back()->with('message', 'Enrollment approved successfully!');
    }

    public function reject(Request $request, Enrollment $enrollment)
    {
        $request->validate([
            'admin_notes' => 'nullable|string|max:500'
        ]);

        $enrollment->update([
            'status' => 'rejected',
            'admin_notes' => $request->admin_notes
        ]);

        return redirect()->back()->with('message', 'Enrollment rejected.');
    }
}
