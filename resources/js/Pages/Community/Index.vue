<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';
import axios from 'axios';

const props = defineProps({
    auth: Object,
    posts: Object,
    subjects: Array,
    filters: Object,
});

const user = props.auth?.user || { name: 'Guest', role: 'guest' };
const showCreateModal = ref(false);
const selectedPost = ref(null);

const createForm = useForm({
    type: 'post',
    title: '',
    content: '',
    subject_id: '',
    priority: 'medium',
    is_anonymous: false,
    tags: [],
    poll_options: [],
    poll_expires_at: '',
    attachments: []
});

const commentForm = useForm({
    content: '',
    parent_id: null
});

const showComments = ref({});

const getPostIcon = (type) => {
    const icons = {
        post: "M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.645C5.525 14.88 7.42 16 9 16c2.31 0 4.792-.88 6-2.5l-.5-1.5",
        question: "M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z",
        resource: "M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z",
        announcement: "M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z"
    };
    return icons[type] || icons.post;
};

const getPriorityColor = (priority) => {
    const colors = {
        low: 'bg-green-100 text-green-800',
        medium: 'bg-blue-100 text-blue-800', 
        high: 'bg-orange-100 text-orange-800',
        urgent: 'bg-red-100 text-red-800'
    };
    return colors[priority] || colors.medium;
};

const formatTime = (date) => {
    const now = new Date();
    const postDate = new Date(date);
    const diffMs = now - postDate;
    const diffMins = Math.floor(diffMs / (1000 * 60));
    const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));
    
    if (diffMins < 1) return 'Just now';
    if (diffMins < 60) return `${diffMins}m ago`;
    if (diffHours < 24) return `${diffHours}h ago`;
    if (diffDays < 7) return `${diffDays}d ago`;
    return postDate.toLocaleDateString();
};

const toggleReaction = async (post, type = 'like') => {
    try {
        const response = await axios.post(route('community.react', post.id), { type });
        post.likes_count = response.data.likes_count;
        post.user_has_liked = !post.user_has_liked;
    } catch (error) {
        console.error('Error toggling reaction:', error);
    }
};

const submitComment = async (post) => {
    try {
        commentForm.post(route('community.comment', post.id), {
            onSuccess: (response) => {
                commentForm.reset();
                post.comments_count++;
            }
        });
    } catch (error) {
        console.error('Error posting comment:', error);
    }
};

const toggleComments = (postId) => {
    showComments.value[postId] = !showComments.value[postId];
};

const addPollOption = () => {
    createForm.poll_options.push('');
};

const removePollOption = (index) => {
    createForm.poll_options.splice(index, 1);
};

const createPost = () => {
    createForm.post(route('community.store'), {
        onSuccess: () => {
            showCreateModal.value = false;
            createForm.reset();
        },
        onError: (errors) => {
            console.error('Create post errors:', errors);
        }
    });
};
</script>

