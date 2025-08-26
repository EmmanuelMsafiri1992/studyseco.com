<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use App\Models\PaymentMethod;
use App\Models\AccessDuration;
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
            $payments = Payment::with(['user', 'verifiedBy'])
                ->latest()
                ->paginate(20);

            return Inertia::render('Payments/Admin/Index', [
                'payments' => $payments
            ]);
        }

        // Students see their own payment history
        $payments = Payment::where('user_id', $user->id)
            ->latest()
            ->paginate(10);

        $hasValidAccess = Payment::where('user_id', $user->id)
            ->approved()
            ->where('access_expires_at', '>', Carbon::now())
            ->exists();

        return Inertia::render('Payments/Index', [
            'payments' => $payments,
            'hasValidAccess' => $hasValidAccess
        ]);
    }

    /**
     * Show the payment submission form
     */
    public function create()
    {
        $user = auth()->user();

        // Check if user has pending payment
        $hasPendingPayment = Payment::where('user_id', $user->id)
            ->pending()
            ->exists();

        // Get active payment methods and access durations from database
        $paymentMethods = PaymentMethod::active()->get();
        $accessDurations = AccessDuration::active()->get();

        return Inertia::render('Payments/Create', [
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

        // Check if user already has pending payment
        if (Payment::where('user_id', $user->id)->pending()->exists()) {
            return back()->withErrors(['error' => 'You already have a pending payment. Please wait for verification.']);
        }

        // Handle screenshot upload
        if ($request->hasFile('proof_screenshot')) {
            $path = $request->file('proof_screenshot')->store('payment-proofs', 'public');
            $validated['proof_screenshot'] = $path;
        }

        // Get access duration details
        $accessDuration = AccessDuration::find($validated['access_duration_id']);

        // Create payment record
        $validated['user_id'] = $user->id;
        $validated['status'] = 'pending';
        $validated['access_duration_days'] = $accessDuration->days;

        // Remove access_duration_id from the array as it's not a column in payments table
        unset($validated['access_duration_id']);

        Payment::create($validated);

        return redirect()->route('payments.index')->with('success', 'Payment submitted successfully! Your payment is being verified. You will receive access once approved.');
    }

    /**
     * Admin method to approve/reject payment
     */
    public function verify(Request $request, Payment $payment)
    {
        // Ensure only admins can verify
        if (auth()->user()->role !== 'admin') {
            abort(403, 'Only administrators can verify payments.');
        }

        $validated = $request->validate([
            'status' => 'required|in:approved,rejected',
            'admin_notes' => 'nullable|string|max:1000',
            'rejection_reason' => 'required_if:status,rejected|string|max:500'
        ]);

        $payment->update([
            'status' => $validated['status'],
            'admin_notes' => $validated['admin_notes'] ?? null,
            'rejection_reason' => $validated['status'] === 'rejected' ? $validated['rejection_reason'] : null,
            'verified_by' => auth()->id(),
            'verified_at' => now(),
            'access_expires_at' => $validated['status'] === 'approved' 
                ? Carbon::now()->addDays($payment->access_duration_days)
                : null
        ]);

        $status = $validated['status'] === 'approved' ? 'approved' : 'rejected';
        return back()->with('success', "Payment has been {$status} successfully.");
    }

    /**
     * Display the specified payment
     */
    public function show(Payment $payment)
    {
        $user = auth()->user();

        // Only admin or payment owner can view
        if ($user->role !== 'admin' && $payment->user_id !== $user->id) {
            abort(403);
        }

        $payment->load(['user', 'verifiedBy']);

        return Inertia::render('Payments/Show', [
            'payment' => $payment
        ]);
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
            'pending_count' => Payment::pending()->count(),
            'approved_today' => Payment::approved()->whereDate('verified_at', today())->count(),
            'total_revenue' => Payment::approved()->sum('amount'),
            'active_subscriptions' => Payment::approved()
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
        
        $validPayment = Payment::where('user_id', $user->id)
            ->approved()
            ->where('access_expires_at', '>', Carbon::now())
            ->latest('access_expires_at')
            ->first();

        return response()->json([
            'hasAccess' => (bool) $validPayment,
            'expiresAt' => $validPayment?->access_expires_at,
            'daysRemaining' => $validPayment?->days_remaining
        ]);
    }
}
