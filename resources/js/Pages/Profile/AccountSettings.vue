<script setup>
import { Head, useForm } from '@inertiajs/vue3';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({
    auth: Object,
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