<script setup>
import { ref } from 'vue'
import { Head, Link, usePage } from '@inertiajs/vue3'

const showingNavigationDropdown = ref(false)
const page = usePage()
const user = page.props.auth?.user || { name: 'Admin', role: 'admin', profile_photo_url: null }
</script>

<template>
    <div class="min-h-screen bg-gradient-to-br from-secondary-50 via-white to-primary-50">
        <!-- Navigation Header -->
        <header class="glass border-b border-secondary-200/50 px-6 h-20 flex items-center justify-between sticky top-0 z-50">
            <div class="flex items-center space-x-4">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-primary-500 to-accent-500 flex items-center justify-center shadow-soft">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                            <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                        </svg>
                    </div>
                    <div>
                        <Link :href="route('dashboard')" class="text-xl font-bold text-secondary-900">
                            StudySeco Admin
                        </Link>
                        <div class="text-xs text-secondary-500 -mt-1">Management Portal</div>
                    </div>
                </div>
            </div>
            
            <nav class="hidden lg:flex items-center space-x-2">
                <Link :href="route('dashboard')" 
                      :class="route().current('dashboard') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                      class="transition-all duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                        <polyline points="9,22 9,12 15,12 15,22"/>
                    </svg>
                    Dashboard
                </Link>
                
                <Link :href="route('subjects.index')" 
                      :class="route().current('subjects.*') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                      class="transition-all duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                    </svg>
                    Subjects
                </Link>
                
                <Link :href="route('payments.index')" 
                      :class="route().current('payments.*') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                      class="transition-all duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                        <rect x="1" y="4" width="22" height="16" rx="2" ry="2"/>
                        <line x1="1" y1="10" x2="23" y2="10"/>
                    </svg>
                    Payments
                </Link>
                
                <Link :href="route('admin.payment-settings.index')" 
                      :class="route().current('admin.payment-settings.*') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                      class="transition-all duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                        <circle cx="12" cy="12" r="3"/>
                        <path d="M12 1v6m0 6v6m11-7h-6m-6 0H1"/>
                    </svg>
                    Settings
                </Link>
                
                <Link :href="route('admin.school-selections.index')" 
                      :class="route().current('admin.school-selections.*') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                      class="transition-all duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                        <path d="M8 2v4l-6 6h12l-6-6V2z"/>
                        <path d="M8 22v-2c0-1.1-.9-2-2-2s-2 .9-2 2v2h4z"/>
                    </svg>
                    Schools
                </Link>
                
                <Link :href="route('admin.site-content.index')" 
                      :class="route().current('admin.site-content.*') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                      class="transition-all duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                        <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
                        <polyline points="14,2 14,8 20,8"/>
                    </svg>
                    Content
                </Link>
            </nav>
            
            <!-- User Menu -->
            <div class="flex items-center space-x-4">
                <div class="text-right hidden sm:block">
                    <p class="text-sm font-semibold text-secondary-900">{{ user.name }}</p>
                    <p class="text-xs text-secondary-500 capitalize">{{ user.role || 'Administrator' }}</p>
                </div>
                
                <div class="relative">
                    <img :src="user.profile_photo_url || 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face&facepad=2&bg=white'" 
                         :alt="user.name" 
                         class="h-12 w-12 rounded-xl shadow-soft border border-white object-cover">
                    <div class="absolute -top-1 -right-1 w-4 h-4 bg-success-500 rounded-full border-2 border-white"></div>
                </div>
                
                <!-- Mobile menu button -->
                <button 
                    @click="showingNavigationDropdown = !showingNavigationDropdown"
                    class="lg:hidden p-2 rounded-lg hover:bg-secondary-100 transition-colors"
                >
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="4" y1="6" x2="20" y2="6"/>
                        <line x1="4" y1="12" x2="20" y2="12"/>
                        <line x1="4" y1="18" x2="20" y2="18"/>
                    </svg>
                </button>
            </div>
        </header>

        <!-- Mobile Navigation -->
        <div v-show="showingNavigationDropdown" class="lg:hidden glass-card mx-4 mt-2 p-4 space-y-2">
            <Link :href="route('dashboard')" 
                  :class="route().current('dashboard') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                  class="flex items-center w-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                    <polyline points="9,22 9,12 15,12 15,22"/>
                </svg>
                Dashboard
            </Link>
            
            <Link :href="route('subjects.index')" 
                  :class="route().current('subjects.*') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                  class="flex items-center w-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                    <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                    <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                </svg>
                Subjects
            </Link>
            
            <Link :href="route('payments.index')" 
                  :class="route().current('payments.*') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                  class="flex items-center w-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                    <rect x="1" y="4" width="22" height="16" rx="2" ry="2"/>
                    <line x1="1" y1="10" x2="23" y2="10"/>
                </svg>
                Payments
            </Link>
            
            <Link :href="route('admin.payment-settings.index')" 
                  :class="route().current('admin.payment-settings.*') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                  class="flex items-center w-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                    <circle cx="12" cy="12" r="3"/>
                    <path d="M12 1v6m0 6v6m11-7h-6m-6 0H1"/>
                </svg>
                Settings
            </Link>
            
            <Link :href="route('admin.school-selections.index')" 
                  :class="route().current('admin.school-selections.*') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                  class="flex items-center w-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                    <path d="M8 2v4l-6 6h12l-6-6V2z"/>
                    <path d="M8 22v-2c0-1.1-.9-2-2-2s-2 .9-2 2v2h4z"/>
                </svg>
                Schools
            </Link>
            
            <Link :href="route('admin.site-content.index')" 
                  :class="route().current('admin.site-content.*') ? 'nav-link-active' : 'nav-link text-secondary-600'"
                  class="flex items-center w-full">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                    <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
                    <polyline points="14,2 14,8 20,8"/>
                </svg>
                Content
            </Link>
        </div>

        <!-- Main Content -->
        <main class="flex-1 p-6">
            <slot />
        </main>
    </div>
</template>