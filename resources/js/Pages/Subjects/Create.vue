<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    auth: Object,
});
const user = props.auth?.user || { name: 'Guest', role: 'guest', profile_photo_url: null };

const form = useForm({
    name: '',
    code: '',
    description: '',
    department: '',
    grade_level: '',
    credits: 1,
    teacher_name: '',
    cover_image: null,
});

const coverImageInput = ref(null);
const photoPreview = ref(null);

const selectNewPhoto = () => {
    coverImageInput.value.click();
};

const updatePhotoPreview = () => {
    const photo = coverImageInput.value.files[0];

    if (!photo) return;

    const reader = new FileReader();

    reader.onload = (e) => {
        photoPreview.value = e.target.result;
    };

    reader.readAsDataURL(photo);
    form.cover_image = photo;
};

const submit = () => {
    form.post(route('subjects.store'), {
        onSuccess: () => {
            // Form submission successful
        },
        onError: (errors) => {
            console.error('Form errors:', errors);
        }
    });
};

// Malawian secondary school grade levels
const gradeLevels = [
    'Form 1',
    'Form 2', 
    'Form 3',
    'Form 4'
];

// Common subjects for Malawian secondary schools
const departments = [
    'Mathematics',
    'English',
    'Physical Science',
    'Biology',
    'Chemistry',
    'Physics',
    'Geography',
    'History',
    'Chichewa',
    'Religious Education',
    'Life Skills',
    'Agriculture',
    'Business Studies',
    'Computer Studies'
];
</script>

<template>
    <Head title="Add New Subject" />
    
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
                <!-- Dashboard - Available to all roles -->
                <Link :href="route('dashboard')" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                    <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
                    </svg>
                    <span class="font-medium">Dashboard</span>
                </Link>

                <!-- Academics - Available to all roles -->
                <Link :href="route('subjects.index')" class="flex items-center px-4 py-3 text-slate-700 bg-indigo-50 rounded-xl border border-indigo-100 transition-all duration-200 hover:bg-indigo-100">
                    <svg class="h-5 w-5 mr-4 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197"></path>
                    </svg>
                    <span class="font-medium">Academics</span>
                </Link>

                <!-- Admin Only Items -->
                <template v-if="user?.role === 'admin'">
                    <Link href="/students" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                        <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
                        </svg>
                        <span class="font-medium">Students</span>
                    </Link>
                    <Link href="/teachers" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
                        <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                        </svg>
                        <span class="font-medium">Faculty</span>
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
                <div v-if="user?.role === 'admin'" class="pt-4 mt-4 border-t border-slate-200">
                    <Link :href="route('settings.index')" class="flex items-center px-4 py-3 text-slate-600 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800">
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
                    <h1 class="text-2xl font-bold text-slate-800">Add New Subject</h1>
                    <p class="text-slate-500 text-sm">Create a new subject for Malawian secondary education</p>
                </div>
                <div class="flex items-center space-x-4">
                    <div class="relative group">
                        <div class="flex items-center space-x-3 pl-4 border-l border-slate-200 cursor-pointer">
                            <img :src="user?.profile_photo_url || 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face&facepad=2&bg=white'" :alt="user?.name || 'User'" class="h-12 w-12 rounded-2xl ring-2 ring-white shadow-md">
                            <div class="text-sm">
                                <p class="font-semibold text-slate-800">{{ user?.name || 'User' }}</p>
                                <p class="text-slate-500">{{ user?.role || 'guest' }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Form -->
            <main class="flex-1 overflow-y-auto p-8 space-y-8 relative">
                <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                    <form @submit.prevent="submit">
                        <!-- Cover Image Upload -->
                        <div class="mb-8">
                            <label class="block text-sm font-medium text-slate-700 mb-4">Subject Cover Image</label>
                            <div class="flex items-center space-x-6">
                                <div class="w-24 h-24 rounded-2xl bg-gradient-to-br from-indigo-100 to-purple-100 flex items-center justify-center overflow-hidden">
                                    <img v-if="photoPreview" :src="photoPreview" alt="Cover preview" class="w-full h-full object-cover">
                                    <svg v-else class="w-8 h-8 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                    </svg>
                                </div>
                                <div>
                                    <button type="button" @click="selectNewPhoto" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 rounded-xl text-sm font-medium transition-colors duration-200">
                                        Select Image
                                    </button>
                                    <p class="text-xs text-slate-500 mt-1">JPG, PNG up to 2MB</p>
                                </div>
                            </div>
                            <input ref="coverImageInput" type="file" class="hidden" @change="updatePhotoPreview" accept="image/*">
                            <div v-if="form.errors.cover_image" class="mt-2 text-sm text-red-600">{{ form.errors.cover_image }}</div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">Subject Name*</label>
                                <input v-model="form.name" type="text" required 
                                       class="w-full bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200"
                                       placeholder="e.g. Mathematics, Physical Science">
                                <div v-if="form.errors.name" class="mt-1 text-sm text-red-600">{{ form.errors.name }}</div>
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">Subject Code*</label>
                                <input v-model="form.code" type="text" required 
                                       class="w-full bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200"
                                       placeholder="e.g. MATH101, PHYS102">
                                <div v-if="form.errors.code" class="mt-1 text-sm text-red-600">{{ form.errors.code }}</div>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">Department/Subject Area*</label>
                                <select v-model="form.department" required 
                                        class="w-full bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200">
                                    <option value="">Select Department</option>
                                    <option v-for="dept in departments" :key="dept" :value="dept">{{ dept }}</option>
                                </select>
                                <div v-if="form.errors.department" class="mt-1 text-sm text-red-600">{{ form.errors.department }}</div>
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">Grade Level*</label>
                                <select v-model="form.grade_level" required 
                                        class="w-full bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200">
                                    <option value="">Select Form</option>
                                    <option v-for="level in gradeLevels" :key="level" :value="level">{{ level }}</option>
                                </select>
                                <div v-if="form.errors.grade_level" class="mt-1 text-sm text-red-600">{{ form.errors.grade_level }}</div>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">Teacher Name</label>
                                <input v-model="form.teacher_name" type="text" 
                                       class="w-full bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200"
                                       placeholder="Teacher's full name">
                                <div v-if="form.errors.teacher_name" class="mt-1 text-sm text-red-600">{{ form.errors.teacher_name }}</div>
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-2">Credits*</label>
                                <select v-model="form.credits" required 
                                        class="w-full bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200">
                                    <option :value="1">1 Credit</option>
                                    <option :value="2">2 Credits</option>
                                    <option :value="3">3 Credits</option>
                                    <option :value="4">4 Credits</option>
                                </select>
                                <div v-if="form.errors.credits" class="mt-1 text-sm text-red-600">{{ form.errors.credits }}</div>
                            </div>
                        </div>

                        <div class="mb-6">
                            <label class="block text-sm font-medium text-slate-700 mb-2">Description</label>
                            <textarea v-model="form.description" rows="4"
                                      class="w-full bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200"
                                      placeholder="Describe what students will learn in this subject..."></textarea>
                            <div v-if="form.errors.description" class="mt-1 text-sm text-red-600">{{ form.errors.description }}</div>
                        </div>

                        <div class="flex justify-end space-x-4">
                            <Link :href="route('subjects.index')" 
                                  class="px-6 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-2xl font-semibold transition-all duration-200">
                                Cancel
                            </Link>
                            <button type="submit" :disabled="form.processing"
                                    class="px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1 disabled:opacity-50 disabled:cursor-not-allowed">
                                <span v-if="form.processing">Creating...</span>
                                <span v-else>Create Subject</span>
                            </button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
</template>