<?php

namespace App\Http\Controllers;

use App\Models\SupportChat;
use App\Models\SupportChatMessage;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;

class ComplaintController extends Controller
{
    public function index()
    {
        $user = auth()->user();
        
        // Check if user is admin or teacher to show live chat management
        if (in_array($user->role, ['admin', 'teacher'])) {
            return $this->showChatManagement($user);
        }
        
        // For students, redirect to create a support chat
        return redirect()->route('complaints.create');
    }

    private function showChatManagement(User $user)
    {
        $waitingPage = request('waiting_page', 1);
        $activePage = request('active_page', 1);
        $historyPage = request('history_page', 1);
        $perPage = 2; // Maximum 2 clients per section

        // Get live chat statistics
        $stats = [
            'waiting_chats' => SupportChat::waiting()->count(),
            'active_chats' => SupportChat::active()->count(),
            'my_active_chats' => SupportChat::active()->assignedTo($user->id)->count(),
            'total_today' => SupportChat::whereDate('created_at', today())->count(),
        ];

        // Get paginated waiting queue
        $waitingChatsQuery = SupportChat::waiting()
            ->with(['user', 'messages' => function($query) {
                $query->orderBy('created_at', 'desc')->limit(1);
            }])
            ->orderBy('created_at');
        
        $waitingChatsPagination = $waitingChatsQuery->paginate($perPage, ['*'], 'waiting_page', $waitingPage);
        $waitingChats = $waitingChatsPagination->getCollection()->map(function($chat, $index) use ($waitingPage, $perPage) {
            $chat->queue_position = (($waitingPage - 1) * $perPage) + $index + 1;
            return $chat;
        });

        // Get paginated agent's active chats
        $activeChatsQuery = SupportChat::active()
            ->assignedTo($user->id)
            ->with(['user', 'messages' => function($query) {
                $query->orderBy('created_at', 'desc')->limit(1);
            }])
            ->orderBy('assigned_at', 'desc');
            
        $activeChatsPagination = $activeChatsQuery->paginate($perPage, ['*'], 'active_page', $activePage);
        $activeChats = $activeChatsPagination->getCollection();

        // Get paginated recent closed chats (for history)
        $recentChatsQuery = SupportChat::where('status', 'closed')
            ->with(['user', 'agent'])
            ->orderBy('closed_at', 'desc');
            
        $recentChatsPagination = $recentChatsQuery->paginate($perPage, ['*'], 'history_page', $historyPage);
        $recentChats = $recentChatsPagination->getCollection();

        return Inertia::render('Complaints/Index', [
            'auth' => ['user' => $user],
            'stats' => $stats,
            'waitingChats' => $waitingChats,
            'activeChats' => $activeChats,
            'recentChats' => $recentChats,
            'waitingPagination' => [
                'current_page' => $waitingChatsPagination->currentPage(),
                'last_page' => $waitingChatsPagination->lastPage(),
                'total' => $waitingChatsPagination->total(),
                'has_more_pages' => $waitingChatsPagination->hasMorePages(),
                'has_pages' => $waitingChatsPagination->lastPage() > 1,
            ],
            'activePagination' => [
                'current_page' => $activeChatsPagination->currentPage(),
                'last_page' => $activeChatsPagination->lastPage(),
                'total' => $activeChatsPagination->total(),
                'has_more_pages' => $activeChatsPagination->hasMorePages(),
                'has_pages' => $activeChatsPagination->lastPage() > 1,
            ],
            'historyPagination' => [
                'current_page' => $recentChatsPagination->currentPage(),
                'last_page' => $recentChatsPagination->lastPage(),
                'total' => $recentChatsPagination->total(),
                'has_more_pages' => $recentChatsPagination->hasMorePages(),
                'has_pages' => $recentChatsPagination->lastPage() > 1,
            ],
            'isAgent' => true,
        ]);
    }

    public function create()
    {
        return Inertia::render('Complaints/Create', [
            'auth' => ['user' => auth()->user()],
        ]);
    }

