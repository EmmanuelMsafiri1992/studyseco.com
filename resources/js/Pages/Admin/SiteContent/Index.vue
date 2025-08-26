<script setup>
import { ref } from 'vue';
import { useForm, Head } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';

const props = defineProps({
    contents: Array,
    studentStories: Array,
});

// Content Management
const showContentModal = ref(false);
const showStoryModal = ref(false);
const editingContent = ref(null);
const editingStory = ref(null);

const contentForm = useForm({
    key: '',
    title: '',
    content: '',
    meta_data: {},
    is_active: true,
});

const storyForm = useForm({
    name: '',
    location: '',
    country_flag: '🇲🇼',
    current_status: '',
    story: '',
    achievements: [],
    msce_credits: '',
    avatar_color_from: 'emerald-500',
    avatar_color_to: 'blue-500',
    achievement_icon: '🎓',
    is_featured: true,
    is_active: true,
});

// Content methods
const openContentModal = (content = null) => {
    editingContent.value = content;
    if (content) {
        contentForm.key = content.key;
        contentForm.title = content.title;
        contentForm.content = content.content;
        contentForm.meta_data = content.meta_data || {};
        contentForm.is_active = content.is_active;
    } else {
        contentForm.reset();
    }
    showContentModal.value = true;
};

const saveContent = () => {
    if (editingContent.value) {
        contentForm.put(route('admin.site-content.contents.update', editingContent.value.id), {
            onSuccess: () => {
                showContentModal.value = false;
                editingContent.value = null;
            }
        });
    } else {
        contentForm.post(route('admin.site-content.contents.store'), {
            onSuccess: () => {
                showContentModal.value = false;
            }
        });
    }
};

const deleteContent = (content) => {
    if (confirm('Are you sure you want to delete this content?')) {
        useForm().delete(route('admin.site-content.contents.destroy', content.id));
    }
};

// Story methods
const openStoryModal = (story = null) => {
    editingStory.value = story;
    if (story) {
        storyForm.name = story.name;
        storyForm.location = story.location;
        storyForm.country_flag = story.country_flag;
        storyForm.current_status = story.current_status;
        storyForm.story = story.story;
        storyForm.achievements = story.achievements || [];
        storyForm.msce_credits = story.msce_credits || '';
        storyForm.avatar_color_from = story.avatar_color_from;
        storyForm.avatar_color_to = story.avatar_color_to;
        storyForm.achievement_icon = story.achievement_icon;
        storyForm.is_featured = story.is_featured;
        storyForm.is_active = story.is_active;
    } else {
        storyForm.reset();
        storyForm.country_flag = '🇲🇼';
        storyForm.avatar_color_from = 'emerald-500';
        storyForm.avatar_color_to = 'blue-500';
        storyForm.achievement_icon = '🎓';
        storyForm.is_featured = true;
        storyForm.is_active = true;
    }
    showStoryModal.value = true;
};

const saveStory = () => {
    if (editingStory.value) {
        storyForm.put(route('admin.site-content.student-stories.update', editingStory.value.id), {
            onSuccess: () => {
                showStoryModal.value = false;
                editingStory.value = null;
            }
        });
    } else {
        storyForm.post(route('admin.site-content.student-stories.store'), {
            onSuccess: () => {
                showStoryModal.value = false;
            }
        });
    }
};

const deleteStory = (story) => {
    if (confirm('Are you sure you want to delete this student story?')) {
        useForm().delete(route('admin.site-content.student-stories.destroy', story.id));
    }
};

const colorOptions = [
    { label: 'Emerald to Blue', from: 'emerald-500', to: 'blue-500' },
    { label: 'Blue to Purple', from: 'blue-500', to: 'purple-500' },
    { label: 'Purple to Pink', from: 'purple-500', to: 'pink-500' },
    { label: 'Orange to Red', from: 'orange-500', to: 'red-500' },
    { label: 'Green to Teal', from: 'green-500', to: 'teal-500' },
    { label: 'Indigo to Blue', from: 'indigo-500', to: 'blue-500' },
];

const achievementIcons = ['🎓', '🏆', '⭐', '💼', '🌟', '🎯', '🚀', '💡'];
</script>

