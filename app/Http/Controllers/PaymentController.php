<?php

namespace App\Http\Controllers;

use App\Models\EnrollmentPayment;
use App\Models\PaymentMethod;
use App\Models\AccessDuration;
use App\Models\Enrollment;
use App\Services\AuditService;
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
                ->latest()
                ->paginate(10);
        }

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
            } catch (Exception $e) {
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
            'payments' => $payments,
            'hasValidAccess' => $hasValidAccess,
            'stats' => $stats
        ]);
    }

    /**
     * Show the payment submission form
     */
    public function create()
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

        return Inertia::render('Payments/Create', [
            'auth' => ['user' => $user],
            'hasPendingPayment' => $hasPendingPayment,
            'paymentMethods' => $paymentMethods,
            'accessDurations' => $accessDurations,
        ]);
    }

    /**
     * Store a newly created payment submission
     */
    public function store(Request $request)
    {
        // Get valid payment method keys and access duration IDs
        $validPaymentMethodKeys = PaymentMethod::active()->pluck('key')->toArray();
        $validAccessDurationIds = AccessDuration::active()->pluck('id')->toArray();

        $validated = $request->validate([
            'payment_method' => ['required', Rule::in($validPaymentMethodKeys)],
            'amount' => 'required|numeric|min:1|max:999999.99',
            'reference_number' => 'nullable|string|max:255',
            'proof_screenshot' => 'nullable|image|mimes:jpeg,png,jpg|max:5120', // 5MB max
            'access_duration_id' => ['required', Rule::in($validAccessDurationIds)]
        ]);

        $user = auth()->user();

        // Get or create enrollment
        $enrollment = Enrollment::where('user_id', $user->id)->orWhere('email', $user->email)->first();
        if (!$enrollment) {
            return back()->withErrors(['error' => 'Enrollment not found. Please enroll first.']);
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
            'payment_method_id' => PaymentMethod::where('key', $validated['payment_method'])->first()?->id,
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
}