    public function store(Request $request)
    {
        // This now creates a live chat session instead of a traditional complaint
        $validated = $request->validate([
            'subject' => 'required|string|max:255',
            'description' => 'required|string',
            'priority' => 'required|string|in:low,normal,high,urgent',
            'category' => 'nullable|string|max:255',
        ]);

        $user = auth()->user();

        // Create support chat session
        $chat = SupportChat::create([
            'session_id' => Str::uuid(),
            'user_id' => $user->id,
            'status' => 'waiting',
            'priority' => $validated['priority'],
            'category' => $validated['category'],
            'initial_message' => $validated['description'],
            'started_at' => now(),
        ]);

        // Create initial message
        $chat->messages()->create([
            'user_id' => $user->id,
            'message' => "**Subject:** {$validated['subject']}\n\n{$validated['description']}",
            'message_type' => 'text',
            'sender_type' => 'user',
        ]);

        // Update queue positions
        $this->updateQueuePositions();

        return redirect()->route('complaints.chat', $chat->session_id)
            ->with('success', 'Chat session started! You are now in the support queue.');
    }

    public function chat($sessionId)
    {
        $chat = SupportChat::where('session_id', $sessionId)->firstOrFail();
        $user = auth()->user();

        // Check if user has permission to view this chat
        if ($chat->user_id !== $user->id && !in_array($user->role, ['admin', 'teacher'])) {
            abort(403);
        }

        // Load chat with messages and related data
        $chat->load([
            'messages.user',
            'agent',
            'user'
        ]);

        // Mark messages as read
        if ($chat->user_id === $user->id) {
            // User reading messages
            $chat->messages()->unreadByUser()->update([
                'is_read_by_user' => true,
                'read_by_user_at' => now(),
            ]);
        } elseif (in_array($user->role, ['admin', 'teacher'])) {
            // Agent reading messages
            $chat->messages()->unreadByAgent()->update([
                'is_read_by_agent' => true,
                'read_by_agent_at' => now(),
            ]);
        }

        return Inertia::render('Complaints/Chat', [
            'auth' => ['user' => $user],
            'chat' => $chat,
            'messages' => $chat->messages,
            'isAgent' => in_array($user->role, ['admin', 'teacher']),
        ]);
    }

    public function assignChat(Request $request, $sessionId)
    {
        $user = auth()->user();
        
        // Only admin or teacher can assign chats
        if (!in_array($user->role, ['admin', 'teacher'])) {
            abort(403);
        }

        $chat = SupportChat::where('session_id', $sessionId)->firstOrFail();

        if ($chat->status !== 'waiting') {
            return back()->withErrors(['error' => 'This chat is not available for assignment.']);
        }

        // Assign the chat to current user
        $chat->assignAgent($user);

        // Update queue positions for remaining chats
        $this->updateQueuePositions();

        return redirect()->route('complaints.chat', $sessionId);
    }

    public function closeChat(Request $request, $sessionId)
    {
        $user = auth()->user();
        $chat = SupportChat::where('session_id', $sessionId)->firstOrFail();

        // Check permissions
        if ($chat->agent_id !== $user->id && !in_array($user->role, ['admin'])) {
            abort(403);
        }

        $chat->close($request->input('resolution_summary'));

        return redirect()->route('complaints.index')
            ->with('success', 'Chat has been closed successfully.');
    }

    public function sendMessage(Request $request, $sessionId)
    {
        $validated = $request->validate([
            'message' => 'required|string',
            'message_type' => 'required|string|in:text,image,file',
        ]);

        $user = auth()->user();
        $chat = SupportChat::where('session_id', $sessionId)->firstOrFail();

        // Check permissions
        if ($chat->user_id !== $user->id && $chat->agent_id !== $user->id && !in_array($user->role, ['admin', 'teacher'])) {
            abort(403);
        }

        // Determine sender type
        $senderType = 'user';
        if (in_array($user->role, ['admin', 'teacher'])) {
            $senderType = 'agent';
        }

        // Create message
        $message = $chat->messages()->create([
            'user_id' => $user->id,
            'message' => $validated['message'],
            'message_type' => $validated['message_type'],
            'sender_type' => $senderType,
        ]);

        // Mark as read by sender
        if ($senderType === 'user') {
            $message->markAsReadByUser();
        } else {
            $message->markAsReadByAgent();
        }

        // Return the message for real-time updates
        return response()->json([
            'message' => $message->load('user'),
            'chat_status' => $chat->status,
        ]);
    }

    private function updateQueuePositions()
    {
        $waitingChats = SupportChat::waiting()->orderBy('created_at')->get();
        
        foreach ($waitingChats as $index => $chat) {
            $chat->updateQueuePosition($index + 1);
        }
    }

    public function show($id)
    {
        // Legacy support - redirect to new chat system
        return redirect()->route('complaints.index');
    }
}
