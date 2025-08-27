<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SystemSetting extends Model
{
    protected $fillable = [
        'key',
        'name', 
        'value',
        'type',
        'group',
        'description'
    ];

    public static function get($key, $default = null)
    {
        $setting = static::where('key', $key)->first();
        return $setting ? $setting->value : $default;
    }

    public static function set($key, $value)
    {
        return static::updateOrCreate(
            ['key' => $key],
            ['value' => $value]
        );
    }

    public static function getByGroup($group)
    {
        return static::where('group', $group)->get();
    }

    public static function getAllGrouped()
    {
        return static::all()->groupBy('group');
    }

    // Cast value based on type
    public function getValueAttribute($value)
    {
        switch ($this->type) {
            case 'boolean':
                return (bool) $value;
            case 'json':
                return json_decode($value, true);
            default:
                return $value;
        }
    }

    // Set value based on type
    public function setValueAttribute($value)
    {
        if ($this->type === 'json') {
            $this->attributes['value'] = json_encode($value);
        } elseif ($this->type === 'boolean') {
            $this->attributes['value'] = (int) $value;
        } else {
            $this->attributes['value'] = $value;
        }
    }
}