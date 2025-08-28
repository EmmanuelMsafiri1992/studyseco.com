<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class ComplaintController extends Controller
{
    public function index()
    {
        return Inertia::render('Complaints/Index', [
            'complaints' => []
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
