<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import DashboardLayout from '@/Layouts/DashboardLayout.vue';

const props = defineProps({
    auth: Object,
    hasPendingPayment: Boolean,
    paymentMethods: Array,
    accessDurations: Array,
});

const user = props.auth?.user || { name: 'Guest', role: 'guest', profile_photo_url: null };

const form = useForm({
    payment_method: '',
    amount: '',
    reference_number: '',
    proof_screenshot: null,
    access_duration_id: null,
});

const screenshotInput = ref(null);
const screenshotPreview = ref(null);
const showProcessing = ref(false);

const selectedAccessOption = computed(() => {
    return props.accessDurations.find(option => option.id === form.access_duration_id);
});

const getPaymentInstructions = (method) => {
    const instructions = [];
    
    if (method.instructions) {
        instructions.push(method.instructions);
    }
    
    if (method.account_details) {
        instructions.push(method.account_details);
    }
    
    // Add step to take screenshot as evidence
    instructions.push('Take a screenshot of your payment confirmation as proof');
    
    return instructions.length > 0 ? instructions : ['Complete payment using this method', 'Upload proof of payment'];
};

const filteredPaymentMethods = computed(() => {
    // Filter payment methods based on user location/country
    if (user.country === 'South Africa' || user.country === 'ZA') {
        // South African users should see South African and international methods
        return props.paymentMethods.filter(method => 
            method.region === 'south_africa' || method.region === 'international'
        );
    } else if (user.country === 'Malawi' || user.country === 'MW') {
        // Malawian users should see Malawian and international methods
        return props.paymentMethods.filter(method => 
            method.region === 'malawi' || method.region === 'international'
        );
    }
    
    // Default to all methods if country is not specified or unknown
    return props.paymentMethods;
});

const getSelectedMethod = computed(() => {
    return filteredPaymentMethods.value.find(method => method.code === form.payment_method);
});

const selectScreenshot = () => {
    screenshotInput.value.click();
};

const updateScreenshotPreview = () => {
    const screenshot = screenshotInput.value.files[0];
    
    if (!screenshot) return;
    
    const reader = new FileReader();
    
    reader.onload = (e) => {
        screenshotPreview.value = e.target.result;
    };
    
    reader.readAsDataURL(screenshot);
    form.proof_screenshot = screenshot;
};

const submit = () => {
    // Show processing animation
    showProcessing.value = true;
    
    // Simulate processing time for better UX
    setTimeout(() => {
        form.post(route('payments.store'), {
            onSuccess: () => {
                showProcessing.value = false;
            },
            onError: (errors) => {
                console.error('Payment errors:', errors);
                showProcessing.value = false;
            }
        });
    }, 2000);
};

const setAccessDuration = (duration) => {
    form.access_duration_id = duration.id;
    form.amount = duration.price.toString();
};
</script>

