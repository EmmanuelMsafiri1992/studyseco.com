<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { onMounted, ref, computed } from 'vue';

const props = defineProps({
    canLogin: Boolean,
    canRegister: Boolean,
    laravelVersion: String,
    phpVersion: String,
    subjects: { type: Array, default: () => [] },
    studentCount: { type: Number, default: 500 },
    testimonials: { type: Array, default: () => [] },
    accessDurations: { type: Array, default: () => [] },
    studentStories: { type: Array, default: () => [] }
});

// State management
const showEnrollmentModal = ref(false);
const showChatModal = ref(false);
const showLibraryModal = ref(false);
const showChatWidget = ref(false);
const currentSlide = ref(0);
const isNavbarScrolled = ref(false);

// Chat functionality
const chatMessages = ref([
    { type: 'bot', message: 'Hello! 👋 Welcome to StudySeco. How can I help you today?', timestamp: new Date() }
]);
const newMessage = ref('');
const isTyping = ref(false);

// Enrollment form
const enrollmentForm = useForm({
    name: '',
    email: '',
    phone: '',
    address: '',
    selected_subjects: [],
    access_duration_id: '',
    payment_method: '',
    payment_reference: '',
    payment_proof: null,
    terms_accepted: false
});

// Default data with fallbacks
const defaultAccessDurations = [
    { id: 1, name: '6 Months Access', days: 180, price: 50000, description: 'Perfect for semester study' },
    { id: 2, name: '1 Year Access', days: 365, price: 85000, description: 'Full academic year access' },
    { id: 3, name: '2 Years Access', days: 730, price: 150000, description: 'Complete secondary education' }
];

const defaultSubjects = [
    { id: 1, name: 'Mathematics', description: 'Advanced mathematics curriculum' },
    { id: 2, name: 'English', description: 'Language and literature' },
    { id: 3, name: 'Science', description: 'Physics, Chemistry, Biology' },
    { id: 4, name: 'History', description: 'World and African history' }
];

const defaultStories = [
    {
        id: 1,
        name: 'Temwa Mwale',
        location: 'London, UK',
        country_flag: '🇬🇧',
        current_status: 'University of Edinburgh - Engineering',
        story: 'StudySeco allowed me to complete my Malawian secondary education while living in London. The teachers were incredible!',
        msce_credits: 6,
        avatar_color_from: 'emerald-500',
        avatar_color_to: 'blue-500'
    },
    {
        id: 2,
        name: 'Grace Kachingwe',
        location: 'Toronto, Canada',
        country_flag: '🇨🇦',
        current_status: 'University of Toronto - Medicine',
        story: 'The flexibility of online learning while maintaining the Malawian curriculum was perfect for my goals.',
        msce_credits: 8,
        avatar_color_from: 'purple-500',
        avatar_color_to: 'pink-500'
    }
];

const accessDurations = computed(() => props.accessDurations.length ? props.accessDurations : defaultAccessDurations);
const subjects = computed(() => props.subjects.length ? props.subjects : defaultSubjects);
const studentStories = computed(() => props.studentStories.length ? props.studentStories : defaultStories);

// Methods
const toggleEnrollmentModal = () => {
    showEnrollmentModal.value = !showEnrollmentModal.value;
};

const submitEnrollment = () => {
    enrollmentForm.post(route('enrollment.store'), {
        onSuccess: () => {
            showEnrollmentModal.value = false;
            enrollmentForm.reset();
        }
    });
};

const sendMessage = () => {
    if (newMessage.value.trim() === '') return;
    
    chatMessages.value.push({
        type: 'user',
        message: newMessage.value,
        timestamp: new Date()
    });
    
    const userMessage = newMessage.value;
    newMessage.value = '';
    isTyping.value = true;
    
    setTimeout(() => {
        chatMessages.value.push({
            type: 'bot',
            message: `Thanks for your message: "${userMessage}". A StudySeco representative will respond soon!`,
            timestamp: new Date()
        });
        isTyping.value = false;
    }, 2000);
};

const nextSlide = () => {
    currentSlide.value = (currentSlide.value + 1) % studentStories.value.length;
};

const prevSlide = () => {
    currentSlide.value = (currentSlide.value - 1 + studentStories.value.length) % studentStories.value.length;
};

