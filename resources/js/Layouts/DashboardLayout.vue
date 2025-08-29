<template>
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
            <h1 class="text-xl font-bold text-slate-800">StudySeco</h1>
            <p class="text-sm text-slate-500">School Management</p>
          </div>
        </div>
      </div>

      <nav class="px-4 py-6 space-y-2">
        <!-- Dashboard - Available to all roles -->
        <Link href="/dashboard" :class="['flex items-center px-4 py-3 rounded-xl border transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                         $page.component === 'Dashboard' ? 'text-slate-700 bg-indigo-50 border-indigo-100' : 'text-slate-600 border-transparent']">
          <svg class="h-5 w-5 mr-4" :class="$page.component === 'Dashboard' ? 'text-indigo-600' : ''" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
          </svg>
          <span class="font-medium">Dashboard</span>
        </Link>

        <!-- Academics - Available to all roles -->
        <Link href="/subjects" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                        $page.component?.includes('Subject') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197"></path>
          </svg>
          <span class="font-medium">Academics</span>
        </Link>

        <!-- Library - Available to all roles -->
        <Link href="/library" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                       $page.component?.includes('Library') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 9a2 2 0 00-2 2v2m0 0V9a2 2 0 012-2m0 2a2 2 0 012-2h4a2 2 0 012 2m0 2v10"></path>
          </svg>
          <span class="font-medium">Library</span>
        </Link>

        <!-- Chat - Available to all roles -->
        <Link href="/chat" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                    $page.component?.includes('Chat') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.645C5.525 14.88 7.42 16 9 16c2.31 0 4.792-.88 6-2.5l-.5-1.5"></path>
          </svg>
          <span class="font-medium">Chat</span>
        </Link>

        <!-- Achievements - Available to all roles -->
        <Link href="/achievements" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                           $page.component?.includes('Achievement') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
          </svg>
          <span class="font-medium">Achievements</span>
        </Link>

        <!-- Students - Admin only -->
        <Link v-if="$page.props.auth?.user?.role === 'admin'" href="/students" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                        $page.component?.includes('Student') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
          </svg>
          <span class="font-medium">Students</span>
          <span class="ml-auto text-xs bg-indigo-100 text-indigo-700 px-2 py-1 rounded-full">{{ stats?.total_students || 0 }}</span>
        </Link>

        <!-- Faculty - Admin only -->
        <Link v-if="$page.props.auth?.user?.role === 'admin'" href="/teachers" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                        $page.component?.includes('Teacher') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
          </svg>
          <span class="font-medium">Faculty</span>
          <span class="ml-auto text-xs bg-green-100 text-green-700 px-2 py-1 rounded-full">{{ stats?.total_teachers || 0 }}</span>
        </Link>

        <!-- Finance - Admin only for full access, students see limited view -->
        <Link v-if="$page.props.auth?.user?.role === 'admin'" href="/payments" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                    $page.component?.includes('Payment') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
          </svg>
          <span class="font-medium">Finance</span>
        </Link>
        
        <!-- Payments for Students - Limited access to own payments -->
        <Link v-if="$page.props.auth?.user?.role === 'student'" href="/payments/create" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                    $page.component?.includes('Payment') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
          </svg>
          <span class="font-medium">Payments</span>
        </Link>

        <!-- Support - Available to all roles -->
        <Link href="/complaints" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                          $page.component?.includes('Complaint') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192L5.636 18.364M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-5 0a4 4 0 11-8 0 4 4 0 018 0z"></path>
          </svg>
          <span class="font-medium">Support</span>
          <span v-if="$page.props.auth?.user?.role === 'admin'" class="ml-auto text-xs bg-red-100 text-red-700 px-2 py-1 rounded-full">{{ stats?.pending_enrollments || 0 }}</span>
        </Link>

        <!-- Analytics - Admin only -->
        <Link v-if="$page.props.auth?.user?.role === 'admin'" href="/reports" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                       $page.component?.includes('Report') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
          <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
          </svg>
          <span class="font-medium">Analytics</span>
        </Link>

        <!-- Admin-only section -->
        <div v-if="$page.props.auth?.user?.role === 'admin'" class="pt-4 mt-4 border-t border-slate-200">
          <!-- Role Management -->
          <Link href="/admin/roles" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                             $page.component?.includes('Role') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
            <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
            </svg>
            <span class="font-medium">Role Management</span>
          </Link>
          
          <!-- Enrollments -->
          <Link href="/admin/enrollments" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                                   $page.component?.includes('Enrollment') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
            <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
            </svg>
            <span class="font-medium">Enrollments</span>
            <span class="ml-auto text-xs bg-amber-100 text-amber-700 px-2 py-1 rounded-full">{{ stats?.pending_enrollments || 0 }}</span>
          </Link>
          
          <!-- Payment Methods -->
          <Link href="/admin/payment-methods" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                                       $page.component?.includes('PaymentMethod') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
            <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
            </svg>
            <span class="font-medium">Payment Methods</span>
          </Link>
          
          <!-- System Settings -->
          <Link href="/admin/system-settings" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                                        $page.component?.includes('SystemSetting') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
            <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.82 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.82 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.82-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.82-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
            </svg>
            <span class="font-medium">System Settings</span>
          </Link>
          
          <!-- Settings -->
          <Link href="/settings" :class="['flex items-center px-4 py-3 rounded-xl transition-all duration-200 hover:bg-slate-50 hover:text-slate-800', 
                                          $page.component?.includes('Setting') ? 'text-slate-700 bg-indigo-50' : 'text-slate-600']">
            <svg class="h-5 w-5 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.82 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.82 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.82-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.82-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
            </svg>
            <span class="font-medium">Settings</span>
          </Link>
        </div>
      </nav>
    </div>

    <div class="flex-1 flex flex-col">
      <!-- Header -->
      <header class="h-20 bg-white/70 backdrop-blur-xl border-b border-slate-200/50 px-8 flex items-center justify-between relative z-50">
        <div>
          <h1 class="text-2xl font-bold text-slate-800">
            <slot name="header-title">{{ title }}</slot>
          </h1>
          <p class="text-slate-500 text-sm">
            <slot name="header-subtitle">{{ subtitle }}</slot>
          </p>
        </div>

        <div class="flex items-center space-x-4">
          <div class="relative">
            <input type="text" placeholder="Search anything..." class="bg-slate-100/70 backdrop-blur-sm px-4 py-3 pl-10 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white w-80 transition-all duration-200">
            <svg class="absolute left-3 top-3.5 h-4 w-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
            </svg>
          </div>

          <Link href="/notifications" class="relative p-3 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-2xl transition-all duration-200">
            <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0a3 3 0 11-6 0m6 0a3 3 0 00-6 0"></path>
            </svg>
            <span v-if="notificationCount > 0" class="absolute -top-1 -right-1 h-5 w-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center">{{ notificationCount }}</span>
          </Link>

          <div class="relative group">
            <div class="flex items-center space-x-3 pl-4 border-l border-slate-200 cursor-pointer">
              <img :src="$page.props.auth?.user?.profile_photo_url || 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face&facepad=2&bg=white'" 
                   :alt="$page.props.auth?.user?.name" class="h-12 w-12 rounded-2xl ring-2 ring-white shadow-md">
              <div class="text-sm">
                <p class="font-semibold text-slate-800">{{ $page.props.auth?.user?.name }}</p>
                <p class="text-slate-500">{{ $page.props.auth?.user?.role }}</p>
              </div>
              <svg class="w-4 h-4 text-slate-400 transition-transform duration-200 group-hover:rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
              </svg>
            </div>

            <div class="absolute right-0 top-full mt-2 w-56 bg-white/90 backdrop-blur-xl rounded-2xl shadow-xl border border-slate-200/50 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-[9999]">
              <div class="p-2">
                <Link href="/profile" class="flex items-center px-4 py-3 text-slate-700 hover:bg-slate-100/70 rounded-xl transition-colors duration-150">
                  <svg class="w-4 h-4 mr-3 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                  </svg>
                  View Profile
                </Link>
                <Link href="/account-settings" class="flex items-center px-4 py-3 text-slate-700 hover:bg-slate-100/70 rounded-xl transition-colors duration-150">
                  <svg class="w-4 h-4 mr-3 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.82 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.82 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.82-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.82-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                  </svg>
                  Account Settings
                </Link>
                <hr class="my-2 border-slate-200">
                <Link href="/logout" method="post" as="button" class="flex items-center w-full px-4 py-3 text-rose-600 hover:bg-rose-50 rounded-xl transition-colors duration-150">
                  <svg class="w-4 h-4 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                  </svg>
                  Sign Out
                </Link>
              </div>
            </div>
          </div>
        </div>
      </header>

      <!-- Main Content -->
      <main class="flex-1 overflow-y-auto p-8 relative">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
import { ref, onMounted } from 'vue'

defineProps({
  title: {
    type: String,
    default: 'Dashboard'
  },
  subtitle: {
    type: String,
    default: 'Welcome to your dashboard'
  },
  stats: {
    type: Object,
    default: () => ({})
  }
})

const notificationCount = ref(0)

// Fetch notification count
const fetchNotificationCount = async () => {
  try {
    const response = await fetch('/api/notifications/count')
    const data = await response.json()
    notificationCount.value = data.count
  } catch (error) {
    console.error('Failed to fetch notification count:', error)
  }
}

// Initialize notification count on mount
onMounted(() => {
  fetchNotificationCount()
})
</script>