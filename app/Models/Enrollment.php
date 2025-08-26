<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Enrollment extends Model
{
    protected $fillable = [
        'name',
        'email',
        'phone',
        'address',
        'selected_subjects',
        'total_amount',
        'payment_method',
        'payment_reference',
        'payment_proof_path',
        'status',
        'admin_notes',
        'user_id'
    ];

    protected $casts = [
        'selected_subjects' => 'array',
        'total_amount' => 'decimal:2'
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function getSelectedSubjectsNamesAttribute()
    {
        if (!$this->selected_subjects) {
            return [];
        }

        // You can expand this to fetch subject names from database
        $subjectNames = [
            1 => 'English Language',
            2 => 'Mathematics', 
            3 => 'Physical Science',
            4 => 'Social Studies',
            5 => 'Computer Studies',
            6 => 'Creative Arts',
            7 => 'Biology',
            8 => 'Chemistry',
            9 => 'Physics',
            10 => 'Geography',
            11 => 'History',
            12 => 'Business Studies'
        ];

        return collect($this->selected_subjects)->map(function ($id) use ($subjectNames) {
            return $subjectNames[$id] ?? 'Unknown Subject';
        })->toArray();
    }
}
