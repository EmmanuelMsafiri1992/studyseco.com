<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref } from 'vue';
import { Bar, Line, Doughnut } from 'vue-chartjs';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  ArcElement
} from 'chart.js';

const props = defineProps({
  auth: Object,
});

const user = props.auth?.user || { name: 'Guest', role: 'guest', profile_photo_url: null };

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  ArcElement
);

// Sample data for charts
const attendanceData = ref({
  labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
  datasets: [{
    label: 'Attendance %',
    backgroundColor: 'rgba(99, 102, 241, 0.8)',
    data: [95, 92, 96, 94, 93, 95]
  }]
});

const gradeData = ref({
  labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
  datasets: [{
    label: 'Average Grade',
    borderColor: 'rgb(16, 185, 129)',
    data: [85, 87, 88, 90, 92, 91],
    fill: true
  }]
});

const feeData = ref({
  labels: ['Paid', 'Overdue', 'Pending'],
  datasets: [{
    data: [70, 20, 10],
    backgroundColor: ['rgba(16, 185, 129, 0.8)', 'rgba(239, 68, 68, 0.8)', 'rgba(245, 158, 11, 0.8)']
  }]
});
</script>

<template>
  <div class="flex h-screen bg-gradient-to-br from-slate-50 to-blue-50 font-sans text-slate-800">
    <!-- Sidebar -->
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
        <!-- Dashboard -->
        <Link href="/dashboard" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
          </svg>
          <span class="font-medium">Dashboard</span>
        </Link>

        <!-- Students -->
        <Link href="/students" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm6-12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
          <span class="font-medium">Students</span>
          <span v-if="user.role === 'admin'" class="ml-auto text-xs bg-indigo-100 text-indigo-700 px-2 py-1 rounded-full">1,850</span>
        </Link>

        <!-- Faculty -->
        <template v-if="user.role === 'admin' || user.role === 'teacher'">
          <Link href="/teachers" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
            <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
            </svg>
            <span class="font-medium">Faculty</span>
            <span v-if="user.role === 'admin'" class="ml-auto text-xs bg-green-100 text-green-700 px-2 py-1 rounded-full">125</span>
          </Link>
        </template>

        <!-- Academics -->
        <Link href="/subjects" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197"></path>
          </svg>
          <span class="font-medium">Academics</span>
        </Link>

        <!-- Finance -->
        <Link href="/fees" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"></path>
          </svg>
          <span class="font-medium">Finance</span>
        </Link>

        <!-- Payments -->
        <Link href="/payments" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
          </svg>
          <span class="font-medium">Payments</span>
        </Link>

        <!-- Support -->
        <Link href="/complaints" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.645C5.525 14.88 7.42 16 9 16c2.31 0 4.792-.88 6-2.5l-.5-1.5"></path>
          </svg>
          <span class="font-medium">Support</span>
          <span class="ml-auto text-xs bg-red-100 text-red-700 px-2 py-1 rounded-full">7</span>
        </Link>

        <!-- Analytics -->
        <Link href="/reports" class="flex items-center px-4 py-3 text-slate-700 bg-indigo-50 rounded-xl border border-indigo-100 transition-all duration-200 hover:bg-indigo-100">
          <svg class="h-5 w-5 mr-4 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
          </svg>
          <span class="font-medium">Analytics</span>
        </Link>

        <!-- Settings -->
        <div class="pt-4 mt-4 border-t border-slate-200">
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

    <!-- Main Content -->
    <div class="flex-1 flex flex-col">
      <!-- Header -->
      <header class="h-20 bg-white/70 backdrop-blur-xl border-b border-slate-200/50 px-8 flex items-center justify-between relative z-50">
        <div>
          <h1 class="text-2xl font-bold text-slate-800">Analytics & Reports</h1>
          <p class="text-slate-500 text-sm">View school statistics</p>
        </div>
        <div class="flex items-center space-x-4">
          <img v-if="user.profile_photo_url" :src="user.profile_photo_url" alt="Profile" class="w-10 h-10 rounded-full" />
          <span class="text-slate-700 font-medium">{{ user.name }}</span>
        </div>
      </header>

      <!-- Main Content -->
      <main class="flex-1 overflow-y-auto p-8 space-y-8 relative">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <!-- Attendance Chart -->
          <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50">
            <h3 class="text-lg font-bold text-slate-800 mb-4">Attendance Overview</h3>
            <div class="h-64">
              <Bar :data="attendanceData" :options="{ responsive: true, maintainAspectRatio: false }" />
            </div>
          </div>

          <!-- Grade Chart -->
          <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50">
            <h3 class="text-lg font-bold text-slate-800 mb-4">Grade Trends</h3>
            <div class="h-64">
              <Line :data="gradeData" :options="{ responsive: true, maintainAspectRatio: false }" />
            </div>
          </div>

          <!-- Fee Chart -->
          <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50">
            <h3 class="text-lg font-bold text-slate-800 mb-4">Fee Status</h3>
            <div class="h-64">
              <Doughnut :data="feeData" :options="{ responsive: true, maintainAspectRatio: false }" />
            </div>
          </div>
        </div>
      </main>
    </div>
  </div>
</template>
