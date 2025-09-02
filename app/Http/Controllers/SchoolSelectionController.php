<?php

namespace App\Http\Controllers;

use App\Models\SecondarySchool;
use App\Models\StudentSchoolSelection;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class SchoolSelectionController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $schools = SecondarySchool::active()->get();
        $userSelections = $user->schoolSelections()->with('secondarySchool')->byPriority()->get();

        return Inertia::render('SchoolSelection/Index', [
            'schools' => $schools,
            'userSelections' => $userSelections,
            'hasRequiredSelections' => $user->hasRequiredSchoolSelections(),
            'confirmedSchool' => $user->confirmedSchool(),
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'school_selections' => 'required|array|min:5|max:10',
            'school_selections.*.school_id' => 'required|exists:secondary_schools,id',
            'school_selections.*.priority' => 'required|integer|min:1|max:10',
        ]);

        $user = Auth::user();

        DB::transaction(function () use ($user, $request) {
            $user->schoolSelections()->delete();

            foreach ($request->school_selections as $selection) {
                StudentSchoolSelection::create([
                    'user_id' => $user->id,
                    'secondary_school_id' => $selection['school_id'],
                    'priority_order' => $selection['priority'],
                    'status' => 'pending',
                ]);
            }
        });

        return redirect()->back()->with('success', 'School selections saved successfully. You will be notified once schools respond to your applications.');
    }

    public function update(Request $request, StudentSchoolSelection $selection)
    {
        if ($selection->user_id !== Auth::id()) {
            abort(403);
        }

        $request->validate([
            'priority_order' => 'required|integer|min:1|max:10',
        ]);

        $selection->update($request->only('priority_order'));

        return redirect()->back()->with('success', 'Selection priority updated successfully.');
    }

    public function destroy(StudentSchoolSelection $selection)
    {
        if ($selection->user_id !== Auth::id() || $selection->status !== 'pending') {
            abort(403);
        }

        $selection->delete();

        return redirect()->back()->with('success', 'School selection removed successfully.');
    }

    public function adminIndex()
    {
        $selections = StudentSchoolSelection::with(['user', 'secondarySchool'])
            ->byStatus('pending')
            ->byPriority()
            ->paginate(20);

        return Inertia::render('Admin/SchoolSelections/Index', [
            'selections' => $selections,
        ]);
    }

    public function adminUpdate(Request $request, StudentSchoolSelection $selection)
    {
        $request->validate([
            'status' => 'required|in:confirmed,rejected',
            'rejection_reason' => 'required_if:status,rejected|string|max:500',
        ]);

        if ($request->status === 'confirmed') {
            $school = $selection->secondarySchool;
            
            if ($school->available_slots <= 0) {
                return redirect()->back()->withErrors(['error' => 'No available slots in this school.']);
            }
            
            $selection->markAsConfirmed();
        } else {
            $selection->markAsRejected($request->rejection_reason);
        }

        return redirect()->back()->with('success', 'Selection status updated successfully.');
    }
}
