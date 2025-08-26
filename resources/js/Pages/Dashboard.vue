<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref } from 'vue';
import { Bar, Line, Doughnut } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, PointElement, LineElement, ArcElement } from 'chart.js';

// Define the component's props and get the user object
const props = defineProps({
    auth: Object,
});
const user = props.auth.user;

// Chart.js registration
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, PointElement, LineElement, ArcElement);

// Enhanced sample data for charts
const studentAttendanceData = ref({
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
    datasets: [{
        label: 'Student Attendance %',
        backgroundColor: 'rgba(99, 102, 241, 0.8)',
        borderColor: 'rgb(99, 102, 241)',
        borderWidth: 2,
        borderRadius: 8,
        data: [85, 90, 88, 92, 89]
    }]
});

const teacherAttendanceData = ref({
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
    datasets: [{
        label: 'Teacher Attendance %',
        backgroundColor: 'rgba(16, 185, 129, 0.1)',
        borderColor: 'rgb(16, 185, 129)',
        borderWidth: 3,
        data: [95, 98, 96, 99, 97],
        fill: true,
        tension: 0.4,
        pointBackgroundColor: 'rgb(16, 185, 129)',
        pointBorderColor: 'white',
        pointBorderWidth: 2,
        pointRadius: 6
    }]
});

const subjectDistribution = ref({
    labels: ['Science', 'Mathematics', 'Languages', 'Arts', 'Sports'],
    datasets: [{
        data: [12, 15, 8, 6, 4],
        backgroundColor: [
            'rgba(99, 102, 241, 0.8)',
            'rgba(16, 185, 129, 0.8)',
            'rgba(245, 158, 11, 0.8)',
            'rgba(239, 68, 68, 0.8)',
            'rgba(139, 92, 246, 0.8)'
        ],
        borderWidth: 0,
    }]
});

const chartOptions = ref({
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {
            display: true,
            labels: {
                font: {
                    family: 'Inter, system-ui, sans-serif',
                    size: 12
                }
            }
        }
    },
    scales: {
        y: {
            beginAtZero: true,
            grid: {
                color: 'rgba(0, 0, 0, 0.05)'
            }
        },
        x: {
            grid: {
                display: false
            }
        }
    }
});

const doughnutOptions = ref({
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {
            position: 'bottom',
            labels: {
                padding: 20,
                font: {
                    family: 'Inter, system-ui, sans-serif',
                    size: 11
                }
            }
        }
    }
});
</script>

