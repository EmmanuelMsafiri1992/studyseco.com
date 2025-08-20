<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    auth: Object,
});
const user = props.auth?.user || { name: 'Guest', role: 'guest', profile_photo_url: null };

const form = ref({
    theme: 'light',
    notifications: true,
});
</script>

<template>
    <div class="flex h-screen bg-gradient-to-br from-slate-50 to-blue-50 font-sans text-slate-800">
        <!-- Sidebar -->
        <div class="w-72 bg-white/80 backdrop-blur-xl border-r border-slate-200/50 flex-shrink-0 shadow-xl">
            <!-- Same -->
            <div class="p-8 border-b border-slate-200/50">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center">
                        <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197m.547-4.197h-.547"></path>
                        </svg>
                    </div>
                    <div>
                        <h1 class="text-xl font-bold text-slate-800">EduVerse</h1>
                        <p class="text-sm text-slate-500">School Management</p>
                    </div>
                </div>
            </div>
            <nav class="px-4 py-6 space-y-2">
                <Link href="/dashboard" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
                    </svg>
                    <span class="font-medium">Dashboard</span>
                </Link>
                <Link href="/students" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm6-12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <span class="font-medium">Students</span>
                    <span v-if="user.role === 'admin'" class="ml-auto text-xs bg-indigo-100 text-indigo-700 px-2 py-1 rounded-full">1,850</span>
                </Link>
                <template v-if="user.role === 'admin' || user.role === 'teacher'">
                    <Link href="/teachers" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                        <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                        </svg>
                        <span class="font-medium">Faculty</span>
                        <span v-if="user.role === 'admin'" class="ml-auto text-xs bg-green-100 text-green-700 px-2 py-1 rounded-full">125</span>
                    </Link>
                </template>
                <Link href="/subjects" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197"></path>
                    </svg>
                    <span class="font-medium">Academics</span>
                </Link>
                <Link href="/fees" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"></path>
                    </svg>
                    <span class="font-medium">Finance</span>
                </Link>
                <Link href="/payments" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
                    </svg>
                    <span class="font-medium">Payments</span>
                </Link>
                <Link href="/complaints" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.645C5.525 14.88 7.42 16 9 16c2.31 0 4.792-.88 6-2.5l-.5-1.5"></path>
                    </svg>
                    <span class="font-medium">Support</span>
                    <span class="ml-auto text-xs bg-red-100 text-red-700 px-2 py-1 rounded-full">7</span>
                </Link>
                <Link href="/reports" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                    </svg>
                    <span class="font-medium">Analytics</span>
                </Link>
                <div class="pt-4 mt-4 border-t border-slate-200">
                    <Link href="/settings" class="flex items-center px-4 py-3 text-slate-700 bg-indigo-50 rounded-xl border border-indigo-100 transition-all duration-200 hover:bg-indigo-100">
                        <svg class="h-5 w-5 mr-4 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.82 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.82 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.82-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.82-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                        </svg>
                        <span class="font-medium">Settings</span>
                    </Link>
                </div>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col">
            <!-- Header -->
            <header class="h-20 bg-white/70 backdrop-blur-xl border-b border-slate-200/50 px-8 flex items-center justify-between relative z-50">
                <div>
                    <h1 class="text-2xl font-bold text-slate-800">System Settings</h1>
                    <p class="text-slate-500 text-sm">Customize your experience</p>
                </div>
                <div class="flex items-center space-x-4">
                    <div class="relative">
                        <input type="text" placeholder="Search anything..." class="bg-slate-100/70 backdrop-blur-sm px-4 py-3 pl-10 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white w-80 transition-all duration-200">
                        <svg class="absolute left-3 top-3.5 h-4 w-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </div>
                    <button class="relative p-3 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-2xl transition-all duration-200">
                        <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0a3 3 0 11-6 0m6 0a3 3 0 00-6 0"></path>
                        </svg>
                        <span class="absolute -top-1 -right-1 h-5 w-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center">3</span>
                    </button>
                    <div class="relative group">
                        <div class="flex items-center space-x-3 pl-4 border-l border-slate-200 cursor-pointer">
                            <img :src="user.profile_photo_url || 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face&facepad=2&bg=white'" :alt="user.name" class="h-12 w-12 rounded-2xl ring-2 ring-white shadow-md">
                            <div class="text-sm">
                                <p class="font-semibold text-slate-800">{{ user.name }}</p>
                                <p class="text-slate-500">{{ user.role }}</p>
                            </div>
                            <svg class="w-4 h-4 text-slate-400 transition-transform duration-200 group-hover:rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                            </svg>
                        </div>
                        <div class="absolute right-0 top-full mt-2 w-56 bg-white/90 backdrop-blur-xl rounded-2xl shadow-xl border border-slate-200/50 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-[9999]">
                            <div class="p-2">
                                <Link href="/profile" class="flex items-center px-4 py-3 text-slate-700 hover:bg-slate-100/70 rounded-xl transition-colors duration-150">
                                    <svg class="w-4 h-4 mr-3 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                    </svg>
                                    View Profile
                                </Link>
                                <Link href="/account-settings" class="flex items-center px-4 py-3 text-slate-700 hover:bg-slate-100/70 rounded-xl transition-colors duration-150">
                                    <svg class="w-4 h-4 mr-3 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.82 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.82 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.82-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.82-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                    </svg>
                                    Account Settings
                                </Link>
                                <hr class="my-2 border-slate-200">
                                <Link href="/logout" method="post" as="button" class="flex items-center w-full px-4 py-3 text-rose-600 hover:bg-rose-50 rounded-xl transition-colors duration-150">
                                    <svg class="w-4 h-4 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                                    </svg>
                                    Sign Out
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Main Content -->
            <main class="flex-1 overflow-y-auto p-8 space-y-8 relative">
                <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50">
                    <form>
                        <div class="grid grid-cols-1 gap-6">
                            <div>
                                <label class="block text-sm font-medium text-slate-700">Theme</label>
                                <select v-model="form.theme" class="mt-1 block w-full bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400">
                                    <option value="light">Light</option>
                                    <option value="dark">Dark</option>
                                </select>
                            </div>
                            <div class="flex items-center">
                                <input v-model="form.notifications" type="checkbox" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded">
                                <label class="ml-3 block text-sm font-medium text-slate-700">Enable Notifications</label>
                            </div>
                        </div>
                        <div class="mt-6 flex justify-end space-x-4">
                            <button type="submit" class="px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                                Save Settings
                            </button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
</template>

