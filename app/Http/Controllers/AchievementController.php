<?php

namespace App\Http\Controllers;

use App\Models\Achievement;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;

class AchievementController extends Controller
{
    public function index(Request $request)
    {
        $query = Achievement::with(['user', 'awardedBy'])
            ->where('is_public', true)
            ->orderByDesc('is_featured')
            ->orderByDesc('achieved_date')
            ->orderBy('display_order');

        // Filter by type
        if ($request->filled('type')) {
            $query->where('type', $request->type);
        }

        // Filter by level
        if ($request->filled('level')) {
            $query->where('level', $request->level);
        }

        // Search functionality
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('description', 'like', "%{$search}%")
                  ->orWhere('category', 'like', "%{$search}%")
                  ->orWhereHas('user', function ($userQuery) use ($search) {
                      $userQuery->where('name', 'like', "%{$search}%");
                  });
            });
        }

        $achievements = $query->paginate(12);

        // Get statistics
        $stats = [
            'total_achievements' => Achievement::where('is_public', true)->count(),
            'featured_achievements' => Achievement::where('is_public', true)->where('is_featured', true)->count(),
            'total_points' => Achievement::where('is_public', true)->sum('points'),
            'recent_achievements' => Achievement::where('is_public', true)
                ->where('achieved_date', '>=', now()->subDays(7))
                ->count()
        ];

        // Get achievement types for filtering
        $types = Achievement::distinct()->pluck('type');
        $levels = Achievement::distinct()->pluck('level');

        return Inertia::render('Achievements/Index', [
            'achievements' => $achievements,
            'stats' => $stats,
            'types' => $types,
            'levels' => $levels,
            'filters' => $request->only(['type', 'level', 'search'])
        ]);
    }

    public function show(Achievement $achievement)
    {
        if (!$achievement->is_public) {
            abort(404);
        }

        $achievement->load(['user', 'awardedBy']);
        
        // Get related achievements
        $relatedAchievements = Achievement::where('is_public', true)
            ->where('id', '!=', $achievement->id)
            ->where(function ($query) use ($achievement) {
                $query->where('type', $achievement->type)
                      ->orWhere('category', $achievement->category)
                      ->orWhere('user_id', $achievement->user_id);
            })
            ->with(['user', 'awardedBy'])
            ->limit(6)
            ->get();

        return Inertia::render('Achievements/Show', [
            'achievement' => $achievement,
            'related' => $relatedAchievements
        ]);
    }

    public function leaderboard()
    {
        // Get top students by achievement points
        $topStudents = User::whereHas('achievements', function ($query) {
                $query->where('is_public', true);
            })
            ->withSum(['achievements' => function ($query) {
                $query->where('is_public', true);
            }], 'points')
            ->withCount(['achievements' => function ($query) {
                $query->where('is_public', true);
            }])
            ->orderByDesc('achievements_sum_points')
            ->take(20)
            ->get();

        // Get achievement distribution
        $achievementTypes = Achievement::where('is_public', true)
            ->selectRaw('type, count(*) as count, sum(points) as total_points')
            ->groupBy('type')
            ->get();

        // Get recent achievements
        $recentAchievements = Achievement::where('is_public', true)
            ->with(['user', 'awardedBy'])
            ->orderByDesc('achieved_date')
            ->take(10)
            ->get();

        return Inertia::render('Achievements/Leaderboard', [
            'topStudents' => $topStudents,
            'achievementTypes' => $achievementTypes,
            'recentAchievements' => $recentAchievements
        ]);
    }
}
