<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PaymentMethod extends Model
{
    protected $fillable = [
        'name',
        'key',
        'type',
        'instructions',
        'config',
        'is_active',
        'sort_order',
    ];

    protected $casts = [
        'config' => 'array',
        'is_active' => 'boolean',
        'sort_order' => 'integer',
    ];

    // Scope for active payment methods
    public function scopeActive($query)
    {
        return $query->where('is_active', true)->orderBy('sort_order');
    }

    // Get formatted config for display
    public function getFormattedConfigAttribute()
    {
        if (!$this->config) return [];
        
        return match($this->type) {
            'mobile_money' => [
                'phone_number' => $this->config['phone_number'] ?? '',
                'merchant_code' => $this->config['merchant_code'] ?? '',
            ],
            'bank_transfer' => [
                'bank_name' => $this->config['bank_name'] ?? '',
                'account_name' => $this->config['account_name'] ?? '',
                'account_number' => $this->config['account_number'] ?? '',
                'branch' => $this->config['branch'] ?? '',
            ],
            default => $this->config
        };
    }

    // Get icon based on method key
    public function getIconAttribute()
    {
        return match($this->key) {
            'tnm_mpamba' => '📱',
            'airtel_money' => '📱', 
            'bank_transfer' => '🏦',
            default => '💳'
        };
    }

    // Get color theme based on method key
    public function getColorAttribute()
    {
        return match($this->key) {
            'tnm_mpamba' => 'from-blue-500 to-blue-600',
            'airtel_money' => 'from-red-500 to-red-600',
            'bank_transfer' => 'from-green-500 to-green-600',
            default => 'from-gray-500 to-gray-600'
        };
    }
}
