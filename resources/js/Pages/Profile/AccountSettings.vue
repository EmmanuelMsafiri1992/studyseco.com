<script setup>
import { Head, useForm } from '@inertiajs/vue3';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({
    auth: Object,
    enrollment: Object,
    enrollmentStatus: Object,
});
const user = props.auth?.user || { name: 'Guest', role: 'guest', profile_photo_url: null };

const form = useForm({
    name: user.name || '',
    email: user.email || '',
    password: '',
    profile_photo: null,
});

const handleFileSelect = (event) => {
    form.profile_photo = event.target.files[0];
};

const updateProfile = () => {
    form.patch(route('profile.update'), {
        forceFormData: true,
        preserveScroll: true,
        onSuccess: () => {
            if (!form.password) {
                form.reset('password');
            }
        },
        onError: () => {
            if (form.errors.password) {
                form.reset('password');
            }
        },
    });
};

const upgradeToPremium = () => {
    // Redirect to payment page with upgrade flag
    window.location.href = '/payments/create?upgrade=true';
};
</script>

<template>
    <Head title="Account Settings" />
    
    <DashboardLayout title="Account Settings" subtitle="Update your profile information">
        <div class="max-w-4xl mx-auto">
            <div class="bg-white rounded-xl shadow-sm p-8">
                <form @submit.prevent="updateProfile">
                    <div class="space-y-6">
                        <!-- Profile Photo Section -->
                        <div class="flex items-center space-x-6">
                            <div class="shrink-0">
                                <img 
                                    :src="user.profile_photo_url ? `/storage/${user.profile_photo_url}` : 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face&facepad=2&bg=white'" 
                                    :alt="user.name" 
                                    class="h-20 w-20 rounded-full object-cover ring-4 ring-white shadow-lg"
                                >
                            </div>
                            <div class="flex-1">
                                <h3 class="text-lg font-medium text-gray-900 mb-2">Profile Photo</h3>
                                <input 
                                    type="file" 
                                    @change="handleFileSelect" 
                                    accept="image/*" 
                                    class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-medium file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                                >
                                <p class="mt-1 text-sm text-gray-600">JPG, PNG, GIF up to 2MB</p>
                                <div v-if="form.errors.profile_photo" class="mt-1 text-sm text-red-600">{{ form.errors.profile_photo }}</div>
                            </div>
                        </div>

                        <hr class="border-gray-200">

                        <!-- Personal Information -->
                        <div class="grid grid-cols-1 gap-6 sm:grid-cols-2">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Full Name</label>
                                <input 
                                    v-model="form.name" 
                                    type="text" 
                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                    placeholder="Enter your full name"
                                >
                                <div v-if="form.errors.name" class="mt-1 text-sm text-red-600">{{ form.errors.name }}</div>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                                <input 
                                    v-model="form.email" 
                                    type="email" 
                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                    placeholder="Enter your email"
                                >
                                <div v-if="form.errors.email" class="mt-1 text-sm text-red-600">{{ form.errors.email }}</div>
                            </div>
                        </div>

                        <!-- Password -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">New Password (optional)</label>
                            <input 
                                v-model="form.password" 
                                type="password" 
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                placeholder="Leave blank to keep current password"
                            >
                            <p class="mt-1 text-sm text-gray-600">Leave blank to keep your current password</p>
                            <div v-if="form.errors.password" class="mt-1 text-sm text-red-600">{{ form.errors.password }}</div>
                        </div>

                        <!-- User Role Display -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Account Type</label>
                            <div class="px-4 py-3 bg-gray-50 border border-gray-300 rounded-lg">
                                <span class="font-medium text-gray-900 capitalize">{{ user.role }}</span>
                            </div>
                            <p class="mt-1 text-sm text-gray-600">Your account type cannot be changed</p>
                        </div>

                        <!-- Enrollment Status & Upgrade Section (Students Only) -->
                        <div v-if="user.role === 'student'" class="space-y-6">
                            <hr class="border-gray-200">
                            
                            <div>
                                <h3 class="text-lg font-medium text-gray-900 mb-4">Enrollment Status</h3>
                                
                                <!-- Current Status Display -->
                                <div v-if="enrollmentStatus" class="bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-200 rounded-lg p-6 mb-6">
                                    <div class="flex items-center justify-between mb-4">
                                        <div>
                                            <h4 class="text-lg font-semibold text-gray-900">
                                                {{ enrollmentStatus.is_trial ? 'Free Trial Account' : 'Premium Account' }}
                                            </h4>
                                            <p class="text-sm text-gray-600">
                                                {{ enrollmentStatus.is_trial ? '7 Days Free Trial' : 'Full Access Account' }}
                                            </p>
                                        </div>
                                        <div class="flex items-center space-x-2">
                                            <span v-if="enrollmentStatus.is_trial" class="px-3 py-1 bg-blue-100 text-blue-800 text-sm font-medium rounded-full">
                                                🆓 Trial
                                            </span>
                                            <span v-else class="px-3 py-1 bg-purple-100 text-purple-800 text-sm font-medium rounded-full">
                                                ⭐ Premium
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                        <div class="bg-white rounded-lg p-4">
                                            <div class="text-sm text-gray-600">Subjects Enrolled</div>
                                            <div class="text-xl font-bold text-gray-900">{{ enrollmentStatus.subjects_count }}</div>
                                        </div>
                                        <div class="bg-white rounded-lg p-4">
                                            <div class="text-sm text-gray-600">Access Remaining</div>
                                            <div class="text-xl font-bold text-gray-900">{{ enrollmentStatus.access_days_remaining }} days</div>
                                        </div>
                                        <div class="bg-white rounded-lg p-4">
                                            <div class="text-sm text-gray-600">Status</div>
                                            <div class="text-xl font-bold capitalize" :class="{
                                                'text-green-600': enrollmentStatus.status === 'approved',
                                                'text-yellow-600': enrollmentStatus.status === 'pending',
                                                'text-red-600': enrollmentStatus.status === 'rejected'
                                            }">{{ enrollmentStatus.status }}</div>
                                        </div>
                                    </div>
                                    
                                    <!-- Upgrade Button for Trial Users -->
                                    <div v-if="enrollmentStatus.is_trial" class="mt-6 pt-4 border-t border-blue-200">
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <h5 class="font-semibold text-gray-900 mb-1">Ready to upgrade?</h5>
                                                <p class="text-sm text-gray-600">Get unlimited access to all subjects and features</p>
                                            </div>
                                            <button 
                                                @click="upgradeToPremium" 
                                                class="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-lg shadow-sm text-white bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-700 hover:to-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 transition-all duration-200"
                                            >
                                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"></path>
                                                </svg>
                                                Upgrade to Premium
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- No Enrollment Message -->
                                <div v-else class="bg-gray-50 border border-gray-200 rounded-lg p-6 text-center">
                                    <div class="w-12 h-12 bg-gray-200 rounded-full flex items-center justify-center mx-auto mb-4">
                                        <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                        </svg>
                                    </div>
                                    <h4 class="text-lg font-medium text-gray-900 mb-2">No Active Enrollment</h4>
                                    <p class="text-gray-600 mb-4">You haven't enrolled in any courses yet.</p>
                                    <a 
                                        href="/student/enrollment" 
                                        class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
                                    >
                                        Start Learning Journey
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="mt-8 flex justify-end">
                        <button 
                            type="submit" 
                            :disabled="form.processing"
                            class="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-lg shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            <svg v-if="form.processing" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                            {{ form.processing ? 'Updating...' : 'Update Profile' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </DashboardLayout>
</template>