<template>
    <Head title="Site Content Management" />

    <AdminLayout>
        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 bg-white border-b border-gray-200">
                        <h2 class="text-2xl font-bold text-gray-900 mb-6">Site Content Management</h2>

                        <!-- Site Content Section -->
                        <div class="mb-12">
                            <div class="flex justify-between items-center mb-6">
                                <h3 class="text-lg font-semibold text-gray-800">Website Content</h3>
                                <button @click="openContentModal()" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors">
                                    Add New Content
                                </button>
                            </div>

                            <div class="overflow-x-auto">
                                <table class="min-w-full table-auto">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Key</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Title</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <tr v-for="content in contents" :key="content.id">
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ content.key }}</td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ content.title }}</td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span :class="content.is_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" 
                                                      class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full">
                                                    {{ content.is_active ? 'Active' : 'Inactive' }}
                                                </span>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                                                <button @click="openContentModal(content)" class="text-blue-600 hover:text-blue-900">Edit</button>
                                                <button @click="deleteContent(content)" class="text-red-600 hover:text-red-900">Delete</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Student Stories Section -->
                        <div>
                            <div class="flex justify-between items-center mb-6">
                                <h3 class="text-lg font-semibold text-gray-800">Student Success Stories</h3>
                                <button @click="openStoryModal()" class="bg-emerald-600 text-white px-4 py-2 rounded-md hover:bg-emerald-700 transition-colors">
                                    Add New Story
                                </button>
                            </div>

                            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                                <div v-for="story in studentStories" :key="story.id" class="bg-gray-50 rounded-lg p-6 border">
                                    <div class="flex items-center mb-4">
                                        <div :class="`bg-gradient-to-r from-${story.avatar_color_from} to-${story.avatar_color_to}`" 
                                             class="w-12 h-12 rounded-full flex items-center justify-center text-white font-bold mr-4">
                                            {{ story.name.split(' ').map(n => n[0]).join('').slice(0, 2) }}
                                        </div>
                                        <div>
                                            <h4 class="font-semibold text-gray-900">{{ story.name }}</h4>
                                            <p class="text-sm text-gray-600">{{ story.country_flag }} {{ story.location }}</p>
                                        </div>
                                    </div>
                                    <p class="text-sm text-gray-700 mb-4">{{ story.story.substring(0, 100) }}...</p>
                                    <div class="flex justify-between items-center">
                                        <div class="flex items-center space-x-2">
                                            <span :class="story.is_featured ? 'bg-yellow-100 text-yellow-800' : 'bg-gray-100 text-gray-800'" 
                                                  class="px-2 py-1 text-xs rounded-full">
                                                {{ story.is_featured ? 'Featured' : 'Regular' }}
                                            </span>
                                            <span :class="story.is_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" 
                                                  class="px-2 py-1 text-xs rounded-full">
                                                {{ story.is_active ? 'Active' : 'Inactive' }}
                                            </span>
                                        </div>
                                        <div class="space-x-2">
                                            <button @click="openStoryModal(story)" class="text-blue-600 hover:text-blue-900 text-sm">Edit</button>
                                            <button @click="deleteStory(story)" class="text-red-600 hover:text-red-900 text-sm">Delete</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content Modal -->
        <div v-if="showContentModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-lg p-6 w-full max-w-2xl mx-4">
                <h3 class="text-lg font-semibold mb-4">{{ editingContent ? 'Edit Content' : 'Add New Content' }}</h3>
                
                <form @submit.prevent="saveContent" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Content Key</label>
                        <input v-model="contentForm.key" type="text" required 
                               class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <p class="text-xs text-gray-500 mt-1">Unique identifier for this content (e.g., hero_title, about_text)</p>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Title</label>
                        <input v-model="contentForm.title" type="text" required 
                               class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Content</label>
                        <textarea v-model="contentForm.content" required rows="6"
                                  class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                    </div>
                    
                    <div class="flex items-center">
                        <input v-model="contentForm.is_active" type="checkbox" id="content_active" class="mr-2">
                        <label for="content_active" class="text-sm text-gray-700">Active</label>
                    </div>
                    
                    <div class="flex justify-end space-x-4">
                        <button type="button" @click="showContentModal = false" 
                                class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50">
                            Cancel
                        </button>
                        <button type="submit" :disabled="contentForm.processing"
                                class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50">
                            {{ contentForm.processing ? 'Saving...' : 'Save' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Story Modal -->
        <div v-if="showStoryModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div class="bg-white rounded-lg p-6 w-full max-w-4xl mx-4 max-h-[90vh] overflow-y-auto">
                <h3 class="text-lg font-semibold mb-4">{{ editingStory ? 'Edit Student Story' : 'Add New Student Story' }}</h3>
                
                <form @submit.prevent="saveStory" class="space-y-4">
                    <div class="grid md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Student Name</label>
                            <input v-model="storyForm.name" type="text" required 
                                   class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500">
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Location</label>
                            <input v-model="storyForm.location" type="text" required 
                                   class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500">
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Country Flag</label>
                            <input v-model="storyForm.country_flag" type="text" required 
                                   class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500">
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">MSCE Credits</label>
                            <input v-model="storyForm.msce_credits" type="number" min="0" max="10"
                                   class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500">
                        </div>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Current Status</label>
                        <input v-model="storyForm.current_status" type="text" required 
                               class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500">
                        <p class="text-xs text-gray-500 mt-1">e.g., "University of Edinburgh - Engineering"</p>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Student Story</label>
                        <textarea v-model="storyForm.story" required rows="4"
                                  class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500"></textarea>
                    </div>
                    
                    <div class="grid md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Avatar Colors</label>
                            <select v-model="storyForm.avatar_color_from" 
                                    @change="storyForm.avatar_color_to = colorOptions.find(c => c.from === storyForm.avatar_color_from)?.to || 'blue-500'"
                                    class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500">
                                <option v-for="color in colorOptions" :key="color.from" :value="color.from">{{ color.label }}</option>
                            </select>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Achievement Icon</label>
                            <select v-model="storyForm.achievement_icon" 
                                    class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500">
                                <option v-for="icon in achievementIcons" :key="icon" :value="icon">{{ icon }}</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="flex items-center space-x-6">
                        <div class="flex items-center">
                            <input v-model="storyForm.is_featured" type="checkbox" id="story_featured" class="mr-2">
                            <label for="story_featured" class="text-sm text-gray-700">Featured Story</label>
                        </div>
                        
                        <div class="flex items-center">
                            <input v-model="storyForm.is_active" type="checkbox" id="story_active" class="mr-2">
                            <label for="story_active" class="text-sm text-gray-700">Active</label>
                        </div>
                    </div>
                    
                    <div class="flex justify-end space-x-4">
                        <button type="button" @click="showStoryModal = false" 
                                class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50">
                            Cancel
                        </button>
                        <button type="submit" :disabled="storyForm.processing"
                                class="px-4 py-2 bg-emerald-600 text-white rounded-md hover:bg-emerald-700 disabled:opacity-50">
                            {{ storyForm.processing ? 'Saving...' : 'Save' }}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AdminLayout>
</template>