<template>
    <Head title="Submit Payment" />
    
    <DashboardLayout title="Submit Payment" subtitle="Make payment for system access">
        <!-- Processing Overlay -->
        <div v-if="showProcessing" class="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center z-50">
            <div class="bg-white/90 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-slate-200/50 max-w-md w-full mx-4 text-center">
                <div class="w-16 h-16 border-4 border-indigo-200 border-t-indigo-600 rounded-full animate-spin mx-auto mb-4"></div>
                <h3 class="text-xl font-bold text-slate-800 mb-2">Processing Payment...</h3>
                <p class="text-slate-600">Please wait while we process your payment submission.</p>
            </div>
        </div>

        <div class="max-w-4xl mx-auto">
            <!-- Pending Payment Warning -->
            <div v-if="hasPendingPayment" class="mb-6 p-6 bg-amber-50 border border-amber-200 rounded-2xl">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 bg-amber-100 rounded-full flex items-center justify-center">
                        <svg class="w-6 h-6 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-semibold text-amber-800">Payment Under Review</h3>
                        <p class="text-sm text-amber-700">You have a payment awaiting verification. Please check your payment history for updates.</p>
                    </div>
                </div>
            </div>

            <!-- Ultra Compact Single Card Layout -->
            <div class="bg-white/90 backdrop-blur-sm rounded-2xl p-4 shadow-lg border border-slate-200/50 max-w-5xl mx-auto">
                <!-- Header -->
                <div class="flex items-center justify-between mb-4">
                    <h1 class="text-xl font-bold text-slate-800">Make Payment</h1>
                    <Link :href="route('payments.index')" 
                          class="text-sm px-3 py-1 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg transition-all duration-200">
                        Payment History
                    </Link>
                </div>

                <!-- Main Form in 2 Rows -->
                <div class="space-y-4">
                    <!-- First Row: Duration, Method, Amount -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <!-- Access Duration -->
                        <div>
                            <h3 class="text-sm font-semibold text-slate-700 mb-2">📅 Access Duration</h3>
                            <div class="space-y-1">
                                <div v-for="duration in accessDurations" :key="duration.id"
                                     @click="setAccessDuration(duration)"
                                     :class="[
                                         'p-2 rounded-lg border cursor-pointer transition-all text-sm',
                                         form.access_duration_id === duration.id 
                                            ? 'border-indigo-500 bg-indigo-50' 
                                            : 'border-slate-200 hover:border-slate-300'
                                     ]">
                                    <div class="flex justify-between items-center">
                                        <span class="font-medium text-slate-800">{{ duration.name }}</span>
                                        <span class="font-bold text-indigo-600">{{ duration.formatted_price }}</span>
                                    </div>
                                </div>
                            </div>
                            <div v-if="form.errors.access_duration_id" class="mt-1 text-xs text-red-600">{{ form.errors.access_duration_id }}</div>
                        </div>

                        <!-- Payment Method -->
                        <div>
                            <h3 class="text-sm font-semibold text-slate-700 mb-2">💳 Payment Method</h3>
                            <div class="space-y-1">
                                <div v-for="method in filteredPaymentMethods" :key="method.code"
                                     @click.prevent="form.payment_method = method.code"
                                     :class="[
                                         'p-2 rounded-lg border cursor-pointer transition-all flex items-center space-x-2 text-sm',
                                         form.payment_method === method.code 
                                            ? 'border-indigo-500 bg-indigo-50' 
                                            : 'border-slate-200 hover:border-slate-300'
                                     ]">
                                    <div :class="[
                                        'w-6 h-6 rounded flex items-center justify-center text-white text-xs',
                                        method.color || 'bg-indigo-500'
                                    ]">
                                        {{ method.icon || '💳' }}
                                    </div>
                                    <span class="font-medium text-slate-800 flex-1">{{ method.name }}</span>
                                    <div v-if="form.payment_method === method.code" class="w-3 h-3 bg-indigo-500 rounded-full"></div>
                                </div>
                            </div>
                            <div v-if="form.errors.payment_method" class="mt-1 text-xs text-red-600">{{ form.errors.payment_method }}</div>
                        </div>

                        <!-- Payment Details -->
                        <div>
                            <h3 class="text-sm font-semibold text-slate-700 mb-2">📝 Payment Details</h3>
                            <div class="space-y-2">
                                <div>
                                    <input v-model="form.amount" type="text" readonly placeholder="Amount"
                                           class="w-full bg-slate-100 px-3 py-2 rounded-lg text-sm font-semibold border-0">
                                </div>
                                <div>
                                    <input v-model="form.reference_number" type="text" placeholder="Reference Number"
                                           class="w-full bg-white px-3 py-2 rounded-lg text-sm border border-slate-200 focus:outline-none focus:ring-1 focus:ring-indigo-400">
                                </div>
                                <div class="border border-slate-300 rounded-lg p-2 text-center">
                                    <div v-if="screenshotPreview" class="mb-1">
                                        <img :src="screenshotPreview" alt="Preview" class="w-12 h-12 object-cover rounded mx-auto">
                                    </div>
                                    <button type="button" @click.prevent="selectScreenshot" 
                                            class="text-xs px-3 py-1 bg-indigo-100 hover:bg-indigo-200 text-indigo-700 rounded transition-colors">
                                        {{ screenshotPreview ? 'Change Proof' : 'Upload Proof' }}
                                    </button>
                                    <input ref="screenshotInput" type="file" class="hidden" @change="updateScreenshotPreview" accept="image/*">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Second Row: Instructions & Submit -->
                    <div v-if="getSelectedMethod" class="bg-slate-50/50 rounded-lg p-3">
                        <div class="flex items-center justify-between">
                            <div class="flex-1">
                                <h4 class="text-sm font-semibold text-slate-800 mb-1">{{ getSelectedMethod.name }} Instructions</h4>
                                <div class="text-xs text-slate-600 space-y-1">
                                    <div v-for="(instruction, index) in getPaymentInstructions(getSelectedMethod)" :key="index" class="flex items-start space-x-1">
                                        <span class="w-4 h-4 bg-indigo-500 text-white rounded-full flex items-center justify-center text-xs font-bold mt-0.5 flex-shrink-0">{{ index + 1 }}</span>
                                        <span>{{ instruction }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="flex gap-2 ml-4">
                                <Link :href="route('payments.index')" 
                                      class="px-4 py-2 bg-slate-200 hover:bg-slate-300 text-slate-700 rounded-lg text-sm transition-all duration-200">
                                    Cancel
                                </Link>
                                <button type="button"
                                        @click.prevent="submit"
                                        :disabled="form.processing || !form.payment_method || !form.access_duration_id || hasPendingPayment"
                                        class="px-6 py-2 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-lg text-sm hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed">
                                    <span v-if="form.processing">Submitting...</span>
                                    <span v-else>Submit Payment</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </DashboardLayout>
</template>