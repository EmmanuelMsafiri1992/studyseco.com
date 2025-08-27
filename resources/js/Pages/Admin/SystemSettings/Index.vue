<template>
    <AuthenticatedLayout>
        <div class="p-6 bg-gray-50 min-h-screen">
            <div class="max-w-7xl mx-auto">
                <div class="mb-6">
                    <h1 class="text-3xl font-bold text-gray-900">System Settings</h1>
                    <p class="text-gray-600">Manage your application's global settings</p>
                </div>

                <form @submit.prevent="updateSettings" class="space-y-6">
                    <!-- General Settings -->
                    <div class="bg-white rounded-lg shadow p-6">
                        <h2 class="text-xl font-semibold text-gray-900 mb-4">General Settings</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6" v-if="settings.general">
                            <div v-for="setting in settings.general" :key="setting.key">
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    {{ setting.name }}
                                </label>
                                <div v-if="setting.type === 'textarea'">
                                    <textarea 
                                        v-model="formData[setting.key]" 
                                        :placeholder="setting.description"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                        rows="3"
                                    ></textarea>
                                </div>
                                <div v-else-if="setting.type === 'color'">
                                    <input 
                                        type="color" 
                                        v-model="formData[setting.key]" 
                                        class="w-full h-10 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    />
                                </div>
                                <div v-else>
                                    <input 
                                        :type="setting.type" 
                                        v-model="formData[setting.key]" 
                                        :placeholder="setting.description"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    />
                                </div>
                                <p class="text-xs text-gray-500 mt-1">{{ setting.description }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Contact Information -->
                    <div class="bg-white rounded-lg shadow p-6">
                        <h2 class="text-xl font-semibold text-gray-900 mb-4">Contact Information</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6" v-if="settings.contact">
                            <div v-for="setting in settings.contact" :key="setting.key">
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    {{ setting.name }}
                                </label>
                                <div v-if="setting.type === 'textarea'">
                                    <textarea 
                                        v-model="formData[setting.key]" 
                                        :placeholder="setting.description"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                        rows="3"
                                    ></textarea>
                                </div>
                                <div v-else>
                                    <input 
                                        :type="setting.type" 
                                        v-model="formData[setting.key]" 
                                        :placeholder="setting.description"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    />
                                </div>
                                <p class="text-xs text-gray-500 mt-1">{{ setting.description }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Appearance -->
                    <div class="bg-white rounded-lg shadow p-6">
                        <h2 class="text-xl font-semibold text-gray-900 mb-4">Appearance</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6" v-if="settings.appearance">
                            <div v-for="setting in settings.appearance" :key="setting.key">
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    {{ setting.name }}
                                </label>
                                <div v-if="setting.type === 'color'">
                                    <input 
                                        type="color" 
                                        v-model="formData[setting.key]" 
                                        class="w-full h-10 rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    />
                                </div>
                                <div v-else>
                                    <input 
                                        :type="setting.type" 
                                        v-model="formData[setting.key]" 
                                        :placeholder="setting.description"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    />
                                </div>
                                <p class="text-xs text-gray-500 mt-1">{{ setting.description }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Footer Settings -->
                    <div class="bg-white rounded-lg shadow p-6">
                        <h2 class="text-xl font-semibold text-gray-900 mb-4">Footer Settings</h2>
                        <div class="space-y-6" v-if="settings.footer">
                            <div v-for="setting in settings.footer" :key="setting.key">
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    {{ setting.name }}
                                </label>
                                <div v-if="setting.type === 'textarea'">
                                    <textarea 
                                        v-model="formData[setting.key]" 
                                        :placeholder="setting.description"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                        rows="3"
                                    ></textarea>
                                </div>
                                <div v-else-if="setting.type === 'json'">
                                    <textarea 
                                        v-model="jsonFields[setting.key]" 
                                        :placeholder="setting.description"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                        rows="4"
                                    ></textarea>
                                    <p class="text-xs text-gray-500 mt-1">JSON format: [{"name": "Link Name", "url": "/path"}]</p>
                                </div>
                                <div v-else>
                                    <input 
                                        :type="setting.type" 
                                        v-model="formData[setting.key]" 
                                        :placeholder="setting.description"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    />
                                </div>
                                <p class="text-xs text-gray-500 mt-1">{{ setting.description }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Academic Settings -->
                    <div class="bg-white rounded-lg shadow p-6">
                        <h2 class="text-xl font-semibold text-gray-900 mb-4">Academic Settings</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6" v-if="settings.academic">
                            <div v-for="setting in settings.academic" :key="setting.key">
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    {{ setting.name }}
                                </label>
                                <div v-if="setting.type === 'json'">
                                    <textarea 
                                        v-model="jsonFields[setting.key]" 
                                        :placeholder="setting.description"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                        rows="3"
                                    ></textarea>
                                    <p class="text-xs text-gray-500 mt-1">JSON format: ["Form 1", "Form 2", ...]</p>
                                </div>
                                <div v-else>
                                    <input 
                                        :type="setting.type" 
                                        v-model="formData[setting.key]" 
                                        :placeholder="setting.description"
                                        class="w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
                                    />
                                </div>
                                <p class="text-xs text-gray-500 mt-1">{{ setting.description }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Save Button -->
                    <div class="flex justify-end">
                        <button 
                            type="submit" 
                            :disabled="processing"
                            class="bg-indigo-600 text-white px-6 py-3 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:opacity-50"
                        >
                            <span v-if="processing">Saving...</span>
                            <span v-else>Save Settings</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { router } from '@inertiajs/vue3';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';

const props = defineProps({
    settings: Object
});

const processing = ref(false);
const formData = ref({});
const jsonFields = ref({});

onMounted(() => {
    // Initialize form data from settings
    Object.keys(props.settings).forEach(group => {
        props.settings[group].forEach(setting => {
            if (setting.type === 'json') {
                jsonFields.value[setting.key] = JSON.stringify(setting.value, null, 2);
            } else {
                formData.value[setting.key] = setting.value;
            }
        });
    });
});

const updateSettings = () => {
    processing.value = true;
    
    // Prepare settings data
    const settingsArray = [];
    
    // Add regular form data
    Object.keys(formData.value).forEach(key => {
        settingsArray.push({
            key: key,
            value: formData.value[key]
        });
    });
    
    // Add JSON fields
    Object.keys(jsonFields.value).forEach(key => {
        try {
            const parsedValue = JSON.parse(jsonFields.value[key]);
            settingsArray.push({
                key: key,
                value: parsedValue
            });
        } catch (e) {
            // If JSON is invalid, keep as string
            settingsArray.push({
                key: key,
                value: jsonFields.value[key]
            });
        }
    });

    router.post('/admin/system-settings', {
        settings: settingsArray
    }, {
        onFinish: () => {
            processing.value = false;
        },
        onSuccess: () => {
            // Show success message
        }
    });
};
</script>