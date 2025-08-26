<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    auth: Object,
    payments: Object,
    hasValidAccess: Boolean,
});

const user = props.auth?.user || { name: 'Guest', role: 'guest', profile_photo_url: null };

const getStatusColor = (status) => {
    switch(status) {
        case 'pending': return 'amber';
        case 'approved': return 'green';
        case 'rejected': return 'red';
        default: return 'gray';
    }
};

const formatAmount = (amount) => {
    return 'MWK ' + new Intl.NumberFormat().format(amount);
};

const formatDate = (date) => {
    return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
};

const getDaysRemaining = (expiresAt) => {
    if (!expiresAt) return null;
    const now = new Date();
    const expires = new Date(expiresAt);
    const diffTime = expires - now;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays > 0 ? diffDays : 0;
};

const activePayment = computed(() => {
    return props.payments.data.find(payment => 
        payment.status === 'approved' && 
        payment.access_expires_at && 
        new Date(payment.access_expires_at) > new Date()
    );
});
</script>

<template>
    <Head title="My Payments" />
    
    <div class="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 font-sans text-slate-800">
        <!-- Header -->
        <header class="h-16 bg-white/70 backdrop-blur-xl border-b border-slate-200/50 px-6 flex items-center justify-between relative z-50">
            <div class="flex items-center space-x-4">
                <Link :href="route('dashboard')" class="p-2 hover:bg-slate-100 rounded-xl transition-colors duration-200">
                    <svg class="w-5 h-5 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                    </svg>
                </Link>
                <div>
                    <h1 class="text-lg font-bold text-slate-800">My Payments</h1>
                    <p class="text-sm text-slate-500">Payment history and system access</p>
                </div>
            </div>
            
            <div class="flex items-center space-x-3">
                <div class="text-right">
                    <p class="text-sm font-semibold text-slate-800">{{ user.name }}</p>
                    <p class="text-xs text-slate-500">{{ user.role }}</p>
                </div>
                <img :src="user.profile_photo_url || 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=40&h=40&fit=crop&crop=face&facepad=2&bg=white'" :alt="user.name" class="h-10 w-10 rounded-xl ring-2 ring-white shadow-md">
            </div>
        </header>

        <!-- Main Content -->
        <main class="flex-1 p-6 max-w-6xl mx-auto">
            <!-- Access Status Card -->
            <div class="mb-8 bg-white/80 backdrop-blur-sm rounded-3xl p-6 shadow-xl border border-slate-200/50">
                <div class="flex items-center justify-between">
                    <div>
                        <h2 class="text-xl font-bold text-slate-800 mb-2">System Access Status</h2>
                        <div v-if="hasValidAccess && activePayment" class="flex items-center space-x-3">
                            <div class="flex items-center space-x-2">
                                <div class="w-3 h-3 bg-green-500 rounded-full"></div>
                                <span class="text-green-700 font-semibold">Active</span>
                            </div>
                            <div class="text-slate-600">
                                Expires: {{ formatDate(activePayment.access_expires_at) }}
                            </div>
                            <div class="text-slate-600">
                                ({{ getDaysRemaining(activePayment.access_expires_at) }} days remaining)
                            </div>
                        </div>
                        <div v-else class="flex items-center space-x-2">
                            <div class="w-3 h-3 bg-red-500 rounded-full"></div>
                            <span class="text-red-700 font-semibold">No Active Access</span>
                        </div>
                    </div>
                    <div class="text-right">
                        <Link :href="route('payments.create')" 
                              :class="[
                                  'px-6 py-3 rounded-2xl font-semibold transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1',
                                  hasValidAccess 
                                      ? 'bg-slate-100 hover:bg-slate-200 text-slate-700' 
                                      : 'bg-gradient-to-r from-indigo-500 to-purple-600 text-white hover:from-indigo-600 hover:to-purple-700'
                              ]">
                            {{ hasValidAccess ? 'Extend Access' : 'Make Payment' }}
                        </Link>
                    </div>
                </div>
            </div>

            <!-- Payments List -->
            <div class="bg-white/80 backdrop-blur-sm rounded-3xl shadow-xl border border-slate-200/50 overflow-hidden">
                <div class="p-6 border-b border-slate-200/50">
                    <h2 class="text-xl font-bold text-slate-800">Payment History</h2>
                </div>

                <div v-if="payments.data.length > 0" class="divide-y divide-slate-200/50">
                    <div v-for="payment in payments.data" :key="payment.id"
                         class="p-6 hover:bg-slate-50/50 transition-colors duration-200">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-4">
                                <!-- Payment Method Icon -->
                                <div class="w-12 h-12 rounded-xl bg-gradient-to-r from-indigo-500 to-purple-600 flex items-center justify-center text-white">
                                    <svg v-if="payment.payment_method === 'tnm_mpamba'" class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                        <path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/>
                                    </svg>
                                    <svg v-else-if="payment.payment_method === 'airtel_money'" class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
                                        <path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/>
                                    </svg>
                                    <svg v-else class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
                                    </svg>
                                </div>

                                <div>
                                    <h3 class="font-semibold text-slate-800">
                                        {{ payment.payment_method === 'tnm_mpamba' ? 'TNM Mpamba' : 
                                           payment.payment_method === 'airtel_money' ? 'Airtel Money' : 'Bank Transfer' }}
                                    </h3>
                                    <div class="flex items-center space-x-4 text-sm text-slate-600">
                                        <span>{{ formatAmount(payment.amount) }}</span>
                                        <span>{{ payment.access_duration_days }} days access</span>
                                        <span>{{ formatDate(payment.created_at) }}</span>
                                        <span v-if="payment.reference_number">Ref: {{ payment.reference_number }}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="flex items-center space-x-4">
                                <!-- Access Expiry Info -->
                                <div v-if="payment.status === 'approved' && payment.access_expires_at" class="text-right text-sm">
                                    <div class="text-slate-600">Expires</div>
                                    <div class="font-semibold text-slate-800">{{ formatDate(payment.access_expires_at) }}</div>
                                    <div :class="[
                                        'text-xs',
                                        getDaysRemaining(payment.access_expires_at) > 7 ? 'text-green-600' : 'text-red-600'
                                    ]">
                                        {{ getDaysRemaining(payment.access_expires_at) }} days left
                                    </div>
                                </div>

                                <!-- Status Badge -->
                                <div :class="[
                                    'px-3 py-1 rounded-full text-xs font-semibold',
                                    payment.status === 'pending' ? 'bg-amber-100 text-amber-800' :
                                    payment.status === 'approved' ? 'bg-green-100 text-green-800' :
                                    'bg-red-100 text-red-800'
                                ]">
                                    {{ payment.status.charAt(0).toUpperCase() + payment.status.slice(1) }}
                                </div>

                                <!-- View Details -->
                                <Link :href="route('payments.show', payment.id)" 
                                      class="p-2 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-lg transition-colors duration-200">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                                    </svg>
                                </Link>
                            </div>
                        </div>

                        <!-- Rejection Reason -->
                        <div v-if="payment.status === 'rejected' && payment.rejection_reason" 
                             class="mt-4 p-3 bg-red-50 border border-red-200 rounded-xl">
                            <div class="flex items-center space-x-2 mb-1">
                                <svg class="w-4 h-4 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
                                </svg>
                                <span class="text-sm font-semibold text-red-800">Rejection Reason:</span>
                            </div>
                            <p class="text-sm text-red-700">{{ payment.rejection_reason }}</p>
                        </div>

                        <!-- Pending Note -->
                        <div v-if="payment.status === 'pending'" 
                             class="mt-4 p-3 bg-amber-50 border border-amber-200 rounded-xl">
                            <div class="flex items-center space-x-2">
                                <svg class="w-4 h-4 text-amber-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                                <span class="text-sm text-amber-700">Your payment is being verified. You will receive access once approved.</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Empty State -->
                <div v-else class="p-12 text-center">
                    <div class="w-16 h-16 bg-gradient-to-br from-slate-100 to-slate-200 rounded-2xl flex items-center justify-center mx-auto mb-4">
                        <svg class="w-8 h-8 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
                        </svg>
                    </div>
                    <h3 class="text-lg font-semibold text-slate-800 mb-2">No payments yet</h3>
                    <p class="text-slate-500 mb-6">You haven't made any payments. Make your first payment to access the system.</p>
                    <Link :href="route('payments.create')" 
                          class="px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-2xl font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1">
                        Make Your First Payment
                    </Link>
                </div>

                <!-- Pagination -->
                <div v-if="payments.links && payments.links.length > 3" class="p-6 border-t border-slate-200/50">
                    <div class="flex justify-center space-x-2">
                        <Link v-for="link in payments.links" :key="link.label" 
                              :href="link.url"
                              :class="[
                                  'px-3 py-2 text-sm rounded-lg transition-colors duration-200',
                                  link.active ? 'bg-indigo-500 text-white' : 'text-slate-600 hover:bg-slate-100'
                              ]"
                              v-html="link.label">
                        </Link>
                    </div>
                </div>
            </div>
        </main>
    </div>
</template>