<template>
    <div>
        <Head title="Enrollment Management" />
        
        <AuthenticatedLayout>
            <template #header>
                <h2 class="font-semibold text-xl text-gray-800 leading-tight">
                    Enrollment Management
                </h2>
            </template>

            <div class="py-12">
                <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                    <!-- Stats Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
                        <div class="bg-white overflow-hidden shadow-sm rounded-lg p-6">
                            <div class="text-2xl font-bold text-blue-600">{{ enrollmentStats.total || 0 }}</div>
                            <div class="text-sm text-gray-600">Total Enrollments</div>
                        </div>
                        <div class="bg-white overflow-hidden shadow-sm rounded-lg p-6">
                            <div class="text-2xl font-bold text-yellow-600">{{ enrollmentStats.pending || 0 }}</div>
                            <div class="text-sm text-gray-600">Pending Review</div>
                        </div>
                        <div class="bg-white overflow-hidden shadow-sm rounded-lg p-6">
                            <div class="text-2xl font-bold text-green-600">{{ enrollmentStats.approved || 0 }}</div>
                            <div class="text-sm text-gray-600">Approved</div>
                        </div>
                        <div class="bg-white overflow-hidden shadow-sm rounded-lg p-6">
                            <div class="text-2xl font-bold text-red-600">{{ enrollmentStats.rejected || 0 }}</div>
                            <div class="text-sm text-gray-600">Rejected</div>
                        </div>
                    </div>

                    <!-- Enrollments Table -->
                    <div class="bg-white overflow-hidden shadow-sm rounded-lg">
                        <div class="p-6 border-b border-gray-200">
                            <div class="flex justify-between items-center">
                                <h3 class="text-lg font-semibold">Student Enrollments</h3>
                                <div class="flex space-x-2">
                                    <select v-model="statusFilter" @change="filterEnrollments" class="rounded-md border-gray-300">
                                        <option value="">All Status</option>
                                        <option value="pending">Pending</option>
                                        <option value="approved">Approved</option>
                                        <option value="rejected">Rejected</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Student
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Contact
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Subjects
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Amount
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Status
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Date
                                        </th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Actions
                                        </th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <tr v-for="enrollment in enrollments.data" :key="enrollment.id" class="hover:bg-gray-50">
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="flex items-center">
                                                <div class="flex-shrink-0 h-10 w-10">
                                                    <div class="h-10 w-10 rounded-full bg-gray-300 flex items-center justify-center">
                                                        <span class="text-sm font-medium text-gray-700">
                                                            {{ enrollment.name.charAt(0) }}
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="ml-4">
                                                    <div class="text-sm font-medium text-gray-900">{{ enrollment.name }}</div>
                                                    <div class="text-sm text-gray-500">{{ enrollment.enrollment_number }}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            <div>{{ enrollment.email }}</div>
                                            <div>{{ enrollment.phone }}</div>
                                            <div class="text-xs">{{ enrollment.country }}</div>
                                        </td>
                                        <td class="px-6 py-4 text-sm text-gray-500">
                                            <div class="max-w-xs">
                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                    {{ enrollment.selected_subjects ? enrollment.selected_subjects.length : 0 }} subjects
                                                </span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <div class="font-medium">
                                                {{ formatCurrency(enrollment.total_amount, enrollment.currency) }}
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span :class="getStatusClass(enrollment.status)" class="inline-flex px-2 py-1 text-xs font-semibold rounded-full">
                                                {{ enrollment.status }}
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                            {{ formatDate(enrollment.created_at) }}
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                            <Link :href="route('admin.enrollments.show', enrollment.id)" 
                                                  class="text-indigo-600 hover:text-indigo-900 mr-3">
                                                View
                                            </Link>
                                            <button v-if="enrollment.status === 'pending'" 
                                                    @click="approveEnrollment(enrollment.id)"
                                                    class="text-green-600 hover:text-green-900 mr-3">
                                                Approve
                                            </button>
                                            <button v-if="enrollment.status === 'pending'" 
                                                    @click="rejectEnrollment(enrollment.id)"
                                                    class="text-red-600 hover:text-red-900">
                                                Reject
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div v-if="enrollments.links" class="px-6 py-3 border-t border-gray-200">
                            <nav class="flex items-center justify-between">
                                <div class="flex justify-between flex-1 sm:hidden">
                                    <Link v-if="enrollments.prev_page_url" :href="enrollments.prev_page_url" 
                                          class="relative inline-flex items-center px-4 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:text-gray-400">
                                        Previous
                                    </Link>
                                    <Link v-if="enrollments.next_page_url" :href="enrollments.next_page_url" 
                                          class="relative ml-3 inline-flex items-center px-4 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:text-gray-400">
                                        Next
                                    </Link>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </AuthenticatedLayout>
    </div>
</template>

<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';

const props = defineProps({
    enrollments: Object,
    enrollmentStats: Object
});

const statusFilter = ref('');

const getStatusClass = (status) => {
    switch (status) {
        case 'pending':
            return 'bg-yellow-100 text-yellow-800';
        case 'approved':
            return 'bg-green-100 text-green-800';
        case 'rejected':
            return 'bg-red-100 text-red-800';
        default:
            return 'bg-gray-100 text-gray-800';
    }
};

const formatCurrency = (amount, currency) => {
    const symbols = {
        'MWK': 'MK',
        'ZAR': 'R',
        'USD': '$'
    };
    return `${symbols[currency] || currency} ${new Intl.NumberFormat().format(amount)}`;
};

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
};

const approveEnrollment = (id) => {
    if (confirm('Are you sure you want to approve this enrollment?')) {
        const form = useForm({});
        form.patch(route('admin.enrollments.approve', id));
    }
};

const rejectEnrollment = (id) => {
    const reason = prompt('Please provide a reason for rejection (optional):');
    if (reason !== null) {
        const form = useForm({
            admin_notes: reason
        });
        form.patch(route('admin.enrollments.reject', id));
    }
};

const filterEnrollments = () => {
    // Implementation would reload with filter
    const params = statusFilter.value ? { status: statusFilter.value } : {};
    router.get(route('admin.enrollments.index'), params, {
        preserveState: true,
        preserveScroll: true
    });
};
</script>