<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class ComplaintController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        
        // Mock complaints data - in a real app, this would come from database
        $allComplaints = [
            [
                'id' => 'C001', 
                'user_id' => 1, // Different user ID 
                'user' => 'Student A', 
                'issue' => 'Classroom issue', 
                'status' => 'open', 
                'date' => '2023-08-20'
            ],
            [
                'id' => 'C002', 
                'user_id' => 2, // Different user ID
                'user' => 'Parent B', 
                'issue' => 'Fee dispute', 
                'status' => 'resolved', 
                'date' => '2023-08-10'
            ],
            [
                'id' => 'C003', 
                'user_id' => 3, // Different user ID
                'user' => 'Teacher C', 
                'issue' => 'Equipment fault', 
                'status' => 'open', 
                'date' => '2023-08-15'
            ],
            [
                'id' => 'C004', 
                'user_id' => $user->id, // Current user's complaint
                'user' => $user->name, 
                'issue' => 'Access issue with trial account', 
                'status' => 'open', 
                'date' => now()->format('Y-m-d')
            ],
        ];
        
        // Filter complaints based on user role
        $complaints = collect($allComplaints);
        
        if ($user->role === 'student') {
            // Students only see their own complaints
            $complaints = $complaints->where('user_id', $user->id)->values();
        } elseif ($user->role === 'teacher') {
            // Teachers only see their own complaints  
            $complaints = $complaints->where('user_id', $user->id)->values();
        }
        // Admin sees all complaints (no filtering)

        return Inertia::render('Complaints/Index', [
            'auth' => ['user' => $user],
            'complaints' => $complaints->toArray()
        ]);
    }

    public function create()
    {
        return Inertia::render('Complaints/Create');
    }

    public function store(Request $request)
    {
        // Handle complaint creation
        return redirect()->route('complaints.index')->with('success', 'Complaint submitted successfully.');
    }

    public function show($id)
    {
        return Inertia::render('Complaints/Show', [
            'complaint' => []
        ]);
    }
}