// Lifecycle
onMounted(() => {
    const handleScroll = () => {
        isNavbarScrolled.value = window.scrollY > 20;
    };
    
    window.addEventListener('scroll', handleScroll);
    
    // Auto-advance testimonial slider
    setInterval(nextSlide, 6000);
    
    // Show chat widget after 3 seconds
    setTimeout(() => {
        showChatWidget.value = true;
    }, 3000);
});
</script>

<template>
    <Head title="StudySeco - Complete Malawi Secondary Education Online" />
    
    <!-- Navigation -->
    <nav :class="[
        'fixed top-0 w-full z-50 transition-all duration-500',
        isNavbarScrolled ? 'glass shadow-medium' : 'bg-transparent'
    ]">
        <div class="container-custom">
            <div class="flex items-center justify-between h-20">
                <!-- Logo -->
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-primary-600 to-accent-600 flex items-center justify-center shadow-soft">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                            <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                        </svg>
                    </div>
                    <div class="flex flex-col">
                        <span class="text-2xl font-bold text-secondary-900">StudySeco</span>
                        <span class="text-xs text-secondary-500 font-medium -mt-1">International Education</span>
                    </div>
                </div>

                <!-- Desktop Navigation -->
                <div class="hidden lg:flex items-center space-x-1">
                    <a href="#home" class="nav-link text-secondary-700">Home</a>
                    <a href="#programs" class="nav-link text-secondary-700">Programs</a>
                    <a href="#about" class="nav-link text-secondary-700">About</a>
                    <button @click="showLibraryModal = true" class="nav-link text-secondary-700">Resources</button>
                    <a href="#contact" class="nav-link text-secondary-700">Contact</a>
                </div>

                <!-- CTA Buttons -->
                <div class="flex items-center space-x-4" v-if="canLogin">
                    <Link
                        v-if="$page.props.auth.user"
                        :href="route('dashboard')"
                        class="btn-primary"
                    >
                        Dashboard
                    </Link>
                    <template v-else>
                        <Link :href="route('login')" class="btn-secondary">
                            Sign In
                        </Link>
                        <button @click="toggleEnrollmentModal" class="btn-primary">
                            Enroll Now
                        </button>
                    </template>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="hero-gradient hero-pattern min-h-screen flex items-center section-padding">
        <div class="container-custom">
            <div class="grid lg:grid-cols-2 gap-12 items-center">
                <!-- Hero Content -->
                <div class="fade-in-up animate">
                    <div class="inline-flex items-center px-4 py-2 rounded-full bg-primary-50 border border-primary-200 text-primary-700 text-sm font-medium mb-8">
                        <span class="relative flex h-2 w-2 mr-2">
                            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary-400 opacity-75"></span>
                            <span class="relative inline-flex rounded-full h-2 w-2 bg-primary-500"></span>
                        </span>
                        Now accepting international students
                    </div>
                    
                    <h1 class="heading-xl text-secondary-900 mb-6 text-balance">
                        Complete Your 
                        <span class="text-gradient">Malawi Secondary</span>
                        Education Online
                    </h1>
                    
                    <p class="text-xl text-secondary-600 mb-8 leading-relaxed">
                        Join {{ studentCount }}+ students worldwide studying the official Malawi curriculum with certified teachers, flexible schedules, and international accessibility.
                    </p>
                    
                    <div class="flex flex-col sm:flex-row gap-4 mb-8">
                        <button @click="toggleEnrollmentModal" class="btn-primary btn-lg">
                            Start Learning Today
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="ml-2">
                                <path d="M5 12h14m-7-7 7 7-7 7"/>
                            </svg>
                        </button>
                        <button @click="showLibraryModal = true" class="btn-secondary btn-lg">
                            Explore Resources
                        </button>
                    </div>
                    
                    <!-- Trust Indicators -->
                    <div class="flex items-center space-x-6 text-sm text-secondary-600">
                        <div class="flex items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-success-500 mr-2">
                                <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            Official Curriculum
                        </div>
                        <div class="flex items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-success-500 mr-2">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                            </svg>
                            Certified Teachers
                        </div>
                        <div class="flex items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-success-500 mr-2">
                                <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z"/>
                            </svg>
                            Global Access
                        </div>
                    </div>
                </div>
                
                <!-- Hero Visual -->
                <div class="relative fade-in-up animate">
                    <div class="relative z-10">
                        <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80" 
                             alt="Students learning online" 
                             class="rounded-3xl shadow-hard w-full">
                        
                        <!-- Floating Cards -->
                        <div class="absolute -top-4 -left-4 glass-card p-4 animate-bounce-gentle">
                            <div class="text-2xl font-bold text-primary-600">{{ studentCount }}+</div>
                            <div class="text-sm text-secondary-600">Active Students</div>
                        </div>
                        
                        <div class="absolute -bottom-4 -right-4 glass-card p-4 animate-bounce-gentle" style="animation-delay: 1s;">
                            <div class="text-2xl font-bold text-accent-600">98%</div>
                            <div class="text-sm text-secondary-600">Success Rate</div>
                        </div>
                    </div>
                    
                    <!-- Background Elements -->
                    <div class="absolute -z-10 top-8 left-8 w-72 h-72 bg-primary-200 rounded-full opacity-20 blur-3xl"></div>
                    <div class="absolute -z-10 bottom-8 right-8 w-96 h-96 bg-accent-200 rounded-full opacity-20 blur-3xl"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- Programs Section -->
    <section id="programs" class="section-padding bg-white">
        <div class="container-custom">
            <div class="text-center mb-16">
                <h2 class="heading-lg text-secondary-900 mb-4">Our Academic Programs</h2>
                <p class="text-xl text-secondary-600 max-w-3xl mx-auto">
                    Comprehensive secondary education following the official Malawi curriculum with modern teaching methods
                </p>
            </div>
            
            <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
                <div v-for="subject in subjects.slice(0, 4)" :key="subject.id" class="card-hover p-8 text-center group">
                    <div class="w-16 h-16 rounded-2xl bg-gradient-to-br from-primary-100 to-accent-100 flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform duration-300">
                        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-primary-600">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <polyline points="14,2 14,8 20,8"/>
                            <line x1="16" y1="13" x2="8" y2="13"/>
                            <line x1="16" y1="17" x2="8" y2="17"/>
                            <polyline points="10,9 9,9 8,9"/>
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-secondary-900 mb-3">{{ subject.name }}</h3>
                    <p class="text-secondary-600">{{ subject.description || 'Comprehensive curriculum designed for excellence' }}</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Student Stories Section -->
    <section class="section-padding bg-secondary-50">
        <div class="container-custom">
            <div class="text-center mb-16">
                <h2 class="heading-lg text-secondary-900 mb-4">Student Success Stories</h2>
                <p class="text-xl text-secondary-600">Hear from our graduates studying at top universities worldwide</p>
            </div>
            
            <div class="relative">
                <div class="overflow-hidden rounded-3xl">
                    <div 
                        class="flex transition-transform duration-700 ease-out"
                        :style="{ transform: `translateX(-${currentSlide * 100}%)` }"
                    >
                        <div 
                            v-for="story in studentStories" 
                            :key="story.id"
                            class="w-full flex-shrink-0"
                        >
                            <div class="card-gradient p-12 text-center max-w-4xl mx-auto">
                                <div :class="[
                                    'w-24 h-24 rounded-full mx-auto mb-8 flex items-center justify-center text-white text-2xl font-bold bg-gradient-to-br',
                                    `from-${story.avatar_color_from}`,
                                    `to-${story.avatar_color_to}`
                                ]">
                                    {{ story.name.split(' ').map(n => n[0]).join('') }}
                                </div>
                                
                                <blockquote class="text-2xl font-medium text-secondary-800 mb-8 italic">
                                    "{{ story.story }}"
                                </blockquote>
                                
                                <div class="space-y-2">
                                    <div class="font-semibold text-secondary-900">{{ story.name }}</div>
                                    <div class="text-secondary-600">{{ story.location }} {{ story.country_flag }}</div>
                                    <div class="text-primary-600 font-medium">{{ story.current_status }}</div>
                                    <div class="inline-flex items-center px-4 py-2 rounded-full bg-success-100 text-success-800 text-sm font-medium">
                                        🏆 {{ story.msce_credits }} MSCE Credits
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Navigation -->
                <div class="flex justify-center items-center mt-8 space-x-4">
                    <button @click="prevSlide" class="p-3 rounded-full bg-white shadow-soft hover:shadow-medium transition-all duration-200">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="15,18 9,12 15,6"/>
                        </svg>
                    </button>
                    
                    <div class="flex space-x-2">
                        <button 
                            v-for="(story, index) in studentStories" 
                            :key="index"
                            @click="currentSlide = index"
                            :class="[
                                'w-3 h-3 rounded-full transition-all duration-200',
                                currentSlide === index ? 'bg-primary-500' : 'bg-secondary-300'
                            ]"
                        ></button>
                    </div>
                    
                    <button @click="nextSlide" class="p-3 rounded-full bg-white shadow-soft hover:shadow-medium transition-all duration-200">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="9,18 15,12 9,6"/>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="section-padding bg-gradient-to-br from-primary-600 to-accent-600 text-white">
        <div class="container-custom text-center">
            <h2 class="heading-lg mb-6">Ready to Start Your Journey?</h2>
            <p class="text-xl mb-8 opacity-90 max-w-2xl mx-auto">
                Join thousands of students who have successfully completed their Malawi secondary education with StudySeco.
            </p>
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <button @click="toggleEnrollmentModal" class="btn bg-white text-primary-600 hover:bg-secondary-50 btn-lg">
                    Enroll Today
                </button>
                <button @click="showChatModal = true" class="btn border-2 border-white text-white hover:bg-white hover:text-primary-600 btn-lg">
                    Talk to Advisor
                </button>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-secondary-900 text-white py-16">
        <div class="container-custom">
            <div class="grid md:grid-cols-4 gap-8">
                <div class="col-span-2">
                    <div class="flex items-center space-x-3 mb-6">
                        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-primary-500 to-accent-500 flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                                <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                                <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                            </svg>
                        </div>
                        <span class="text-xl font-bold">StudySeco</span>
                    </div>
                    <p class="text-secondary-300 mb-6 max-w-md">
                        Empowering students worldwide with quality Malawi secondary education through innovative online learning.
                    </p>
                </div>
                
                <div>
                    <h3 class="font-semibold mb-4">Quick Links</h3>
                    <ul class="space-y-2 text-secondary-300">
                        <li><a href="#programs" class="hover:text-white transition-colors">Programs</a></li>
                        <li><a href="#about" class="hover:text-white transition-colors">About</a></li>
                        <li><button @click="showLibraryModal = true" class="hover:text-white transition-colors">Resources</button></li>
                    </ul>
                </div>
                
                <div>
                    <h3 class="font-semibold mb-4">Contact</h3>
                    <ul class="space-y-2 text-secondary-300">
                        <li>support@studyseco.com</li>
                        <li>+265 123 456 789</li>
                        <li>Lilongwe, Malawi</li>
                    </ul>
                </div>
            </div>
            
            <div class="border-t border-secondary-700 mt-12 pt-8 text-center text-secondary-400">
                <p>&copy; 2024 StudySeco. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Chat Widget -->
    <div 
        v-if="showChatWidget"
        class="fixed bottom-6 right-6 z-40"
        :class="{ 'animate-bounce-gentle': !showChatModal }"
    >
        <button 
            @click="showChatModal = true"
            class="w-16 h-16 rounded-full bg-gradient-to-r from-primary-500 to-accent-500 text-white shadow-hard hover:shadow-glow transition-all duration-300 flex items-center justify-center"
        >
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
            </svg>
        </button>
    </div>

    <!-- Enrollment Modal -->
    <div v-if="showEnrollmentModal" class="modal-overlay flex items-center justify-center p-4" @click.self="showEnrollmentModal = false">
        <div class="modal-content p-8 max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold text-secondary-900">Enroll at StudySeco</h2>
                <button @click="showEnrollmentModal = false" class="p-2 hover:bg-secondary-100 rounded-lg transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"/>
                        <line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                </button>
            </div>
            
            <form @submit.prevent="submitEnrollment" class="space-y-6">
                <div class="grid md:grid-cols-2 gap-4">
                    <div>
                        <label class="form-label">Full Name</label>
                        <input v-model="enrollmentForm.name" type="text" class="form-input" required>
                    </div>
                    <div>
                        <label class="form-label">Email Address</label>
                        <input v-model="enrollmentForm.email" type="email" class="form-input" required>
                    </div>
                </div>
                
                <div class="grid md:grid-cols-2 gap-4">
                    <div>
                        <label class="form-label">Phone Number</label>
                        <input v-model="enrollmentForm.phone" type="tel" class="form-input" required>
                    </div>
                    <div>
                        <label class="form-label">Address</label>
                        <input v-model="enrollmentForm.address" type="text" class="form-input" required>
                    </div>
                </div>
                
                <div>
                    <label class="form-label">Access Duration</label>
                    <select v-model="enrollmentForm.access_duration_id" class="form-input" required>
                        <option value="">Select Duration</option>
                        <option v-for="duration in accessDurations" :key="duration.id" :value="duration.id">
                            {{ duration.name }} - MWK {{ duration.price.toLocaleString() }}
                        </option>
                    </select>
                </div>
                
                <div class="flex items-center">
                    <input v-model="enrollmentForm.terms_accepted" type="checkbox" class="rounded border-secondary-300 text-primary-600 focus:ring-primary-500 mr-3">
                    <label class="text-sm text-secondary-700">I agree to the terms and conditions</label>
                </div>
                
                <div class="flex gap-4">
                    <button type="button" @click="showEnrollmentModal = false" class="btn-secondary flex-1">
                        Cancel
                    </button>
                    <button type="submit" :disabled="enrollmentForm.processing" class="btn-primary flex-1">
                        <span v-if="enrollmentForm.processing">Processing...</span>
                        <span v-else>Enroll Now</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Chat Modal -->
    <div v-if="showChatModal" class="modal-overlay flex items-end sm:items-center justify-center p-4" @click.self="showChatModal = false">
        <div class="modal-content max-w-lg w-full sm:mx-4 h-96 flex flex-col">
            <div class="flex justify-between items-center p-6 border-b border-secondary-200">
                <h3 class="font-semibold text-secondary-900">Chat with StudySeco</h3>
                <button @click="showChatModal = false" class="p-2 hover:bg-secondary-100 rounded-lg transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"/>
                        <line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                </button>
            </div>
            
            <div class="flex-1 p-6 overflow-y-auto space-y-4">
                <div v-for="message in chatMessages" :key="message.timestamp" :class="[
                    'flex',
                    message.type === 'user' ? 'justify-end' : 'justify-start'
                ]">
                    <div :class="[
                        'max-w-xs px-4 py-2 rounded-2xl text-sm',
                        message.type === 'user' 
                            ? 'bg-primary-500 text-white rounded-br-md' 
                            : 'bg-secondary-100 text-secondary-800 rounded-bl-md'
                    ]">
                        {{ message.message }}
                    </div>
                </div>
                
                <div v-if="isTyping" class="flex justify-start">
                    <div class="bg-secondary-100 text-secondary-800 px-4 py-2 rounded-2xl rounded-bl-md text-sm">
                        <span class="animate-pulse">Typing...</span>
                    </div>
                </div>
            </div>
            
            <div class="p-6 border-t border-secondary-200">
                <form @submit.prevent="sendMessage" class="flex gap-3">
                    <input 
                        v-model="newMessage" 
                        type="text" 
                        placeholder="Type your message..."
                        class="form-input flex-1"
                    >
                    <button type="submit" class="btn-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="22" y1="2" x2="11" y2="13"/>
                            <polygon points="22,2 15,22 11,13 2,9 22,2"/>
                        </svg>
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Resources Modal -->
    <div v-if="showLibraryModal" class="modal-overlay flex items-center justify-center p-4" @click.self="showLibraryModal = false">
        <div class="modal-content p-8 max-w-4xl w-full">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold text-secondary-900">Learning Resources</h2>
                <button @click="showLibraryModal = false" class="p-2 hover:bg-secondary-100 rounded-lg transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"/>
                        <line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                </button>
            </div>
            
            <div class="grid md:grid-cols-2 gap-6">
                <div class="card p-6">
                    <h3 class="font-semibold text-secondary-900 mb-4">📚 Digital Library</h3>
                    <p class="text-secondary-600 mb-4">Access textbooks, references, and study materials for all subjects.</p>
                    <button class="btn-primary w-full">Browse Library</button>
                </div>
                
                <div class="card p-6">
                    <h3 class="font-semibold text-secondary-900 mb-4">🎥 Video Lessons</h3>
                    <p class="text-secondary-600 mb-4">Watch recorded lessons from our certified teachers anytime.</p>
                    <button class="btn-primary w-full">Watch Lessons</button>
                </div>
                
                <div class="card p-6">
                    <h3 class="font-semibold text-secondary-900 mb-4">📝 Practice Tests</h3>
                    <p class="text-secondary-600 mb-4">Prepare for MSCE with past papers and practice questions.</p>
                    <button class="btn-primary w-full">Start Practice</button>
                </div>
                
                <div class="card p-6">
                    <h3 class="font-semibold text-secondary-900 mb-4">👥 Study Groups</h3>
                    <p class="text-secondary-600 mb-4">Connect with other students in virtual study sessions.</p>
                    <button class="btn-primary w-full">Join Groups</button>
                </div>
            </div>
        </div>
    </div>
</template>