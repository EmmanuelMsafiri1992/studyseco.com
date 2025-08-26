<template>
    <AdminLayout>
        <Head title="Payment Settings" />

        <div class="py-6">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="mb-6">
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
                        Payment Settings
                    </h1>
                    <p class="mt-1 text-gray-600 dark:text-gray-400">
                        Manage payment methods and access duration options
                    </p>
                </div>

                <!-- Payment Methods Section -->
                <div class="mb-8">
                    <div class="bg-white dark:bg-gray-800 shadow rounded-lg">
                        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
                            <h2 class="text-lg font-medium text-gray-900 dark:text-white">
                                Payment Methods
                            </h2>
                            <button @click="showAddMethodModal = true" 
                                    class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md text-sm font-medium">
                                Add Payment Method
                            </button>
                        </div>
                        <div class="p-6">
                            <div v-if="paymentMethods.length === 0" class="text-center py-8 text-gray-500">
                                No payment methods configured yet.
                            </div>
                            <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                <div v-for="method in paymentMethods" :key="method.id"
                                     class="border border-gray-200 dark:border-gray-700 rounded-lg p-4">
                                    <div class="flex justify-between items-start mb-2">
                                        <div class="flex items-center">
                                            <span class="text-2xl mr-2">{{ method.icon }}</span>
                                            <h3 class="font-medium text-gray-900 dark:text-white">
                                                {{ method.name }}
                                            </h3>
                                        </div>
                                        <span :class="method.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'"
                                              class="px-2 py-1 rounded-full text-xs font-medium">
                                            {{ method.is_active ? 'Active' : 'Inactive' }}
                                        </span>
                                    </div>
                                    <div class="text-sm text-gray-600 dark:text-gray-400 mb-3">
                                        <div v-if="method.type === 'mobile_money'">
                                            <p><strong>Phone:</strong> {{ method.formatted_config.phone_number || 'Not set' }}</p>
                                            <p><strong>Merchant Code:</strong> {{ method.formatted_config.merchant_code || 'Not set' }}</p>
                                        </div>
                                        <div v-else-if="method.type === 'bank_transfer'">
                                            <p><strong>Bank:</strong> {{ method.formatted_config.bank_name || 'Not set' }}</p>
                                            <p><strong>Account:</strong> {{ method.formatted_config.account_number || 'Not set' }}</p>
                                        </div>
                                    </div>
                                    <div class="flex justify-end space-x-2">
                                        <button @click="editMethod(method)"
                                                class="text-blue-600 hover:text-blue-800 text-sm">
                                            Edit
                                        </button>
                                        <button @click="deleteMethod(method)"
                                                class="text-red-600 hover:text-red-800 text-sm">
                                            Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Access Durations Section -->
                <div>
                    <div class="bg-white dark:bg-gray-800 shadow rounded-lg">
                        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700 flex justify-between items-center">
                            <h2 class="text-lg font-medium text-gray-900 dark:text-white">
                                Access Duration Options
                            </h2>
                            <button @click="showAddDurationModal = true"
                                    class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-md text-sm font-medium">
                                Add Duration Option
                            </button>
                        </div>
                        <div class="p-6">
                            <div v-if="accessDurations.length === 0" class="text-center py-8 text-gray-500">
                                No access duration options configured yet.
                            </div>
                            <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                <div v-for="duration in accessDurations" :key="duration.id"
                                     class="border border-gray-200 dark:border-gray-700 rounded-lg p-4">
                                    <div class="flex justify-between items-start mb-2">
                                        <h3 class="font-medium text-gray-900 dark:text-white">
                                            {{ duration.name }}
                                        </h3>
                                        <span :class="duration.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'"
                                              class="px-2 py-1 rounded-full text-xs font-medium">
                                            {{ duration.is_active ? 'Active' : 'Inactive' }}
                                        </span>
                                    </div>
                                    <div class="text-sm text-gray-600 dark:text-gray-400 mb-3">
                                        <p><strong>Duration:</strong> {{ duration.duration_display }}</p>
                                        <p><strong>Price:</strong> {{ duration.formatted_price }}</p>
                                        <p v-if="duration.description" class="mt-1">{{ duration.description }}</p>
                                    </div>
                                    <div class="flex justify-end space-x-2">
                                        <button @click="editDuration(duration)"
                                                class="text-blue-600 hover:text-blue-800 text-sm">
                                            Edit
                                        </button>
                                        <button @click="deleteDuration(duration)"
                                                class="text-red-600 hover:text-red-800 text-sm">
                                            Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add/Edit Payment Method Modal -->
        <Modal :show="showMethodModal" @close="closeMethodModal">
            <div class="p-6">
                <h3 class="text-lg font-medium text-gray-900 mb-4">
                    {{ editingMethod ? 'Edit Payment Method' : 'Add Payment Method' }}
                </h3>
                
                <form @submit.prevent="saveMethod" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
                        <input v-model="methodForm.name" type="text" required
                               class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="e.g., TNM Mpamba">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Key</label>
                        <input v-model="methodForm.key" type="text" required
                               class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="e.g., tnm_mpamba">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Type</label>
                        <select v-model="methodForm.type" @change="onTypeChange" required
                                class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="">Select type</option>
                            <option value="mobile_money">Mobile Money</option>
                            <option value="bank_transfer">Bank Transfer</option>
                        </select>
                    </div>

                    <!-- Mobile Money Config -->
                    <div v-if="methodForm.type === 'mobile_money'" class="space-y-3 p-4 bg-blue-50 rounded-md">
                        <h4 class="font-medium text-blue-900">Mobile Money Configuration</h4>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Phone Number</label>
                            <input v-model="methodForm.config.phone_number" type="text"
                                   class="w-full border border-gray-300 rounded-md px-3 py-2"
                                   placeholder="e.g., +265123456789">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Merchant Code (Optional)</label>
                            <input v-model="methodForm.config.merchant_code" type="text"
                                   class="w-full border border-gray-300 rounded-md px-3 py-2"
                                   placeholder="e.g., 12345">
                        </div>
                    </div>

                    <!-- Bank Transfer Config -->
                    <div v-if="methodForm.type === 'bank_transfer'" class="space-y-3 p-4 bg-green-50 rounded-md">
                        <h4 class="font-medium text-green-900">Bank Transfer Configuration</h4>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Bank Name</label>
                            <input v-model="methodForm.config.bank_name" type="text"
                                   class="w-full border border-gray-300 rounded-md px-3 py-2"
                                   placeholder="e.g., National Bank of Malawi">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Account Name</label>
                            <input v-model="methodForm.config.account_name" type="text"
                                   class="w-full border border-gray-300 rounded-md px-3 py-2"
                                   placeholder="e.g., StudySeco School">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Account Number</label>
                            <input v-model="methodForm.config.account_number" type="text"
                                   class="w-full border border-gray-300 rounded-md px-3 py-2"
                                   placeholder="e.g., 1234567890">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Branch (Optional)</label>
                            <input v-model="methodForm.config.branch" type="text"
                                   class="w-full border border-gray-300 rounded-md px-3 py-2"
                                   placeholder="e.g., Blantyre Branch">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Instructions</label>
                        <textarea v-model="methodForm.instructions" rows="3"
                                  class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                                  placeholder="Payment instructions for students"></textarea>
                    </div>

                    <div class="flex items-center">
                        <input v-model="methodForm.is_active" type="checkbox" id="method_active"
                               class="rounded border-gray-300 text-blue-600 focus:ring-blue-500">
                        <label for="method_active" class="ml-2 text-sm text-gray-700">Active</label>
                    </div>

                    <div class="flex justify-end space-x-3 pt-4">
                        <button type="button" @click="closeMethodModal"
                                class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50">
                            Cancel
                        </button>
                        <button type="submit" :disabled="methodProcessing"
                                class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50">
                            {{ methodProcessing ? 'Saving...' : 'Save' }}
                        </button>
                    </div>
                </form>
            </div>
        </Modal>

        <!-- Add/Edit Access Duration Modal -->
        <Modal :show="showDurationModal" @close="closeDurationModal">
            <div class="p-6">
                <h3 class="text-lg font-medium text-gray-900 mb-4">
                    {{ editingDuration ? 'Edit Access Duration' : 'Add Access Duration' }}
                </h3>
                
                <form @submit.prevent="saveDuration" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
                        <input v-model="durationForm.name" type="text" required
                               class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-green-500"
                               placeholder="e.g., 1 Month Access">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                        <input v-model="durationForm.description" type="text"
                               class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-green-500"
                               placeholder="Optional description">
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Duration (Days)</label>
                            <input v-model.number="durationForm.days" type="number" min="1" required
                                   class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-green-500">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Price (MWK)</label>
                            <input v-model.number="durationForm.price" type="number" step="0.01" min="0" required
                                   class="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-green-500">
                        </div>
                    </div>

                    <div class="flex items-center">
                        <input v-model="durationForm.is_active" type="checkbox" id="duration_active"
                               class="rounded border-gray-300 text-green-600 focus:ring-green-500">
                        <label for="duration_active" class="ml-2 text-sm text-gray-700">Active</label>
                    </div>

                    <div class="flex justify-end space-x-3 pt-4">
                        <button type="button" @click="closeDurationModal"
                                class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50">
                            Cancel
                        </button>
                        <button type="submit" :disabled="durationProcessing"
                                class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 disabled:opacity-50">
                            {{ durationProcessing ? 'Saving...' : 'Save' }}
                        </button>
                    </div>
                </form>
            </div>
        </Modal>
    </AdminLayout>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Head, useForm, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import Modal from '@/Components/Modal.vue'

