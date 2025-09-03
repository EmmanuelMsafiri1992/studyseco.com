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
    if (!method.instructions) return [];
    
    let instructions = [method.instructions];
    
    if (method.type === 'mobile_money') {
        const config = method.formatted_config;
        if (config.phone_number) {
            instructions.push(`Send money to: ${config.phone_number}`);
        }
        if (config.merchant_code) {
            instructions.push(`Merchant Code: ${config.merchant_code}`);
        }
    } else if (method.type === 'bank_transfer') {
        const config = method.formatted_config;
        if (config.bank_name) {
            instructions.push(`Bank: ${config.bank_name}`);
        }
        if (config.account_name) {
            instructions.push(`Account Name: ${config.account_name}`);
        }
        if (config.account_number) {
            instructions.push(`Account Number: ${config.account_number}`);
        }
        if (config.branch) {
            instructions.push(`Branch: ${config.branch}`);
        }
    }
    
    return instructions;
};

const getSelectedMethod = computed(() => {
    return props.paymentMethods.find(method => method.key === form.payment_method);
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

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <!-- Payment Form -->
                <div class="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                    <h2 class="text-2xl font-bold text-slate-800 mb-6">Payment Details</h2>
                    
                    <form @submit.prevent="submit">
                        <!-- Access Duration Selection -->
                        <div class="mb-6">
                            <label class="block text-sm font-medium text-slate-700 mb-4">Select Access Duration</label>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div v-for="duration in accessDurations" :key="duration.id"
                                     @click="setAccessDuration(duration)"
                                     :class="[
                                         'p-4 rounded-2xl border-2 cursor-pointer transition-all duration-200',
                                         form.access_duration_id === duration.id 
                                            ? 'border-indigo-500 bg-indigo-50' 
                                            : 'border-slate-200 hover:border-slate-300'
                                     ]">
                                    <div class="flex justify-between items-center mb-2">
                                        <h3 class="font-semibold text-slate-800">{{ duration.name }}</h3>
                                        <span class="text-lg font-bold text-indigo-600">{{ duration.formatted_price }}</span>
                                    </div>
                                    <p class="text-sm text-slate-600">{{ duration.description || duration.duration_display }}</p>
                                </div>
                            </div>
                            <div v-if="form.errors.access_duration_id" class="mt-2 text-sm text-red-600">{{ form.errors.access_duration_id }}</div>
                        </div>

                        <!-- Payment Method Selection -->
                        <div class="mb-6">
                            <label class="block text-sm font-medium text-slate-700 mb-4">Payment Method</label>
                            <div class="space-y-3">
                                <div v-for="method in paymentMethods" :key="method.key"
                                     @click="form.payment_method = method.key"
                                     :class="[
                                         'p-4 rounded-2xl border-2 cursor-pointer transition-all duration-200 flex items-center space-x-4',
                                         form.payment_method === method.key 
                                            ? 'border-indigo-500 bg-indigo-50' 
                                            : 'border-slate-200 hover:border-slate-300'
                                     ]">
                                    <div :class="[
                                        'w-12 h-12 rounded-xl flex items-center justify-center text-white text-xl bg-gradient-to-r',
                                        method.color
                                    ]">
                                        {{ method.icon }}
                                    </div>
                                    <div class="flex-1">
                                        <h3 class="font-semibold text-slate-800">{{ method.name }}</h3>
                                        <p class="text-sm text-slate-600">{{ method.type === 'mobile_money' ? 'Mobile Money' : 'Bank Transfer' }}</p>
                                    </div>
                                    <div v-if="form.payment_method === method.key" class="w-6 h-6 bg-indigo-500 rounded-full flex items-center justify-center">
                                        <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                                        </svg>
                                    </div>
                                </div>
                            </div>
                            <div v-if="form.errors.payment_method" class="mt-2 text-sm text-red-600">{{ form.errors.payment_method }}</div>
                        </div>

                        <!-- Payment Amount -->
                        <div class="mb-6">
                            <label class="block text-sm font-medium text-slate-700 mb-2">Payment Amount (MWK)</label>
                            <div class="relative">
                                <input v-model="form.amount" type="number" required
                                       class="w-full bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200"
                                       placeholder="Enter amount">
                                <div class="absolute right-3 top-3 text-sm text-slate-500">MWK</div>
                            </div>
                            <div v-if="form.errors.amount" class="mt-1 text-sm text-red-600">{{ form.errors.amount }}</div>
                        </div>

                        <!-- Reference Number -->
                        <div class="mb-6">
                            <label class="block text-sm font-medium text-slate-700 mb-2">Transaction Reference Number</label>
                            <input v-model="form.reference_number" type="text"
                                   class="w-full bg-slate-100/70 px-4 py-3 rounded-2xl text-sm focus:outline-none focus:ring-2 focus:ring-indigo-400 focus:bg-white transition-all duration-200"
                                   placeholder="Enter transaction ID or reference number">
                            <div v-if="form.errors.reference_number" class="mt-1 text-sm text-red-600">{{ form.errors.reference_number }}</div>
                        </div>

                        <!-- Proof Screenshot -->
                        <div class="mb-6">
                            <label class="block text-sm font-medium text-slate-700 mb-4">Payment Proof Screenshot</label>
                            <div class="flex items-center space-x-6">
                                <div class="w-24 h-24 rounded-2xl bg-gradient-to-br from-indigo-100 to-purple-100 flex items-center justify-center overflow-hidden">
                                    <img v-if="screenshotPreview" :src="screenshotPreview" alt="Screenshot preview" class="w-full h-full object-cover">
                                    <svg v-else class="w-8 h-8 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                    </svg>
                                </div>
                                <div>
                                    <button type="button" @click="selectScreenshot" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 rounded-xl text-sm font-medium transition-colors duration-200">
                                        Select Screenshot
                                    </button>
                                    <p class="text-xs text-slate-500 mt-1">JPG, PNG up to 5MB</p>
                                </div>
                            </div>
                            <input ref="screenshotInput" type="file" class="hidden" @change="updateScreenshotPreview" accept="image/*">
                            <div v-if="form.errors.proof_screenshot" class="mt-2 text-sm text-red-600">{{ form.errors.proof_screenshot }}</div>
                        </div>

                        <!-- Submit Button -->
                        <div class="flex flex-col sm:flex-row justify-end space-y-4 sm:space-y-0 sm:space-x-4">
                            <Link :href="route('payments.index')" 
                                  class="px-6 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-2xl font-semibold transition-all duration-200">
                                Cancel
                            </Link>
                            <button type="submit" :disabled="form.processing || !form.payment_method || hasPendingPayment"
                                    class="px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none">
                                <span v-if="form.processing">Submitting...</span>
                                <span v-else>Submit Payment</span>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Payment Instructions -->
                <div v-if="getSelectedMethod" class="bg-white/80 backdrop-blur-sm rounded-3xl p-8 shadow-xl border border-slate-200/50">
                    <div class="flex items-center space-x-3 mb-6">
                        <div :class="[
                            'w-12 h-12 rounded-xl flex items-center justify-center text-white text-xl bg-gradient-to-r',
                            getSelectedMethod.color
                        ]">
                            {{ getSelectedMethod.icon }}
                        </div>
                        <div>
                            <h2 class="text-xl font-bold text-slate-800">{{ getSelectedMethod.name }}</h2>
                            <p class="text-sm text-slate-600">Payment Instructions</p>
                        </div>
                    </div>

                    <div class="space-y-4">
                        <div v-for="(instruction, index) in getPaymentInstructions(getSelectedMethod)" 
                             :key="index"
                             class="flex items-start space-x-3">
                            <div class="w-6 h-6 bg-indigo-500 text-white rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 mt-1">
                                {{ index + 1 }}
                            </div>
                            <p class="text-sm text-slate-700">{{ instruction }}</p>
                        </div>
                    </div>

                    <div class="mt-6 p-4 bg-amber-50 border border-amber-200 rounded-xl">
                        <h3 class="font-semibold text-amber-800 mb-2">Important Note</h3>
                        <p class="text-sm text-amber-700">After completing the payment, please return here to submit your transaction details and proof. Your payment will be verified within 24 hours.</p>
                    </div>
                </div>
            </div>
    </DashboardLayout>
</template>