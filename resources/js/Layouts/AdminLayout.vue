<script setup>
import { ref } from 'vue'
import { Head, Link, usePage } from '@inertiajs/vue3'

const showingNavigationDropdown = ref(false)
const page = usePage()
const user = page.props.auth?.user || { name: 'Admin', role: 'admin', profile_photo_url: null }
</script>

<template>
    <div class="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 font-sans text-slate-800">
        <!-- Navigation Header -->
        <header class="h-16 bg-white/70 backdrop-blur-xl border-b border-slate-200/50 px-6 flex items-center justify-between relative z-50">
            <div class="flex items-center space-x-4">
                <Link :href="route('dashboard')" class="text-2xl font-bold text-slate-800">
                    StudySeco Admin
                </Link>
            </div>
            
            <nav class="hidden md:flex items-center space-x-6">
                <Link :href="route('dashboard')" 
                      :class="route().current('dashboard') ? 'text-indigo-600 font-semibold' : 'text-slate-600 hover:text-slate-900'"
                      class="px-3 py-2 rounded-lg transition-colors">
                    Dashboard
                </Link>
                <Link :href="route('subjects.index')" 
                      :class="route().current('subjects.*') ? 'text-indigo-600 font-semibold' : 'text-slate-600 hover:text-slate-900'"
                      class="px-3 py-2 rounded-lg transition-colors">
                    Subjects
                </Link>
                <Link :href="route('payments.index')" 
                      :class="route().current('payments.*') ? 'text-indigo-600 font-semibold' : 'text-slate-600 hover:text-slate-900'"
                      class="px-3 py-2 rounded-lg transition-colors">
                    Payments
                </Link>
                <Link :href="route('admin.payment-settings.index')" 
                      :class="route().current('admin.payment-settings.*') ? 'text-indigo-600 font-semibold' : 'text-slate-600 hover:text-slate-900'"
                      class="px-3 py-2 rounded-lg transition-colors">
                    Payment Settings
                </Link>
            </nav>
            
            <div class="flex items-center space-x-3">
                <div class="text-right">
                    <p class="text-sm font-semibold text-slate-800">{{ user.name }}</p>
                    <p class="text-xs text-slate-500">{{ user.role }}</p>
                </div>
                <img :src="user.profile_photo_url || 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face&facepad=2&bg=white'" 
                     :alt="user.name" 
                     class="h-10 w-10 rounded-xl ring-2 ring-white shadow-md">
            </div>
        </header>

        <!-- Main Content -->
        <main class="flex-1">
            <slot />
        </main>
    </div>
</template>