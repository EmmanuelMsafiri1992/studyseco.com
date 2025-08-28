<?php

namespace App\Http\Controllers;

use App\Models\ChatGroup;
use App\Models\ChatMessage;
use App\Models\Subject;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ChatController extends Controller
{
    /**
     * Display a listing of chat groups.
     */
    public function index()
    {
        $user = auth()->user();
        
        $chatGroups = $user->chatGroups()
            ->with(['subject', 'creator'])
            ->withCount(['users', 'messages'])
            ->orderBy('last_activity_at', 'desc')
            ->get()
            ->map(function ($group) use ($user) {
                $group->unread_count = $group->getUnreadCountForUser($user);
                $group->last_message = $group->recentMessages()->with('user')->first();
                return $group;
            });

        return Inertia::render('Chat/Index', [
            'chatGroups' => $chatGroups
        ]);
    }

    /**
     * Display the specified chat group.
     */
    public function show(ChatGroup $chatGroup)
    {
        $user = auth()->user();
        
        // Check if user is member
        if (!$chatGroup->hasMember($user)) {
            abort(403, 'You are not a member of this chat group.');
        }

        $chatGroup->load(['subject', 'creator', 'users']);
        
        // Get messages with pagination
        $messages = $chatGroup->messages()
            ->with(['user', 'replyTo.user'])
            ->where('is_deleted', false)
            ->orderBy('created_at', 'asc')
            ->paginate(50);

        // Mark as read
        $chatGroup->markAsReadForUser($user);

        return Inertia::render('Chat/Show', [
            'chatGroup' => $chatGroup,
            'messages' => $messages,
            'userRole' => $chatGroup->users()->where('user_id', $user->id)->first()?->pivot?->role ?? 'member'
        ]);
    }

    /**
     * Store a new message.
     */
    public function storeMessage(Request $request, ChatGroup $chatGroup)
    {
        $user = auth()->user();
        
        if (!$chatGroup->hasMember($user)) {
            abort(403, 'You are not a member of this chat group.');
        }

        $validated = $request->validate([
            'message' => 'required|string|max:2000',
            'message_type' => 'in:text,image,file,announcement',
            'reply_to' => 'nullable|exists:chat_messages,id',
            'attachments' => 'nullable|array'
        ]);

        $message = ChatMessage::create([
            'chat_group_id' => $chatGroup->id,
            'user_id' => $user->id,
            'message' => $validated['message'],
            'message_type' => $validated['message_type'] ?? 'text',
            'reply_to' => $validated['reply_to'] ?? null,
            'attachments' => $validated['attachments'] ?? null
        ]);

        $message->load('user', 'replyTo.user');

        // Update group activity
        $chatGroup->updateActivity();

        return response()->json([
            'message' => $message,
            'success' => true
        ]);
    }

    /**
     * Join a chat group.
     */
    public function join(ChatGroup $chatGroup)
    {
        $user = auth()->user();
        
        if ($chatGroup->hasMember($user)) {
            return back()->with('info', 'You are already a member of this group.');
        }

        if ($chatGroup->users()->count() >= $chatGroup->max_members) {
            return back()->withErrors(['error' => 'This group has reached its maximum capacity.']);
        }

        $chatGroup->addMember($user);

        return back()->with('success', 'Successfully joined the group.');
    }

    /**
     * Leave a chat group.
     */
    public function leave(ChatGroup $chatGroup)
    {
        $user = auth()->user();
        
        if (!$chatGroup->hasMember($user)) {
            return back()->withErrors(['error' => 'You are not a member of this group.']);
        }

        $chatGroup->removeMember($user);

        return redirect()->route('chat.index')->with('success', 'Successfully left the group.');
    }

    /**
     * Get messages for a chat group (AJAX).
     */
    public function getMessages(Request $request, ChatGroup $chatGroup)
    {
        $user = auth()->user();
        
        if (!$chatGroup->hasMember($user)) {
            abort(403);
        }

        $messages = $chatGroup->messages()
            ->with(['user', 'replyTo.user'])
            ->where('is_deleted', false)
            ->when($request->before, function ($query, $before) {
                $query->where('created_at', '<', $before);
            })
            ->orderBy('created_at', 'desc')
            ->limit(20)
            ->get()
            ->reverse()
            ->values();

        return response()->json($messages);
    }
}