<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PaymentMethod extends Model
{
    protected $fillable = [
        'name',
        'code',
        'type',
        'region',
        'currency',
        'instructions',
        'requirements',
        'is_active',
        'sort_order',
    ];

    protected $casts = [
        'requirements' => 'array',
        'is_active' => 'boolean',
        'sort_order' => 'integer',
    ];

    // Scope for active payment methods
    public function scopeActive($query)
    {
        return $query->where('is_active', true)->orderBy('sort_order');
    }

    // Get icon based on method code
    public function getIconAttribute()
    {
        return match($this->code) {
            'tnm_mpamba' => '📱',
            'airtel_money' => '📱', 
            'bank_transfer' => '🏦',
            'mukuru' => '💰',
            'hello_paisa' => '💳',
            'worldremit' => '🌍',
            'remitly' => '💸',
            'western_union' => '⚡',
            'moneygram' => '💵',
            'paypal' => '🅿️',
            default => '💳'
        };
    }

    // Get color theme based on method code
    public function getColorAttribute()
    {
        return match($this->code) {
            'tnm_mpamba' => 'from-blue-500 to-blue-600',
            'airtel_money' => 'from-red-500 to-red-600',
            'bank_transfer' => 'from-green-500 to-green-600',
            'mukuru' => 'from-yellow-500 to-yellow-600',
            'hello_paisa' => 'from-purple-500 to-purple-600',
            'worldremit' => 'from-indigo-500 to-indigo-600',
            'remitly' => 'from-teal-500 to-teal-600',
            'western_union' => 'from-yellow-600 to-orange-600',
            'moneygram' => 'from-blue-600 to-purple-600',
            'paypal' => 'from-blue-400 to-blue-500',
            default => 'from-gray-500 to-gray-600'
        };
    }

    // Scope for region-specific methods
    public function scopeForRegion($query, $region)
    {
        return $query->where('region', $region);
    }

    // Get price per subject for this payment method's currency
    public function getSubjectPriceAttribute()
    {
        return match($this->currency) {
            'MWK' => 50000,
            'ZAR' => 350,
            'USD' => 25,
            default => 50000
        };
    }
}