const props = defineProps({
    paymentMethods: Array,
    accessDurations: Array,
})

// Payment Method Modal State
const showMethodModal = ref(false)
const showAddMethodModal = ref(false)
const editingMethod = ref(null)
const methodProcessing = ref(false)

const methodForm = ref({
    name: '',
    key: '',
    type: '',
    instructions: '',
    config: {},
    is_active: true
})

// Access Duration Modal State
const showDurationModal = ref(false)
const showAddDurationModal = ref(false)
const editingDuration = ref(null)
const durationProcessing = ref(false)

const durationForm = ref({
    name: '',
    description: '',
    days: 30,
    price: 0,
    is_active: true
})

// Computed properties
const showAddMethodModal = computed({
    get: () => showMethodModal.value && !editingMethod.value,
    set: (value) => {
        if (value) {
            resetMethodForm()
            showMethodModal.value = true
        }
    }
})

const showAddDurationModal = computed({
    get: () => showDurationModal.value && !editingDuration.value,
    set: (value) => {
        if (value) {
            resetDurationForm()
            showDurationModal.value = true
        }
    }
})

// Payment Method Functions
function resetMethodForm() {
    methodForm.value = {
        name: '',
        key: '',
        type: '',
        instructions: '',
        config: {},
        is_active: true
    }
    editingMethod.value = null
}

