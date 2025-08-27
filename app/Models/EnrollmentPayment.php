<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EnrollmentPayment extends Model
{
    protected $fillable = [
        'enrollment_id',
        'payment_method_id',
        'reference_number',
        'amount',
        'currency',
        'payment_proof_path',
        'payment_details',
        'payment_type',
        'extension_months',
        'status',
        'admin_notes',
        'verified_at',
        'verified_by'
    ];

    protected $casts = [
        'amount' => 'decimal:2',
        'verified_at' => 'datetime'
    ];

    public function enrollment()
    {
        return $this->belongsTo(Enrollment::class);
    }

    public function paymentMethod()
    {
        return $this->belongsTo(PaymentMethod::class);
    }

    public function verifiedBy()
    {
        return $this->belongsTo(User::class, 'verified_by');
    }
}
