<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { defineProps } from 'vue';

const props = defineProps({
    auth: Object,
    subjects: Array,
});
</script>

<template>
    <Head title="My Subjects" />

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
                <Link href="/student/subjects" class="flex items-center px-4 py-2 text-gray-700 bg-gray-200 rounded-md">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197m.547-4.197h-.547"></path>
                    </svg>
                    My Subjects
                </Link>
                <Link href="/student/profile" class="flex items-center px-4 py-2 text-gray-500 hover:bg-gray-200 rounded-md">
                    <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                    </svg>
                    My Profile
                </Link>
            </nav>
            <div class="p-4 border-t">
                <div class="flex items-center">
                    <img :src="props.auth.user.profile_photo_url || 'https://via.placeholder.com/40'" class="w-10 h-10 rounded-full mr-3" />
                    <div>
                        <p class="font-semibold text-gray-800">{{ props.auth.user.name }}</p>
                        <p class="text-sm text-gray-500">{{ props.auth.user.email }}</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="flex-1 flex flex-col p-8 overflow-y-auto">
            <h1 class="text-3xl font-bold mb-6">My Subjects</h1>
            <div class="bg-white p-6 rounded-lg shadow-md">
                <ul class="space-y-4">
                    <li v-for="subject in subjects" :key="subject.id" class="p-4 bg-gray-50 rounded-md border border-gray-200">
                        <h2 class="text-xl font-semibold">{{ subject.name }}</h2>
                        <p class="text-gray-600 mt-1">Teacher: {{ subject.teacher }}</p>
                        <p class="text-sm text-gray-500">Room: {{ subject.room }}</p>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>
