<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
        'custom_permissions',
        'dashboard_preferences',
        'is_active',
        'last_login_at',
        'profile_photo_url',
        'phone',
        'bio',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'custom_permissions' => 'array',
            'dashboard_preferences' => 'array',
            'is_active' => 'boolean',
            'last_login_at' => 'datetime',
        ];
    }

    /**
     * Get all payments made by this user
     */
    public function payments(): HasMany
    {
        return $this->hasMany(Payment::class);
    }

    /**
     * Get payments verified by this admin
     */
    public function verifiedPayments(): HasMany
    {
        return $this->hasMany(Payment::class, 'verified_by');
    }

    /**
     * Get enrollment payments made by this user
     */
    public function enrollmentPayments(): HasMany
    {
        return $this->hasMany(EnrollmentPayment::class, 'user_id');
    }

    /**
     * Get enrollment payments verified by this admin
     */
    public function verifiedEnrollmentPayments(): HasMany
    {
        return $this->hasMany(EnrollmentPayment::class, 'verified_by');
    }

    /**
     * Check if user has valid access
     */
    public function hasValidAccess(): bool
    {
        return $this->payments()
            ->where('status', 'approved')
            ->where('access_expires_at', '>', now())
            ->exists();
    }

    /**
     * Get user's active payment (if any)
     */
    public function activePayment()
    {
        return $this->payments()
            ->where('status', 'approved')
            ->where('access_expires_at', '>', now())
            ->latest('access_expires_at')
            ->first();
    }

    /**
     * The roles that belong to the user.
     */
    public function roles(): BelongsToMany
    {
        return $this->belongsToMany(Role::class)
                    ->withPivot('assigned_at', 'assigned_by')
                    ->withTimestamps();
    }

    /**
     * Check if user has a specific permission
     */
    public function hasPermission($permission): bool
    {
        // Check custom permissions first
        if ($this->custom_permissions && in_array($permission, $this->custom_permissions)) {
            return true;
        }

        // Check role permissions
        return $this->roles()->whereHas('permissions', function ($query) use ($permission) {
            $query->where('slug', $permission)->where('is_active', true);
        })->exists();
    }

    /**
     * Check if user has a specific role
     */
    public function hasRole($role): bool
    {
        if (is_string($role)) {
            return $this->roles()->where('slug', $role)->exists();
        }
        
        return $this->roles()->where('id', $role->id)->exists();
    }

    /**
     * Assign role to user
     */
    public function assignRole($role, $assignedBy = null)
    {
        $roleId = is_string($role) ? Role::where('slug', $role)->first()?->id : $role->id;
        
        if ($roleId && !$this->roles()->where('role_id', $roleId)->exists()) {
            $this->roles()->attach($roleId, [
                'assigned_by' => $assignedBy,
                'assigned_at' => now()
            ]);
        }
    }

    /**
     * Remove role from user
     */
    public function removeRole($role)
    {
        $roleId = is_string($role) ? Role::where('slug', $role)->first()?->id : $role->id;
        
        if ($roleId) {
            $this->roles()->detach($roleId);
        }
    }

    /**
     * Get user's highest priority role
     */
    public function getPrimaryRole()
    {
        return $this->roles()->orderBy('priority', 'desc')->first();
    }

    /**
     * Get all user permissions (from roles + custom)
     */
    public function getAllPermissions()
    {
        $rolePermissions = $this->roles()->with('permissions')
            ->get()
            ->pluck('permissions')
            ->flatten()
            ->pluck('slug')
            ->unique()
            ->toArray();

        $customPermissions = $this->custom_permissions ?? [];

        return array_unique(array_merge($rolePermissions, $customPermissions));
    }

    /**
     * Update last login timestamp
     */
    public function updateLastLogin()
    {
        $this->update(['last_login_at' => now()]);
    }

    /**
     * Scope for active users
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope for users with specific role
     */
    public function scopeWithRole($query, $role)
    {
        return $query->whereHas('roles', function ($q) use ($role) {
            $q->where('slug', $role);
        });
    }

    /**
     * The chat groups that the user belongs to.
     */
    public function chatGroups(): BelongsToMany
    {
        return $this->belongsToMany(ChatGroup::class)
                    ->withPivot(['role', 'joined_at', 'last_read_at', 'is_muted', 'notification_settings'])
                    ->withTimestamps();
    }

    /**
     * Get chat messages sent by this user
     */
    public function chatMessages(): HasMany
    {
        return $this->hasMany(ChatMessage::class);
    }

    /**
     * Get chat groups created by this user
     */
    public function createdChatGroups(): HasMany
    {
        return $this->hasMany(ChatGroup::class, 'created_by');
    }

    /**
     * Get achievements earned by this user
     */
    public function achievements(): HasMany
    {
        return $this->hasMany(Achievement::class);
    }

    /**
     * Get achievements awarded by this user
     */
    public function awardedAchievements(): HasMany
    {
        return $this->hasMany(Achievement::class, 'awarded_by');
    }

    /**
     * Get enrollments for this user
     */
    public function enrollments(): HasMany
    {
        return $this->hasMany(Enrollment::class);
    }
}
