<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({
    auth: Object,
    resources: Object,
    subjects: Array,
    years: Array,
    grades: [Array, Object],
    stats: Object,
    filters: Object,
});

const user = props.auth?.user || { name: 'Guest', role: 'guest' };

// Filter states
const searchQuery = ref(props.filters.search || '');
const selectedType = ref(props.filters.type || 'all');
const selectedSubject = ref(props.filters.subject || '');
const selectedGrade = ref(props.filters.grade || '');
const selectedYear = ref(props.filters.year || '');

// Normalize grades to always be an array
const normalizedGrades = computed(() => {
    if (Array.isArray(props.grades)) {
        return props.grades;
    } else if (props.grades && typeof props.grades === 'object') {
        return Object.values(props.grades);
    } else {
        return [];
    }
});

// Search and filter functions
const applyFilters = () => {
    const params = {};
    
    if (searchQuery.value) params.search = searchQuery.value;
    if (selectedType.value !== 'all') params.type = selectedType.value;
    if (selectedSubject.value) params.subject = selectedSubject.value;
    if (selectedGrade.value) params.grade = selectedGrade.value;
    if (selectedYear.value) params.year = selectedYear.value;
    
    router.get(route('library.index'), params, {
        preserveState: true,
        preserveScroll: true
    });
};

const resetFilters = () => {
    searchQuery.value = '';
    selectedType.value = 'all';
    selectedSubject.value = '';
    selectedGrade.value = '';
    selectedYear.value = '';
    
    router.get(route('library.index'));
};

// Resource type icons and colors
const getTypeIcon = (type) => {
    const icons = {
        book: 'M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197',
        past_paper: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z',
        document: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z',
        video: 'M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z',
        audio: 'M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M9 17a1 1 0 01-1-1V8a1 1 0 011-1h1.5a1 1 0 01.707.293L13 9h3a1 1 0 011 1v6a1 1 0 01-1 1h-3l-1.793 1.793A1 1 0 019 17z'
    };
    return icons[type] || icons.document;
};

const getTypeColor = (type) => {
    const colors = {
        book: 'from-blue-500 to-indigo-600',
        past_paper: 'from-green-500 to-emerald-600',
        document: 'from-purple-500 to-violet-600',
        video: 'from-red-500 to-rose-600',
        audio: 'from-yellow-500 to-orange-600'
    };
    return colors[type] || colors.document;
};

const formatFileSize = (bytes) => {
    if (!bytes) return 'Unknown';
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(1024));
    return Math.round(bytes / Math.pow(1024, i) * 100) / 100 + ' ' + sizes[i];
};
</script>