function editMethod(method) {
    editingMethod.value = method
    methodForm.value = {
        name: method.name,
        key: method.key,
        type: method.type,
        instructions: method.instructions || '',
        config: { ...method.config },
        is_active: method.is_active
    }
    showMethodModal.value = true
}

function closeMethodModal() {
    showMethodModal.value = false
    setTimeout(resetMethodForm, 200)
}

function onTypeChange() {
    methodForm.value.config = {}
}

function saveMethod() {
    methodProcessing.value = true
    
    const url = editingMethod.value 
        ? route('admin.payment-settings.payment-methods.update', editingMethod.value.id)
        : route('admin.payment-settings.payment-methods.store')
        
    const method = editingMethod.value ? 'put' : 'post'
    
    router[method](url, methodForm.value, {
        onSuccess: () => {
            closeMethodModal()
            methodProcessing.value = false
        },
        onError: () => {
            methodProcessing.value = false
        }
    })
}

function deleteMethod(method) {
    if (confirm(`Are you sure you want to delete "${method.name}"?`)) {
        router.delete(route('admin.payment-settings.payment-methods.destroy', method.id))
    }
}

// Access Duration Functions
function resetDurationForm() {
    durationForm.value = {
        name: '',
        description: '',
        days: 30,
        price: 0,
        is_active: true
    }
    editingDuration.value = null
}

function editDuration(duration) {
    editingDuration.value = duration
    durationForm.value = {
        name: duration.name,
        description: duration.description || '',
        days: duration.days,
        price: parseFloat(duration.price),
        is_active: duration.is_active
    }
    showDurationModal.value = true
}

function closeDurationModal() {
    showDurationModal.value = false
    setTimeout(resetDurationForm, 200)
}

function saveDuration() {
    durationProcessing.value = true
    
    const url = editingDuration.value 
        ? route('admin.payment-settings.access-durations.update', editingDuration.value.id)
        : route('admin.payment-settings.access-durations.store')
        
    const method = editingDuration.value ? 'put' : 'post'
    
    router[method](url, durationForm.value, {
        onSuccess: () => {
            closeDurationModal()
            durationProcessing.value = false
        },
        onError: () => {
            durationProcessing.value = false
        }
    })
}

function deleteDuration(duration) {
    if (confirm(`Are you sure you want to delete "${duration.name}"?`)) {
        router.delete(route('admin.payment-settings.access-durations.destroy', duration.id))
    }
}
</script>