<template>
    <div class="flex h-screen bg-gradient-to-br from-slate-50 to-blue-50 font-sans text-slate-800">
        <div class="w-72 bg-white/80 backdrop-blur-xl border-r border-slate-200/50 flex-shrink-0 shadow-xl">
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
                <!-- Dashboard - Available to all roles -->
                <Link href="/dashboard" class="flex items-center px-4 py-3 text-slate-700 bg-indigo-50 rounded-xl border border-indigo-100 transition-all duration-200 hover:bg-indigo-100">
                    <svg class="h-5 w-5 mr-4 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
                    </svg>
                    <span class="font-medium">Dashboard</span>
                </Link>

                <!-- Academics - Available to all roles -->
                <Link href="/subjects" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197"></path>
                    </svg>
                    <span class="font-medium">Academics</span>
                </Link>

                <!-- Admin Only Items -->
                <template v-if="user.role === 'admin'">
                    <Link href="/students" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                        <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
                        </svg>
                        <span class="font-medium">Students</span>
                        <span class="ml-auto text-xs bg-indigo-100 text-indigo-700 px-2 py-1 rounded-full">1,850</span>
                    </Link>
                    <Link href="/teachers" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                        <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                        </svg>
                        <span class="font-medium">Faculty</span>
                        <span class="ml-auto text-xs bg-green-100 text-green-700 px-2 py-1 rounded-full">125</span>
                    </Link>
                    <Link href="/fees" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                        <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"></path>
                        </svg>
                        <span class="font-medium">Finance</span>
                    </Link>
                </template>

                <!-- Available to all roles -->
                <Link href="/complaints" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192L5.636 18.364M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-5 0a4 4 0 11-8 0 4 4 0 018 0z"></path>
                    </svg>
                    <span class="font-medium">Support</span>
                    <span v-if="user.role === 'admin'" class="ml-auto text-xs bg-red-100 text-red-700 px-2 py-1 rounded-full">7</span>
                </Link>

                <Link href="/payments" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
                    </svg>
                    <span class="font-medium">Payments</span>
                </Link>

                <Link href="/reports" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                    </svg>
                    <span class="font-medium">Analytics</span>
                </Link>

                <!-- Settings - Admin only -->
                <div v-if="user.role === 'admin'" class="pt-4 mt-4 border-t border-slate-200">
                    <Link href="/settings" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                        <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.82 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.82 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.82-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.82-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                        </svg>
                        <span class="font-medium">Settings</span>
                    </Link>
                </div>
            </nav>
        </div>

        <div class="flex-1 flex flex-col">
            <header class="h-20 bg-white/70 backdrop-blur-xl border-b border-slate-200/50 px-8 flex items-center justify-between relative z-50">
                <div>
                    <h1 class="text-2xl font-bold text-slate-800">Good morning, {{ user.name }}!</h1>
                    <p class="text-slate-500 text-sm">Here's what's happening at your school today</p>
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

            <main class="flex-1 overflow-y-auto p-8 space-y-8 relative">
                <div v-if="user.role === 'admin'">
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <div class="bg-gradient-to-r from-indigo-500 to-purple-600 rounded-3xl p-6 text-white transform hover:scale-105 transition-all duration-200 shadow-xl">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-indigo-100 text-sm font-medium">Total Students</p>
                                    <p class="text-4xl font-bold mt-2">1,850</p>
                                    <p class="text-indigo-200 text-sm mt-1">+12% from last month</p>
                                </div>
                                <div class="bg-white/20 p-4 rounded-2xl backdrop-blur-sm">
                                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1z"></path>
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-emerald-500 to-teal-600 rounded-3xl p-6 text-white transform hover:scale-105 transition-all duration-200 shadow-xl">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-emerald-100 text-sm font-medium">Faculty Members</p>
                                    <p class="text-4xl font-bold mt-2">125</p>
                                    <p class="text-emerald-200 text-sm mt-1">+3 new this week</p>
                                </div>
                                <div class="bg-white/20 p-4 rounded-2xl backdrop-blur-sm">
                                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-amber-500 to-orange-600 rounded-3xl p-6 text-white transform hover:scale-105 transition-all duration-200 shadow-xl">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-amber-100 text-sm font-medium">Active Subjects</p>
                                    <p class="text-4xl font-bold mt-2">45</p>
                                    <p class="text-amber-200 text-sm mt-1">Across all departments</p>
                                </div>
                                <div class="bg-white/20 p-4 rounded-2xl backdrop-blur-sm">
                                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197"></path>
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <div class="bg-gradient-to-r from-rose-500 to-pink-600 rounded-3xl p-6 text-white transform hover:scale-105 transition-all duration-200 shadow-xl">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-rose-100 text-sm font-medium">Pending Issues</p>
                                    <p class="text-4xl font-bold mt-2">7</p>
                                    <p class="text-rose-200 text-sm mt-1">Requires attention</p>
                                </div>
                                <div class="bg-white/20 p-4 rounded-2xl backdrop-blur-sm">
                                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 xl:grid-cols-3 gap-8">
                        <div class="xl:col-span-2 bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                            <div class="flex items-center justify-between mb-6">
                                <h2 class="text-2xl font-bold text-slate-800">Student Attendance Trends</h2>
                                <div class="flex space-x-2">
                                    <button class="px-4 py-2 bg-indigo-100 text-indigo-700 rounded-xl font-medium text-sm">Week</button>
                                    <button class="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-xl font-medium text-sm">Month</button>
                                    <button class="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-xl font-medium text-sm">Year</button>
                                </div>
                            </div>
                            <div class="h-80">
                                <Bar :data="studentAttendanceData" :options="chartOptions" />
                            </div>
                        </div>

                        <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                            <h2 class="text-2xl font-bold text-slate-800 mb-6">Subject Distribution</h2>
                            <div class="h-80">
                                <Doughnut :data="subjectDistribution" :options="doughnutOptions" />
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
                        <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                            <h2 class="text-2xl font-bold text-slate-800 mb-6">Faculty Attendance</h2>
                            <div class="h-80">
                                <Line :data="teacherAttendanceData" :options="chartOptions" />
                            </div>
                        </div>

                        <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                            <h2 class="text-2xl font-bold text-slate-800 mb-6">Recent Activity</h2>
                            <div class="space-y-4">
                                <div class="flex items-start space-x-4 p-4 rounded-2xl bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-100">
                                    <div class="w-3 h-3 bg-blue-500 rounded-full mt-2 flex-shrink-0"></div>
                                    <div>
                                        <p class="font-medium text-slate-800">New student enrollment</p>
                                        <p class="text-sm text-slate-600">Sarah Wilson joined Grade 10A</p>
                                        <p class="text-xs text-slate-500 mt-1">2 minutes ago</p>
                                    </div>
                                </div>

                                <div class="flex items-start space-x-4 p-4 rounded-2xl bg-gradient-to-r from-green-50 to-emerald-50 border border-green-100">
                                    <div class="w-3 h-3 bg-green-500 rounded-full mt-2 flex-shrink-0"></div>
                                    <div>
                                        <p class="font-medium text-slate-800">Payment received</p>
                                        <p class="text-sm text-slate-600">Student #S1025 - $750</p>
                                        <p class="text-xs text-slate-500 mt-1">15 minutes ago</p>
                                    </div>
                                </div>

                                <div class="flex items-start space-x-4 p-4 rounded-2xl bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-100">
                                    <div class="w-3 h-3 bg-amber-500 rounded-full mt-2 flex-shrink-0"></div>
                                    <div>
                                        <p class="font-medium text-slate-800">Schedule updated</p>
                                        <p class="text-sm text-slate-600">Math class moved to Room 201</p>
                                        <p class="text-xs text-slate-500 mt-1">1 hour ago</p>
                                    </div>
                                </div>

                                <div class="flex items-start space-x-4 p-4 rounded-2xl bg-gradient-to-r from-rose-50 to-pink-50 border border-rose-100">
                                    <div class="w-3 h-3 bg-rose-500 rounded-full mt-2 flex-shrink-0"></div>
                                    <div>
                                        <p class="font-medium text-slate-800">Support ticket</p>
                                        <p class="text-sm text-slate-600">Login issue reported by T#021</p>
                                        <p class="text-xs text-slate-500 mt-1">2 hours ago</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 xl:grid-cols-3 gap-8">
                        <div class="xl:col-span-2 bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                            <h2 class="text-2xl font-bold text-slate-800 mb-6">Financial Overview</h2>
                            <div class="overflow-hidden rounded-2xl border border-slate-200">
                                <table class="w-full">
                                    <thead class="bg-slate-50">
                                        <tr>
                                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Student ID</th>
                                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Student Name</th>
                                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Amount Due</th>
                                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Status</th>
                                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-slate-200">
                                        <tr class="hover:bg-slate-50 transition-colors duration-150">
                                            <td class="px-6 py-4 text-sm font-medium text-slate-800">#S1001</td>
                                            <td class="px-6 py-4 text-sm text-slate-600">Michael Chen</td>
                                            <td class="px-6 py-4 text-sm font-semibold text-rose-600">$500.00</td>
                                            <td class="px-6 py-4">
                                                <span class="px-3 py-1 text-xs font-semibold rounded-full bg-rose-100 text-rose-800">Overdue</span>
                                            </td>
                                            <td class="px-6 py-4">
                                                <button class="text-indigo-600 hover:text-indigo-800 text-sm font-medium">Send Reminder</button>
                                            </td>
                                        </tr>
                                        <tr class="hover:bg-slate-50 transition-colors duration-150">
                                            <td class="px-6 py-4 text-sm font-medium text-slate-800">#S1002</td>
                                            <td class="px-6 py-4 text-sm text-slate-600">Emma Rodriguez</td>
                                            <td class="px-6 py-4 text-sm font-semibold text-emerald-600">$0.00</td>
                                            <td class="px-6 py-4">
                                                <span class="px-3 py-1 text-xs font-semibold rounded-full bg-emerald-100 text-emerald-800">Paid</span>
                                            </td>
                                            <td class="px-6 py-4">
                                                <button class="text-slate-400 text-sm">No action</button>
                                            </td>
                                        </tr>
                                        <tr class="hover:bg-slate-50 transition-colors duration-150">
                                            <td class="px-6 py-4 text-sm font-medium text-slate-800">#S1003</td>
                                            <td class="px-6 py-4 text-sm text-slate-600">James Thompson</td>
                                            <td class="px-6 py-4 text-sm font-semibold text-amber-600">$250.00</td>
                                            <td class="px-6 py-4">
                                                <span class="px-3 py-1 text-xs font-semibold rounded-full bg-amber-100 text-amber-800">Pending</span>
                                            </td>
                                            <td class="px-6 py-4">
                                                <button class="text-indigo-600 hover:text-indigo-800 text-sm font-medium">Follow Up</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                            <h2 class="text-2xl font-bold text-slate-800 mb-6">Quick Actions</h2>
                            <div class="space-y-4">
                                <button class="w-full bg-gradient-to-r from-indigo-500 to-purple-600 text-white p-4 rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                                    <div class="flex items-center justify-center space-x-2">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                                        </svg>
                                        <span>Add New Student</span>
                                    </div>
                                </button>

                                <button class="w-full bg-gradient-to-r from-emerald-500 to-teal-600 text-white p-4 rounded-2xl font-semibold hover:from-emerald-600 hover:to-teal-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                                    <div class="flex items-center justify-center space-x-2">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                                        </svg>
                                        <span>Generate Report</span>
                                    </div>
                                </button>

                                <button class="w-full bg-gradient-to-r from-amber-500 to-orange-600 text-white p-4 rounded-2xl font-semibold hover:from-amber-600 hover:to-orange-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                                    <div class="flex items-center justify-center space-x-2">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3a1 1 0 011-1h6a1 1 0 011 1v4m-5 8h4m-4 0v4a1 1 0 001 1h2a1 1 0 001-1v-4m-4 0H7a2 2 0 01-2-2V7a2 2 0 012-2h2v2"></path>
                                        </svg>
                                        <span>Schedule Event</span>
                                    </div>
                                </button>

                                <button class="w-full bg-gradient-to-r from-rose-500 to-pink-600 text-white p-4 rounded-2xl font-semibold hover:from-rose-600 hover:to-pink-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                                    <div class="flex items-center justify-center space-x-2">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                                        </svg>
                                        <span>Send Announcement</span>
                                    </div>
                                </button>
                            </div>

                            <div class="mt-8 p-6 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl border border-blue-100">
                                <h3 class="font-semibold text-slate-800 mb-2">System Status</h3>
                                <div class="space-y-2">
                                    <div class="flex items-center justify-between">
                                        <span class="text-sm text-slate-600">Server</span>
                                        <div class="flex items-center space-x-2">
                                            <div class="w-2 h-2 bg-green-500 rounded-full"></div>
                                            <span class="text-xs text-green-600 font-medium">Online</span>
                                        </div>
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <span class="text-sm text-slate-600">Database</span>
                                        <div class="flex items-center space-x-2">
                                            <div class="w-2 h-2 bg-green-500 rounded-full"></div>
                                            <span class="text-xs text-green-600 font-medium">Healthy</span>
                                        </div>
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <span class="text-sm text-slate-600">Backup</span>
                                        <div class="flex items-center space-x-2">
                                            <div class="w-2 h-2 bg-amber-500 rounded-full"></div>
                                            <span class="text-xs text-amber-600 font-medium">Running</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                        <div class="flex items-center justify-between mb-6">
                            <h2 class="text-2xl font-bold text-slate-800">Recent Notifications</h2>
                            <button class="text-indigo-600 hover:text-indigo-800 font-medium text-sm">View All</button>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                            <div class="p-6 rounded-2xl bg-gradient-to-br from-blue-50 to-indigo-100 border border-blue-200 hover:shadow-lg transition-all duration-200">
                                <div class="flex items-start justify-between mb-3">
                                    <div class="p-2 bg-blue-500 rounded-xl">
                                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1z"></path>
                                        </svg>
                                    </div>
                                    <span class="text-xs text-blue-600 bg-blue-200 px-2 py-1 rounded-full">Student</span>
                                </div>
                                <h3 class="font-semibold text-slate-800 mb-1">New Enrollment</h3>
                                <p class="text-sm text-slate-600 mb-2">Alex Kumar joined Grade 11B</p>
                                <p class="text-xs text-slate-500">5 minutes ago</p>
                            </div>

                            <div class="p-6 rounded-2xl bg-gradient-to-br from-emerald-50 to-green-100 border border-emerald-200 hover:shadow-lg transition-all duration-200">
                                <div class="flex items-start justify-between mb-3">
                                    <div class="p-2 bg-emerald-500 rounded-xl">
                                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"></path>
                                        </svg>
                                    </div>
                                    <span class="text-xs text-emerald-600 bg-emerald-200 px-2 py-1 rounded-full">Payment</span>
                                </div>
                                <h3 class="font-semibold text-slate-800 mb-1">Fee Payment</h3>
                                <p class="text-sm text-slate-600 mb-2">Lisa Park paid $850</p>
                                <p class="text-xs text-slate-500">10 minutes ago</p>
                            </div>

                            <div class="p-6 rounded-2xl bg-gradient-to-br from-amber-50 to-yellow-100 border border-amber-200 hover:shadow-lg transition-all duration-200">
                                <div class="flex items-start justify-between mb-3">
                                    <div class="p-2 bg-amber-500 rounded-xl">
                                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
                                        </svg>
                                    </div>
                                    <span class="text-xs text-amber-600 bg-amber-200 px-2 py-1 rounded-full">Alert</span>
                                </div>
                                <h3 class="font-semibold text-slate-800 mb-1">Low Attendance</h3>
                                <p class="text-sm text-slate-600 mb-2">Grade 9A below threshold</p>
                                <p class="text-xs text-slate-500">1 hour ago</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-else-if="user.role === 'teacher'">
                    <h2 class="text-2xl font-bold text-slate-800 mb-6">Your Dashboard</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="bg-gradient-to-r from-emerald-500 to-teal-600 rounded-3xl p-6 text-white transform hover:scale-105 transition-all duration-200 shadow-xl">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-emerald-100 text-sm font-medium">Your Attendance</p>
                                    <p class="text-4xl font-bold mt-2">98%</p>
                                    <p class="text-emerald-200 text-sm mt-1">Excellent record</p>
                                </div>
                                <div class="bg-white/20 p-4 rounded-2xl backdrop-blur-sm">
                                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                                    </svg>
                                </div>
                            </div>
                        </div>
                        <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                            <h2 class="text-2xl font-bold text-slate-800 mb-6">Your Classes</h2>
                            <div class="space-y-4">
                                <div class="p-4 rounded-xl bg-slate-50 border border-slate-200">
                                    <h3 class="font-semibold text-slate-800">Mathematics Grade 10A</h3>
                                    <p class="text-sm text-slate-600">Total students: 25</p>
                                </div>
                                <div class="p-4 rounded-xl bg-slate-50 border border-slate-200">
                                    <h3 class="font-semibold text-slate-800">Physics Grade 11B</h3>
                                    <p class="text-sm text-slate-600">Total students: 20</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-else-if="user.role === 'student'">
                    <h2 class="text-2xl font-bold text-slate-800 mb-6">Your Dashboard</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="bg-gradient-to-r from-indigo-500 to-purple-600 rounded-3xl p-6 text-white transform hover:scale-105 transition-all duration-200 shadow-xl">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-indigo-100 text-sm font-medium">Your Attendance</p>
                                    <p class="text-4xl font-bold mt-2">92%</p>
                                    <p class="text-indigo-200 text-sm mt-1">Keep up the good work!</p>
                                </div>
                                <div class="bg-white/20 p-4 rounded-2xl backdrop-blur-sm">
                                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1z"></path>
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                            <h2 class="text-2xl font-bold text-slate-800 mb-6">Your Enrolled Subjects</h2>
                            <div class="space-y-4">
                                <div class="p-4 rounded-xl bg-slate-50 border border-slate-200">
                                    <h3 class="font-semibold text-slate-800">Mathematics</h3>
                                    <p class="text-sm text-slate-600">Teacher: Jane Doe</p>
                                </div>
                                <div class="p-4 rounded-xl bg-slate-50 border border-slate-200">
                                    <h3 class="font-semibold text-slate-800">Physics</h3>
                                    <p class="text-sm text-slate-600">Teacher: John Smith</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-else>
                    <h2 class="text-xl font-semibold mb-4">Welcome to the Dashboard</h2>
                    <p class="text-slate-500">
                        Please log in with a recognized role to view your personalized content.
                    </p>
                </div>
            </main>
        </div>
    </div>
</template>
