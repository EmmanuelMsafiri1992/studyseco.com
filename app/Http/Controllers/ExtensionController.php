<?php

namespace App\Http\Controllers;

use App\Models\Enrollment;
use App\Models\EnrollmentPayment;
use App\Models\PaymentMethod;
use App\Notifications\ExtensionApproved;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ExtensionController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        $enrollment = $user->enrollments()->with('payments')->first();
        
        if (!$enrollment) {
            return redirect()->route('welcome')->with('error', 'No active enrollment found.');
        }
        
        // Calculate extension pricing based on user's currency
        $extensionPricing = $this->getExtensionPricing($enrollment->currency);
        
        // Get available payment methods for user's region
        $paymentMethods = PaymentMethod::where('region', $enrollment->region)
            ->where('is_active', true)
            ->orderBy('sort_order')
            ->get();
            
        return Inertia::render('Student/Extension', [
            'enrollment' => $enrollment,
            'extensionPricing' => $extensionPricing,
            'paymentMethods' => $paymentMethods,
            'daysRemaining' => $enrollment->access_days_remaining,
            'accessExpired' => $enrollment->is_access_expired,
        ]);
    }
    
    public function store(Request $request)
    {
        $validated = $request->validate([
            'extension_months' => 'required|integer|min:1|max:12',
            'payment_method_id' => 'required|exists:payment_methods,id',
            'payment_reference' => 'required|string|max:255',
            'payment_proof' => 'required|file|mimes:jpg,jpeg,png,pdf|max:5120',
        ]);
        
        $user = auth()->user();
        $enrollment = $user->enrollments()->first();
        
        if (!$enrollment) {
            return back()->withErrors(['enrollment' => 'No active enrollment found.']);
        }
        
        // Calculate extension price
        $extensionPrice = $this->calculateExtensionPrice($enrollment->currency, $validated['extension_months']);
        
        // Store payment proof
        $paymentProofPath = $request->file('payment_proof')->store('extension_payments', 'public');
        
        // Create extension payment record
        $extensionPayment = EnrollmentPayment::create([
            'enrollment_id' => $enrollment->id,
            'payment_method_id' => $validated['payment_method_id'],
            'reference_number' => $validated['payment_reference'],
            'amount' => $extensionPrice,
            'currency' => $enrollment->currency,
            'payment_proof_path' => $paymentProofPath,
            'payment_type' => 'extension',
            'extension_months' => $validated['extension_months'],
            'status' => 'pending'
        ]);
        
        return redirect()->route('student.extension')->with('success', 
            'Extension request submitted successfully! We will verify your payment within 24 hours and notify you via email and SMS.');
    }
    
    private function getExtensionPricing($currency)
    {
        $basePrice = match($currency) {
            'MWK' => 25000, // Half price for extensions
            'ZAR' => 175,
            'USD' => 12.50,
            default => 25000
        };
        
        return [
            1 => $basePrice * 1,
            2 => $basePrice * 2,
            3 => $basePrice * 3,
            4 => $basePrice * 4,
            6 => $basePrice * 5.5, // 6-month discount
            12 => $basePrice * 10,  // 1-year discount (2 months free)
        ];
    }
    
    private function calculateExtensionPrice($currency, $months)
    {
        $pricing = $this->getExtensionPricing($currency);
        return $pricing[$months] ?? ($pricing[1] * $months);
    }
    
    public function approve(EnrollmentPayment $payment)
    {
        if ($payment->payment_type !== 'extension') {
            return back()->withErrors(['error' => 'Invalid payment type']);
        }
        
        $enrollment = $payment->enrollment;
        
        // Update payment status
        $payment->update([
            'status' => 'verified',
            'verified_at' => now(),
            'verified_by' => auth()->id()
        ]);
        
        // Extend access duration
        $currentExpiry = $enrollment->access_expires_at ?? now();
        $newExpiry = $currentExpiry->addMonths($payment->extension_months);
        
        $enrollment->update([
            'access_expires_at' => $newExpiry
        ]);
        
        // Send notification to student
        try {
            $enrollment->user->notify(new ExtensionApproved($enrollment, $payment));
        } catch (\Exception $e) {
            // Log error but don't fail the approval
            logger('Failed to send extension approval notification: ' . $e->getMessage());
        }
        
        return back()->with('success', 'Extension approved successfully! Student has been notified.');
    }
}