<template>
    <Head title="Community Feed" />
    
    <DashboardLayout title="Community Feed" subtitle="Share, ask, learn together">
        <div class="space-y-6">
            <!-- Navigation Tabs -->
            <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-2 shadow-xl border border-slate-200/50">
                <div class="flex space-x-1">
                    <Link :href="route('chat.index')" 
                          class="flex-1 text-center py-3 px-4 rounded-2xl font-semibold transition-all duration-200 text-slate-600 hover:text-slate-800 hover:bg-slate-100">
                        <div class="flex items-center justify-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.645C5.525 14.88 7.42 16 9 16c2.31 0 4.792-.88 6-2.5l-.5-1.5"></path>
                            </svg>
                            <span>Chat Groups</span>
                        </div>
                    </Link>
                    <Link :href="route('community.index')" 
                          class="flex-1 text-center py-3 px-4 rounded-2xl font-semibold transition-all duration-200 bg-gradient-to-r from-indigo-500 to-purple-600 text-white">
                        <div class="flex items-center justify-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z"></path>
                            </svg>
                            <span>Community Feed</span>
                        </div>
                    </Link>
                </div>
            </div>

            <!-- Filters and Create Post -->
            <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50">
                <div class="flex flex-col lg:flex-row gap-4 items-center justify-between">
                    <!-- Filters -->
                    <div class="flex flex-wrap gap-2">
                        <Link :href="route('community.index', { filter: 'all' })" 
                              :class="['px-4 py-2 rounded-2xl font-medium transition-all duration-200', 
                                       filters.filter === 'all' ? 'bg-indigo-100 text-indigo-700' : 'bg-slate-100 text-slate-600 hover:bg-slate-200']">
                            All Posts
                        </Link>
                        <Link :href="route('community.index', { filter: 'question' })" 
                              :class="['px-4 py-2 rounded-2xl font-medium transition-all duration-200', 
                                       filters.filter === 'question' ? 'bg-indigo-100 text-indigo-700' : 'bg-slate-100 text-slate-600 hover:bg-slate-200']">
                            Questions
                        </Link>
                        <Link :href="route('community.index', { filter: 'resource' })" 
                              :class="['px-4 py-2 rounded-2xl font-medium transition-all duration-200', 
                                       filters.filter === 'resource' ? 'bg-indigo-100 text-indigo-700' : 'bg-slate-100 text-slate-600 hover:bg-slate-200']">
                            Resources
                        </Link>
                        <Link :href="route('community.index', { filter: 'announcement' })" 
                              :class="['px-4 py-2 rounded-2xl font-medium transition-all duration-200', 
                                       filters.filter === 'announcement' ? 'bg-indigo-100 text-indigo-700' : 'bg-slate-100 text-slate-600 hover:bg-slate-200']">
                            Announcements
                        </Link>
                    </div>

                    <!-- Create Post Button -->
                    <button @click="showCreateModal = true" 
                            class="px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                        <div class="flex items-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                            </svg>
                            <span>Create Post</span>
                        </div>
                    </button>
                </div>
            </div>

            <!-- Posts Feed -->
            <div class="space-y-6">
                <div v-for="post in posts.data" :key="post.id" class="bg-white/80 backdrop-blur-sm rounded-3xl shadow-xl border border-slate-200/50 overflow-hidden">
                    <!-- Post Header -->
                    <div class="p-6 border-b border-slate-200/50">
                        <div class="flex items-start justify-between">
                            <div class="flex items-center space-x-4">
                                <img :src="post.is_anonymous ? 'https://ui-avatars.com/api/?name=Anonymous&background=6366f1&color=ffffff' : 
                                           (post.user.profile_photo_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(post.user.name)}&background=6366f1&color=ffffff`)" 
                                     :alt="post.is_anonymous ? 'Anonymous' : post.user.name"
                                     class="w-12 h-12 rounded-full">
                                <div>
                                    <div class="flex items-center space-x-2">
                                        <h3 class="font-semibold text-slate-800">
                                            {{ post.is_anonymous ? 'Anonymous' : post.user.name }}
                                        </h3>
                                        <div class="flex items-center space-x-1">
                                            <svg class="w-4 h-4 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="getPostIcon(post.type)"></path>
                                            </svg>
                                            <span class="text-sm text-slate-500 capitalize">{{ post.type }}</span>
                                        </div>
                                        <span v-if="post.priority !== 'medium'" :class="['px-2 py-1 text-xs font-medium rounded-full', getPriorityColor(post.priority)]">
                                            {{ post.priority.toUpperCase() }}
                                        </span>
                                    </div>
                                    <div class="flex items-center space-x-2 text-sm text-slate-500">
                                        <span>{{ formatTime(post.created_at) }}</span>
                                        <span v-if="post.subject" class="inline-flex items-center px-2 py-1 text-xs font-medium bg-indigo-100 text-indigo-700 rounded-full">
                                            {{ post.subject.name }}
                                        </span>
                                        <span v-if="post.is_solved" class="inline-flex items-center px-2 py-1 text-xs font-medium bg-green-100 text-green-700 rounded-full">
                                            ✓ Solved
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="text-slate-400">
                                <button class="p-2 hover:bg-slate-100 rounded-lg">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"></path>
                                    </svg>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Post Title (if exists) -->
                        <h2 v-if="post.title" class="text-xl font-bold text-slate-800 mt-4">{{ post.title }}</h2>
                    </div>

                    <!-- Post Content -->
                    <div class="p-6">
                        <div class="prose max-w-none text-slate-700 mb-4">
                            {{ post.content }}
                        </div>

                        <!-- Tags -->
                        <div v-if="post.tags && post.tags.length > 0" class="flex flex-wrap gap-2 mb-4">
                            <span v-for="tag in post.tags" :key="tag" class="px-3 py-1 text-sm bg-slate-100 text-slate-600 rounded-full">
                                #{{ tag }}
                            </span>
                        </div>

                        <!-- Poll (if exists) -->
                        <div v-if="post.poll_options && post.poll_options.length > 0" class="bg-slate-50 rounded-2xl p-4 mb-4">
                            <h4 class="font-semibold text-slate-800 mb-3">Poll</h4>
                            <div class="space-y-2">
                                <div v-for="(option, index) in post.poll_options" :key="index" class="flex items-center justify-between p-3 bg-white rounded-xl border hover:border-indigo-300 cursor-pointer">
                                    <span>{{ option }}</span>
                                    <span class="text-sm text-slate-500">
                                        {{ post.poll_votes && post.poll_votes[index] ? post.poll_votes[index].length : 0 }} votes
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Post Actions -->
                    <div class="px-6 py-4 border-t border-slate-200/50 bg-slate-50/50">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-6">
                                <button @click="toggleReaction(post)" 
                                        :class="['flex items-center space-x-2 px-3 py-2 rounded-xl transition-all duration-200', 
                                                post.user_has_liked ? 'bg-red-100 text-red-600' : 'text-slate-500 hover:bg-slate-100']">
                                    <svg class="w-5 h-5" :class="post.user_has_liked ? 'fill-current' : ''" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path>
                                    </svg>
                                    <span class="text-sm font-medium">{{ post.likes_count }}</span>
                                </button>

                                <button @click="toggleComments(post.id)" class="flex items-center space-x-2 px-3 py-2 rounded-xl text-slate-500 hover:bg-slate-100 transition-all duration-200">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.645C5.525 14.88 7.42 16 9 16c2.31 0 4.792-.88 6-2.5l-.5-1.5"></path>
                                    </svg>
                                    <span class="text-sm font-medium">{{ post.comments_count }}</span>
                                </button>

                                <button class="flex items-center space-x-2 px-3 py-2 rounded-xl text-slate-500 hover:bg-slate-100 transition-all duration-200">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.367 2.684 3 3 0 00-5.367-2.684z"></path>
                                    </svg>
                                    <span class="text-sm font-medium">Share</span>
                                </button>
                            </div>

                            <div class="flex items-center space-x-2 text-sm text-slate-500">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                                </svg>
                                <span>{{ post.views_count }} views</span>
                            </div>
                        </div>

                        <!-- Comments Section -->
                        <div v-if="showComments[post.id]" class="mt-4 pt-4 border-t border-slate-200">
                            <!-- Comment Form -->
                            <form @submit.prevent="submitComment(post)" class="mb-4">
                                <div class="flex space-x-3">
                                    <img :src="user.profile_photo_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(user.name)}&background=6366f1&color=ffffff`" 
                                         :alt="user.name" class="w-8 h-8 rounded-full flex-shrink-0">
                                    <div class="flex-1">
                                        <input v-model="commentForm.content" type="text" placeholder="Write a comment..." 
                                               class="w-full px-4 py-2 bg-slate-100 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200">
                                    </div>
                                </div>
                            </form>

                            <!-- Comments List -->
                            <div class="space-y-3">
                                <div v-for="comment in post.comments" :key="comment.id" class="flex space-x-3">
                                    <img :src="comment.user.profile_photo_url || `https://ui-avatars.com/api/?name=${encodeURIComponent(comment.user.name)}&background=6366f1&color=ffffff`" 
                                         :alt="comment.user.name" class="w-8 h-8 rounded-full flex-shrink-0">
                                    <div class="flex-1 bg-slate-100 rounded-2xl px-4 py-2">
                                        <div class="flex items-center justify-between mb-1">
                                            <span class="font-medium text-sm text-slate-800">{{ comment.user.name }}</span>
                                            <span class="text-xs text-slate-500">{{ formatTime(comment.created_at) }}</span>
                                        </div>
                                        <p class="text-sm text-slate-700">{{ comment.content }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Empty State -->
                <div v-if="posts.data.length === 0" class="bg-white/80 backdrop-blur-sm rounded-3xl p-12 text-center shadow-xl border border-slate-200/50">
                    <div class="w-16 h-16 bg-gradient-to-br from-slate-100 to-slate-200 rounded-2xl flex items-center justify-center mx-auto mb-4">
                        <svg class="w-8 h-8 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z"></path>
                        </svg>
                    </div>
                    <h3 class="text-lg font-semibold text-slate-800 mb-2">No posts yet</h3>
                    <p class="text-slate-500 mb-6">Be the first to start a conversation in the community!</p>
                    <button @click="showCreateModal = true" 
                            class="px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                        Create First Post
                    </button>
                </div>
            </div>
        </div>

        <!-- Create Post Modal -->
        <div v-if="showCreateModal" class="fixed inset-0 z-50 overflow-y-auto">
            <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                    <div class="absolute inset-0 bg-gray-500 opacity-75" @click="showCreateModal = false"></div>
                </div>

                <div class="inline-block align-bottom bg-white rounded-3xl text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-2xl sm:w-full">
                    <form @submit.prevent="createPost">
                        <div class="bg-white px-6 pt-6 pb-4">
                            <h3 class="text-xl font-bold text-gray-900 mb-6">Create New Post</h3>
                            
                            <div class="space-y-4">
                                <!-- Post Type -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Post Type</label>
                                    <select v-model="createForm.type" class="w-full border-gray-300 rounded-2xl focus:ring-indigo-500 focus:border-indigo-500">
                                        <option value="post">General Post</option>
                                        <option value="question">Question</option>
                                        <option value="resource">Resource Share</option>
                                        <option value="announcement">Announcement</option>
                                    </select>
                                </div>

                                <!-- Title (optional) -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Title (Optional)</label>
                                    <input v-model="createForm.title" type="text" 
                                           class="w-full border-gray-300 rounded-2xl focus:ring-indigo-500 focus:border-indigo-500" 
                                           placeholder="Give your post a title...">
                                </div>

                                <!-- Content -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Content*</label>
                                    <textarea v-model="createForm.content" rows="5" required
                                              class="w-full border-gray-300 rounded-2xl focus:ring-indigo-500 focus:border-indigo-500 resize-none" 
                                              placeholder="What's on your mind? Share your thoughts, ask a question, or help others..."></textarea>
                                </div>

                                <!-- Subject -->
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Related Subject (Optional)</label>
                                    <select v-model="createForm.subject_id" class="w-full border-gray-300 rounded-2xl focus:ring-indigo-500 focus:border-indigo-500">
                                        <option value="">Select a subject...</option>
                                        <option v-for="subject in subjects" :key="subject.id" :value="subject.id">
                                            {{ subject.name }}
                                        </option>
                                    </select>
                                </div>

                                <div class="grid grid-cols-2 gap-4">
                                    <!-- Priority -->
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Priority</label>
                                        <select v-model="createForm.priority" class="w-full border-gray-300 rounded-2xl focus:ring-indigo-500 focus:border-indigo-500">
                                            <option value="low">Low</option>
                                            <option value="medium">Medium</option>
                                            <option value="high">High</option>
                                            <option value="urgent">Urgent</option>
                                        </select>
                                    </div>

                                    <!-- Anonymous -->
                                    <div class="flex items-center pt-6">
                                        <input v-model="createForm.is_anonymous" type="checkbox" id="anonymous" 
                                               class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                                        <label for="anonymous" class="ml-2 block text-sm text-gray-700">
                                            Post anonymously
                                        </label>
                                    </div>
                                </div>

                                <!-- Poll Options (if applicable) -->
                                <div v-if="createForm.type === 'question'">
                                    <label class="block text-sm font-medium text-gray-700 mb-2">Poll Options (Optional)</label>
                                    <div class="space-y-2">
                                        <div v-for="(option, index) in createForm.poll_options" :key="index" class="flex items-center space-x-2">
                                            <input v-model="createForm.poll_options[index]" type="text" 
                                                   class="flex-1 border-gray-300 rounded-xl focus:ring-indigo-500 focus:border-indigo-500" 
                                                   :placeholder="`Option ${index + 1}`">
                                            <button type="button" @click="removePollOption(index)" class="text-red-500 hover:text-red-700">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                                </svg>
                                            </button>
                                        </div>
                                        <button type="button" @click="addPollOption" v-if="createForm.poll_options.length < 10"
                                                class="text-indigo-600 hover:text-indigo-800 text-sm font-medium">
                                            + Add Poll Option
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="bg-gray-50 px-6 py-4 sm:flex sm:flex-row-reverse">
                            <button type="submit" :disabled="createForm.processing" 
                                    class="w-full inline-flex justify-center rounded-2xl border border-transparent shadow-sm px-6 py-3 bg-indigo-600 text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:ml-3 sm:w-auto sm:text-sm disabled:opacity-50">
                                <span v-if="createForm.processing">Creating...</span>
                                <span v-else>Create Post</span>
                            </button>
                            <button type="button" @click="showCreateModal = false" 
                                    class="mt-3 w-full inline-flex justify-center rounded-2xl border border-gray-300 shadow-sm px-6 py-3 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                                Cancel
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </DashboardLayout>
</template>