<template>
    <Head title="Digital Library" />
    
    <DashboardLayout title="Digital Library" subtitle="Access books, past papers, and educational resources" :stats="stats">
        <div class="space-y-6">
            <!-- Stats Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">Total Resources</p>
                            <p class="text-3xl font-bold text-slate-900">{{ stats.total_resources.toLocaleString() }}</p>
                        </div>
                        <div class="w-12 h-12 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-2xl flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 9a2 2 0 00-2 2v2m0 0V9a2 2 0 012-2m0 2a2 2 0 012-2h4a2 2 0 012 2m0 2v10"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <Link :href="route('library.books')" class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50 hover:shadow-2xl transition-all duration-300 group">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">Books</p>
                            <p class="text-3xl font-bold text-slate-900">{{ stats.books.toLocaleString() }}</p>
                        </div>
                        <div class="w-12 h-12 bg-gradient-to-r from-blue-500 to-indigo-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197"></path>
                            </svg>
                        </div>
                    </div>
                </Link>

                <Link :href="route('library.pastPapers')" class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50 hover:shadow-2xl transition-all duration-300 group">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">Past Papers</p>
                            <p class="text-3xl font-bold text-slate-900">{{ stats.past_papers.toLocaleString() }}</p>
                        </div>
                        <div class="w-12 h-12 bg-gradient-to-r from-green-500 to-emerald-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                            </svg>
                        </div>
                    </div>
                </Link>

                <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-slate-600">Documents</p>
                            <p class="text-3xl font-bold text-slate-900">{{ stats.documents.toLocaleString() }}</p>
                        </div>
                        <div class="w-12 h-12 bg-gradient-to-r from-purple-500 to-violet-600 rounded-2xl flex items-center justify-center">
                            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                            </svg>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search and Filters -->
            <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50">
                <div class="flex flex-col lg:flex-row gap-4 items-center justify-between">
                    <!-- Search -->
                    <div class="flex-1 max-w-md">
                        <div class="relative">
                            <input 
                                v-model="searchQuery" 
                                @input="applyFilters"
                                type="text" 
                                placeholder="Search resources..." 
                                class="w-full bg-slate-100/70 backdrop-blur-sm px-4 py-3 pl-10 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200"
                            >
                            <svg class="absolute left-3 top-3.5 h-4 w-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- Filters -->
                    <div class="flex flex-wrap gap-3">
                        <select v-model="selectedType" @change="applyFilters" class="bg-slate-100/70 px-4 py-2 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400">
                            <option value="all">All Types</option>
                            <option value="book">Books</option>
                            <option value="past_paper">Past Papers</option>
                            <option value="document">Documents</option>
                            <option value="video">Videos</option>
                            <option value="audio">Audio</option>
                        </select>

                        <select v-model="selectedSubject" @change="applyFilters" class="bg-slate-100/70 px-4 py-2 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400">
                            <option value="">All Subjects</option>
                            <option v-for="subject in subjects" :key="subject.id" :value="subject.id">{{ subject.name }}</option>
                        </select>

                        <select v-model="selectedGrade" @change="applyFilters" class="bg-slate-100/70 px-4 py-2 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400">
                            <option value="">All Grades</option>
                            <option v-for="grade in normalizedGrades" :key="grade" :value="grade">{{ grade }}</option>
                        </select>

                        <select v-model="selectedYear" @change="applyFilters" class="bg-slate-100/70 px-4 py-2 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400">
                            <option value="">All Years</option>
                            <option v-for="year in years" :key="year" :value="year">{{ year }}</option>
                        </select>

                        <button @click="resetFilters" class="px-4 py-2 text-slate-600 hover:text-slate-800 hover:bg-slate-100 rounded-2xl transition-colors duration-200">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
                            </svg>
                        </button>
                        
                        <!-- Admin Link -->
                        <Link 
                            v-if="user.role === 'admin'" 
                            :href="route('admin.library.index')"
                            class="px-4 py-2 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-2xl text-sm font-medium hover:from-blue-600 hover:to-blue-700 transition-all duration-200 shadow-md hover:shadow-lg transform hover:-translate-y-0.5 flex items-center gap-2"
                        >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            </svg>
                            Manage
                        </Link>
                    </div>
                </div>
            </div>

            <!-- Resources Grid -->
            <div class="bg-white/80 backdrop-blur-sm rounded-3xl shadow-xl border border-slate-200/50 overflow-hidden">
                <div class="p-6 border-b border-slate-200/50">
                    <h2 class="text-xl font-bold text-slate-800">Resources</h2>
                    <p class="text-slate-600 text-sm">{{ resources?.total || 0 }} resources found</p>
                </div>

                <div v-if="(resources?.data?.length || 0) > 0" class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                        <Link 
                            v-for="resource in (resources?.data || [])" 
                            :key="resource.id"
                            :href="route('library.show', resource.id)"
                            class="bg-white rounded-2xl shadow-lg border border-slate-200/50 overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 group"
                        >
                            <!-- Resource Type Icon -->
                            <div :class="['h-32 bg-gradient-to-br', getTypeColor(resource.type), 'flex items-center justify-center relative overflow-hidden']">
                                <svg class="w-16 h-16 text-white/80" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" :d="getTypeIcon(resource.type)"></path>
                                </svg>
                                <div class="absolute top-2 right-2 bg-black/20 backdrop-blur-sm px-2 py-1 rounded-full">
                                    <span class="text-xs font-medium text-white capitalize">{{ resource.type.replace('_', ' ') }}</span>
                                </div>
                            </div>

                            <div class="p-4">
                                <h3 class="font-semibold text-slate-800 mb-2 line-clamp-2 group-hover:text-indigo-600 transition-colors duration-200">
                                    {{ resource.title }}
                                </h3>
                                
                                <div class="space-y-2 text-sm text-slate-600">
                                    <div v-if="resource.subject" class="flex items-center">
                                        <span class="inline-flex items-center px-2 py-1 text-xs font-medium bg-indigo-100 text-indigo-700 rounded-full">
                                            {{ resource.subject.name }}
                                        </span>
                                    </div>
                                    
                                    <div class="flex items-center justify-between">
                                        <span v-if="resource.grade_level">Grade {{ resource.grade_level }}</span>
                                        <span v-if="resource.year">{{ resource.year }}</span>
                                    </div>
                                    
                                    <div class="flex items-center justify-between">
                                        <span class="text-xs text-slate-500">{{ formatFileSize(resource.file_size) }}</span>
                                        <span class="text-xs text-slate-500">{{ resource.view_count }} views</span>
                                    </div>
                                </div>

                                <!-- Protection Indicator -->
                                <div v-if="resource.is_protected" class="mt-3 flex items-center text-xs text-green-600">
                                    <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"></path>
                                    </svg>
                                    Protected Content
                                </div>
                            </div>
                        </Link>
                    </div>

                    <!-- Pagination -->
                    <div v-if="resources?.links && resources.links.length > 3" class="mt-8 flex justify-center">
                        <div class="flex space-x-2">
                            <template v-for="(link, index) in (resources?.links || [])" :key="`link-${index}`">
                                <Link 
                                    v-if="link?.url"
                                    :href="link.url"
                                    :class="[
                                        'px-4 py-2 text-sm rounded-lg transition-colors duration-200',
                                        link.active ? 'bg-indigo-500 text-white' : 'text-slate-600 hover:bg-slate-100'
                                    ]"
                                    v-html="link.label"
                                />
                                <span
                                    v-else
                                    :class="[
                                        'px-4 py-2 text-sm rounded-lg transition-colors duration-200 cursor-not-allowed',
                                        'text-slate-400 bg-slate-100'
                                    ]"
                                    v-html="link?.label || ''"
                                />
                            </template>
                        </div>
                    </div>
                </div>

                <!-- Empty State -->
                <div v-else class="p-12 text-center">
                    <div class="w-16 h-16 bg-gradient-to-br from-slate-100 to-slate-200 rounded-2xl flex items-center justify-center mx-auto mb-4">
                        <svg class="w-8 h-8 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 9a2 2 0 00-2 2v2m0 0V9a2 2 0 012-2m0 2a2 2 0 012-2h4a2 2 0 012 2m0 2v10"></path>
                        </svg>
                    </div>
                    <h3 class="text-lg font-semibold text-slate-800 mb-2">No resources found</h3>
                    <p class="text-slate-500 mb-6">Try adjusting your search criteria or filters.</p>
                    <button @click="resetFilters" class="px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                        Reset Filters
                    </button>
                </div>
            </div>
        </div>
    </DashboardLayout>
</template>