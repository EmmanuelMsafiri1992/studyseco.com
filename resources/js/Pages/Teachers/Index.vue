<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({
    auth: Object,
    teachers: Array,
    stats: Object,
    filters: Object,
});

const user = props.auth?.user || { name: 'Guest', role: 'guest', profile_photo_url: null };

// Mock data fallback
const teachers = ref(props.teachers?.length > 0 ? props.teachers : [
    { id: 'T001', name: 'John Doe', department: 'Mathematics', email: 'john.doe@school.edu', phone: '+1234567890', status: 'active' },
    { id: 'T002', name: 'Jane Smith', department: 'Science', email: 'jane.smith@school.edu', phone: '+1234567891', status: 'active' },
    { id: 'T003', name: 'Bob Johnson', department: 'English', email: 'bob.johnson@school.edu', phone: '+1234567892', status: 'inactive' },
]);

const searchQuery = ref(props.filters?.search || '');
const selectedDepartment = ref(props.filters?.department || 'all');

const filteredTeachers = computed(() => {
    return teachers.value.filter(teacher => {
        const matchesSearch = teacher.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                              teacher.id.toLowerCase().includes(searchQuery.value.toLowerCase());
        const matchesDepartment = selectedDepartment.value === 'all' || teacher.department === selectedDepartment.value;
        return matchesSearch && matchesDepartment;
    });
});

// Apply filters
const applyFilters = () => {
    const params = new URLSearchParams();
    if (searchQuery.value) params.set('search', searchQuery.value);
    if (selectedDepartment.value && selectedDepartment.value !== 'all') params.set('department', selectedDepartment.value);
    
    router.get(route('teachers.index'), Object.fromEntries(params));
};

const resetFilters = () => {
    searchQuery.value = '';
    selectedDepartment.value = 'all';
    router.get(route('teachers.index'));
};
</script>

<template>
    <Head title="Faculty Management" />

    <DashboardLayout 
        title="Faculty Management" 
        subtitle="Manage and monitor all teachers in your institution"
        :stats="stats">

        <!-- Search and Filter Bar -->
        <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50 mb-8">
            <div class="flex flex-col md:flex-row gap-4 items-center justify-between">
                <div class="flex-1 max-w-md">
                    <div class="relative">
                        <input v-model="searchQuery" @input="applyFilters" type="text" placeholder="Search teachers..." class="w-full bg-slate-100/70 backdrop-blur-sm px-4 py-3 pl-10 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200">
                        <svg class="absolute left-3 top-3.5 h-4 w-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </div>
                </div>
                <div class="flex items-center space-x-4">
                    <select v-model="selectedDepartment" @change="applyFilters" class="bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white appearance-none">
                        <option value="all">All Departments</option>
                        <option value="Mathematics">Mathematics</option>
                        <option value="Science">Science</option>
                        <option value="English">English</option>
                    </select>
                    <button @click="resetFilters" class="text-slate-500 hover:text-slate-700 px-4 py-3 rounded-2xl text-sm transition-colors">
                        Clear Filters
                    </button>
                    <Link href="/teachers/create" class="bg-gradient-to-r from-indigo-500 to-purple-600 text-white px-6 py-3 rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                        <div class="flex items-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                            </svg>
                            <span>Add Teacher</span>
                        </div>
                    </Link>
                </div>
            </div>
        </div>

        <!-- Teachers Table -->
        <div class="bg-white/80 backdrop-blur-sm rounded-3xl shadow-xl border border-slate-200/50 overflow-hidden">
            <div class="p-6 border-b border-slate-200/50">
                <h2 class="text-xl font-bold text-slate-800">All Teachers</h2>
                <p class="text-sm text-slate-500 mt-1">{{ filteredTeachers.length }} teachers found</p>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-slate-50/50">
                        <tr>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Teacher ID</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Name</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Department</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Contact</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Status</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-200/50">
                        <tr v-for="teacher in filteredTeachers" :key="teacher.id" class="hover:bg-slate-50/50 transition-colors duration-150">
                            <td class="px-6 py-4 text-sm font-medium text-slate-800">{{ teacher.id }}</td>
                            <td class="px-6 py-4">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-gradient-to-r from-green-500 to-teal-600 rounded-full flex items-center justify-center text-white font-semibold text-sm">
                                        {{ teacher.name.charAt(0) }}
                                    </div>
                                    <span class="text-sm font-medium text-slate-800">{{ teacher.name }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-sm text-slate-600">{{ teacher.department }}</td>
                            <td class="px-6 py-4">
                                <div class="text-sm">
                                    <p class="text-slate-800">{{ teacher.email }}</p>
                                    <p class="text-slate-500">{{ teacher.phone }}</p>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <span :class="teacher.status === 'active' ? 'bg-emerald-100 text-emerald-800' : 'bg-red-100 text-red-800'" class="px-3 py-1 text-xs font-semibold rounded-full">
                                    {{ teacher.status }}
                                </span>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex items-center space-x-2">
                                    <Link :href="`/teachers/${teacher.id || ''}`" class="text-indigo-600 hover:text-indigo-800 text-sm font-medium">View</Link>
                                    <Link :href="`/teachers/${teacher.id || ''}/edit`" class="text-amber-600 hover:text-amber-800 text-sm font-medium">Edit</Link>
                                    <button class="text-red-600 hover:text-red-800 text-sm font-medium">Delete</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="px-6 py-4 border-t border-slate-200/50">
                <div class="flex items-center justify-between">
                    <p class="text-sm text-slate-600">Showing 1 to {{ filteredTeachers.length }} of {{ filteredTeachers.length }} results</p>
                    <div class="flex items-center space-x-2">
                        <button class="px-3 py-2 text-sm text-slate-600 hover:bg-slate-100 rounded-lg transition-colors duration-150">Previous</button>
                        <button class="px-3 py-2 text-sm bg-indigo-100 text-indigo-700 rounded-lg">1</button>
                        <button class="px-3 py-2 text-sm text-slate-600 hover:bg-slate-100 rounded-lg transition-colors duration-150">2</button>
                        <button class="px-3 py-2 text-sm text-slate-600 hover:bg-slate-100 rounded-lg transition-colors duration-150">3</button>
                        <button class="px-3 py-2 text-sm text-slate-600 hover:bg-slate-100 rounded-lg transition-colors duration-150">Next</button>
                    </div>
                </div>
            </div>
        </div>
    </DashboardLayout>
</template>