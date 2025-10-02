<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOneThrough;

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
        'additional_data',
        'extension_months',
        'status',
        'admin_notes',
        'verified_at',
        'verified_by'
    ];

    protected $casts = [
        'amount' => 'decimal:2',
        'verified_at' => 'datetime',
        'additional_data' => 'array',
        'payment_details' => 'array'
    ];

    /**
     * Get access duration in days
     */
    public function getAccessDurationDaysAttribute()
    {
        return $this->extension_months ? $this->extension_months * 30 : 30;
    }

    public function enrollment(): BelongsTo
    {
        return $this->belongsTo(Enrollment::class);
    }

    public function paymentMethod(): BelongsTo
    {
        return $this->belongsTo(PaymentMethod::class);
    }

    public function verifiedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'verified_by');
    }

    /**
     * Get the user who owns the enrollment
     */
    public function user()
    {
        return $this->enrollment?->user;
    }
}
