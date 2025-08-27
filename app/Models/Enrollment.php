<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Carbon\Carbon;

class Enrollment extends Model
{
    protected $fillable = [
        'enrollment_number',
        'name',
        'email',
        'phone',
        'address',
        'country',
        'region',
        'currency',
        'price_per_subject',
        'subject_count',
        'selected_subjects',
        'total_amount',
        'payment_method',
        'payment_reference',
        'payment_proof_path',
        'status',
        'is_trial',
        'trial_started_at',
        'trial_expires_at',
        'access_expires_at',
        'admin_notes',
        'approved_at',
        'approved_by',
        'user_id'
    ];

    protected $casts = [
        'selected_subjects' => 'array',
        'total_amount' => 'decimal:2',
        'price_per_subject' => 'decimal:2',
        'is_trial' => 'boolean',
        'trial_started_at' => 'datetime',
        'trial_expires_at' => 'datetime',
        'access_expires_at' => 'datetime',
        'approved_at' => 'datetime'
    ];

    public function approvedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function payments()
    {
        return $this->hasMany(EnrollmentPayment::class);
    }

    // Generate unique enrollment number
    protected static function booted()
    {
        static::creating(function ($enrollment) {
            $enrollment->enrollment_number = 'ENR' . date('Y') . str_pad(static::count() + 1, 6, '0', STR_PAD_LEFT);
            
            // Set trial period if is_trial is true
            if ($enrollment->is_trial) {
                $enrollment->trial_started_at = now();
                $enrollment->trial_expires_at = now()->addDays(7); // 7-day trial
                $enrollment->status = 'approved'; // Auto-approve trials
            }
        });
    }

    // Calculate region and currency based on country
    public static function getRegionForCountry($country)
    {
        $country = strtolower($country);
        
        if (in_array($country, ['malawi', 'mw', 'mwi'])) {
            return 'malawi';
        }
        
        if (in_array($country, ['south africa', 'za', 'zaf', 'south_africa'])) {
            return 'south_africa';
        }
        
        return 'international';
    }

    public static function getCurrencyForRegion($region)
    {
        return match ($region) {
            'malawi' => 'MWK',
            'south_africa' => 'ZAR', 
            'international' => 'USD',
            default => 'MWK'
        };
    }

    public static function getPricePerSubject($region)
    {
        return match ($region) {
            'malawi' => 50000.00,      // MWK 50,000
            'south_africa' => 350.00,   // ZAR 350
            'international' => 25.00,   // USD 25
            default => 50000.00
        };
    }

    // Check if trial has expired
    public function getIsTrialExpiredAttribute()
    {
        if (!$this->is_trial || !$this->trial_expires_at) {
            return false;
        }
        
        return now()->greaterThan($this->trial_expires_at);
    }

    // Get days remaining in trial
    public function getTrialDaysRemainingAttribute()
    {
        if (!$this->is_trial || !$this->trial_expires_at) {
            return 0;
        }
        
        if ($this->is_trial_expired) {
            return 0;
        }
        
        return now()->diffInDays($this->trial_expires_at, false);
    }

    // Get subjects with details from database
    public function getSelectedSubjectsWithDetailsAttribute()
    {
        if (!$this->selected_subjects) {
            return [];
        }

        return Subject::whereIn('id', $this->selected_subjects)
            ->select('id', 'name', 'description', 'grade_level')
            ->get()
            ->map(function ($subject) {
                return [
                    'id' => $subject->id,
                    'name' => $subject->name,
                    'description' => $subject->description,
                    'grade_level' => $subject->grade_level,
                    'icon' => $this->getSubjectIcon($subject->name)
                ];
            });
    }

    private function getSubjectIcon($subjectName)
    {
        return match (strtolower($subjectName)) {
            'english', 'english language' => '📚',
            'chichewa' => '🗣️',
            'mathematics' => '📐',
            'life skills' => '🌱',
            'physical science' => '🔬',
            'biology' => '🧬',
            'chemistry' => '⚗️',
            'physics' => '⚛️',
            'geography' => '🌍',
            'history' => '📜',
            'social studies' => '🏛️',
            'computer studies' => '💻',
            'business studies' => '💼',
            'agriculture' => '🌾',
            'home economics' => '🏠',
            'technical drawing' => '📐',
            'french' => '🇫🇷',
            'development studies' => '📈',
            default => '📖'
        };
    }

    // Legacy method for backward compatibility  
    public function getSelectedSubjectsNamesAttribute()
    {
        return $this->selected_subjects_with_details->pluck('name')->toArray();
    }

    // Scope for active trials
    public function scopeActiveTrial($query)
    {
        return $query->where('is_trial', true)
                    ->where('trial_expires_at', '>', now());
    }

    // Scope for expired trials
    public function scopeExpiredTrial($query)
    {
        return $query->where('is_trial', true)
                    ->where('trial_expires_at', '<=', now());
    }
    
    // Check if access has expired
    public function getIsAccessExpiredAttribute()
    {
        if (!$this->access_expires_at) {
            return false;
        }
        
        return now()->greaterThan($this->access_expires_at);
    }
    
    // Get days remaining for access
    public function getAccessDaysRemainingAttribute()
    {
        if (!$this->access_expires_at) {
            return 0;
        }
        
        if ($this->is_access_expired) {
            return 0;
        }
        
        return now()->diffInDays($this->access_expires_at, false);
    }
    
    // Scope for active access
    public function scopeActiveAccess($query)
    {
        return $query->where('access_expires_at', '>', now())
                    ->where('status', 'approved');
    }
    
    // Scope for expired access
    public function scopeExpiredAccess($query)
    {
        return $query->where('access_expires_at', '<=', now());
    }
}