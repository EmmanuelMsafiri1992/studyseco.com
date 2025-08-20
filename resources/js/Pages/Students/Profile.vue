<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { defineProps } from 'vue';

const props = defineProps({
    auth: Object,
});

const user = props.auth.user;
</script>

<template>
    <Head title="My Profile" />

    <div class="flex h-screen bg-gray-100">
        <div class="flex flex-col w-64 bg-white shadow-md">
            <div class="p-6 border-b">
                <h1 class="text-2xl font-bold text-gray-800">Student Portal</h1>
            </div>
            <nav class="flex-1 px-2 py-4 space-y-2">
                <Link href="/student/dashboard" class="flex items-center px-4 py-2 text-gray-500 hover:bg-gray-200 rounded-md">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
                    </svg>
                    Dashboard
                </Link>
                <Link href="/student/subjects" class="flex items-center px-4 py-2 text-gray-500 hover:bg-gray-200 rounded-md">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197m.547-4.197h-.547"></path>
                    </svg>
                    My Subjects
                </Link>
                <Link href="/student/profile" class="flex items-center px-4 py-2 text-gray-700 bg-gray-200 rounded-md">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                    </svg>
                    My Profile
                </Link>
            </nav>
            <div class="p-4 border-t">
                <div class="flex items-center">
                    <img :src="user.profile_photo_url || 'https://via.placeholder.com/40'" class="w-10 h-10 rounded-full mr-3" />
                    <div>
                        <p class="font-semibold text-gray-800">{{ user.name }}</p>
                        <p class="text-sm text-gray-500">{{ user.email }}</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="flex-1 flex flex-col p-8 overflow-y-auto">
            <h1 class="text-3xl font-bold mb-6">My Profile</h1>
            <div class="bg-white p-6 rounded-lg shadow-md">
                <div class="flex items-center space-x-6 mb-6">
                    <img :src="user.profile_photo_url || 'https://via.placeholder.com/100'" class="w-24 h-24 rounded-full border-4 border-white shadow-lg" />
                    <div>
                        <h2 class="text-2xl font-bold">{{ user.name }}</h2>
                        <p class="text-gray-600">Role: <span class="capitalize">{{ user.role }}</span></p>
                        <p class="text-gray-600">Email: {{ user.email }}</p>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <h3 class="text-lg font-semibold mb-2">Personal Information</h3>
                        <p class="text-gray-700">Student ID: <span class="font-medium">S1001</span></p>
                        <p class="text-gray-700">Date of Birth: <span class="font-medium">January 1, 2005</span></p>
                        <p class="text-gray-700">Contact Number: <span class="font-medium">+27 12 345 6789</span></p>
                    </div>
                    <div>
                        <h3 class="text-lg font-semibold mb-2">Academic Information</h3>
                        <p class="text-gray-700">Grade: <span class="font-medium">12A</span></p>
                        <p class="text-gray-700">Current GPA: <span class="font-medium">3.8</span></p>
                        <p class="text-gray-700">Enrolled Date: <span class="font-medium">August 15, 2022</span></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
