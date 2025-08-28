<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({
    auth: Object,
    complaints: Array,
    stats: Object,
    filters: Object,
});

const user = props.auth?.user || { name: 'Guest', role: 'guest', profile_photo_url: null };

// Mock data fallback
const complaints = ref(props.complaints?.length > 0 ? props.complaints : [
    { id: 'C001', user: 'Student A', issue: 'Classroom issue', status: 'open', date: '2023-08-20' },
    { id: 'C002', user: 'Parent B', issue: 'Fee dispute', status: 'resolved', date: '2023-08-10' },
    { id: 'C003', user: 'Teacher C', issue: 'Equipment fault', status: 'open', date: '2023-08-15' },
]);

const searchQuery = ref(props.filters?.search || '');
const selectedStatus = ref(props.filters?.status || 'all');

const filteredComplaints = computed(() => {
    return complaints.value.filter(complaint => {
        const matchesSearch = complaint.user.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
                              complaint.id.toLowerCase().includes(searchQuery.value.toLowerCase());
        const matchesStatus = selectedStatus.value === 'all' || complaint.status === selectedStatus.value;
        return matchesSearch && matchesStatus;
    });
});

// Apply filters
const applyFilters = () => {
    const params = new URLSearchParams();
    if (searchQuery.value) params.set('search', searchQuery.value);
    if (selectedStatus.value && selectedStatus.value !== 'all') params.set('status', selectedStatus.value);
    
    router.get(route('complaints.index'), Object.fromEntries(params));
};

const resetFilters = () => {
    searchQuery.value = '';
    selectedStatus.value = 'all';
    router.get(route('complaints.index'));
};

const getStatusBadgeClass = (status) => {
    switch (status) {
        case 'open':
            return 'bg-red-100 text-red-700';
        case 'resolved':
            return 'bg-green-100 text-green-700';
        case 'pending':
            return 'bg-yellow-100 text-yellow-700';
        default:
            return 'bg-gray-100 text-gray-700';
    }
};

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
};
</script>

<template>
    <Head title="Support & Complaints" />

    <DashboardLayout 
        title="Support & Complaints" 
        subtitle="Manage and track customer support requests and complaints"
        :stats="stats">

        <!-- Search and Filter Bar -->
        <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50 mb-8">
            <div class="flex flex-col md:flex-row gap-4 items-center justify-between">
                <div class="flex-1 max-w-md">
                    <div class="relative">
                        <input v-model="searchQuery" @input="applyFilters" type="text" placeholder="Search complaints..." class="w-full bg-slate-100/70 backdrop-blur-sm px-4 py-3 pl-10 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200">
                        <svg class="absolute left-3 top-3.5 h-4 w-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                    </div>
                </div>
                <div class="flex items-center space-x-4">
                    <select v-model="selectedStatus" @change="applyFilters" class="bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white appearance-none">
                        <option value="all">All Status</option>
                        <option value="open">Open</option>
                        <option value="pending">Pending</option>
                        <option value="resolved">Resolved</option>
                    </select>
                    <button @click="resetFilters" class="text-slate-500 hover:text-slate-700 px-4 py-3 rounded-2xl text-sm transition-colors">
                        Clear Filters
                    </button>
                    <Link href="/complaints/create" class="bg-gradient-to-r from-indigo-500 to-purple-600 text-white px-6 py-3 rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                        <div class="flex items-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                            </svg>
                            <span>New Complaint</span>
                        </div>
                    </Link>
                </div>
            </div>
        </div>

        <!-- Complaints Table -->
        <div class="bg-white/80 backdrop-blur-sm rounded-3xl shadow-xl border border-slate-200/50 overflow-hidden">
            <div class="p-6 border-b border-slate-200/50">
                <h2 class="text-xl font-bold text-slate-800">All Complaints</h2>
                <p class="text-sm text-slate-500 mt-1">{{ filteredComplaints.length }} complaints found</p>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-slate-50/50">
                        <tr>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Complaint ID</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">User</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Issue</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Status</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Date</th>
                            <th class="px-6 py-4 text-left text-sm font-semibold text-slate-600">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-200/50">
                        <tr v-for="complaint in filteredComplaints" :key="complaint.id" class="hover:bg-slate-50/50 transition-colors duration-150">
                            <td class="px-6 py-4 text-sm font-medium text-slate-800">{{ complaint.id }}</td>
                            <td class="px-6 py-4">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-gradient-to-r from-blue-500 to-indigo-600 rounded-full flex items-center justify-center text-white font-semibold text-sm">
                                        {{ complaint.user.charAt(0) }}
                                    </div>
                                    <span class="text-sm font-medium text-slate-800">{{ complaint.user }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-sm text-slate-600">{{ complaint.issue }}</td>
                            <td class="px-6 py-4">
                                <span :class="getStatusBadgeClass(complaint.status)" class="px-3 py-1 text-xs font-semibold rounded-full capitalize">
                                    {{ complaint.status }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-sm text-slate-600">{{ formatDate(complaint.date) }}</td>
                            <td class="px-6 py-4">
                                <div class="flex items-center space-x-2">
                                    <Link :href="`/complaints/${complaint.id || ''}`" class="text-indigo-600 hover:text-indigo-800 text-sm font-medium">View</Link>
                                    <Link v-if="user.role === 'admin'" :href="`/complaints/${complaint.id || ''}/edit`" class="text-amber-600 hover:text-amber-800 text-sm font-medium">Edit</Link>
                                    <button v-if="user.role === 'admin'" class="text-red-600 hover:text-red-800 text-sm font-medium">Delete</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="px-6 py-4 border-t border-slate-200/50">
                <div class="flex items-center justify-between">
                    <p class="text-sm text-slate-600">Showing 1 to {{ filteredComplaints.length }} of {{ filteredComplaints.length }} results</p>
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