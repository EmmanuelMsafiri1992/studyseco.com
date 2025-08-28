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
const showSubjectModal = ref(false);
const selectedSubject = ref(null);
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
    country: '',
    selected_subjects: [],
    enrollment_type: 'trial', // trial or paid
    payment_method_id: '',
    payment_reference: '',
    payment_proof: null,
    terms_accepted: false
});

// Enrollment state management
const enrollmentStep = ref(1); // 1: subjects, 2: info, 3: payment
const selectedSubjects = ref([]);
const showTrialOption = ref(true);
const detectedCountry = ref('');
const detectedCurrency = ref('');

// Payment state
const showPaymentStep = ref(false);
const availablePaymentMethods = ref([]);
const selectedRegion = computed(() => {
    if (!enrollmentForm.country) return 'international';
    const country = enrollmentForm.country.toLowerCase();
    if (country === 'malawi') return 'malawi';
    if (country === 'south africa') return 'south_africa';
    return 'international';
});

// Currency and pricing
const getCurrencyInfo = (region) => {
    switch(region) {
        case 'malawi':
            return { currency: 'MWK', price: 50000, symbol: 'MK' };
        case 'south_africa':
            return { currency: 'ZAR', price: 350, symbol: 'R' };
        default:
            return { currency: 'USD', price: 25, symbol: '$' };
    }
};

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
    if (showEnrollmentModal.value) {
        // Reset form state when opening modal
        enrollmentStep.value = 1;
        selectedSubjects.value = [];
        enrollmentForm.selected_subjects = [];
        enrollmentForm.country = detectedCountry.value || '';
        updateCurrencyBasedOnCountry();
    }
};

const showSubjectEnrollment = (subject) => {
    selectedSubject.value = subject;
    showSubjectModal.value = true;
};

// Location detection
const detectUserLocation = async () => {
    try {
        // Try browser geolocation first
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(async (position) => {
                // Use reverse geocoding to get country (simplified)
                detectedCountry.value = 'Malawi'; // Default for now
                updateCurrencyBasedOnCountry();
            });
        } else {
            // Fallback to IP-based detection
            try {
                const response = await fetch('https://ipapi.co/json/');
                const data = await response.json();
                detectedCountry.value = data.country_name || 'Malawi';
                updateCurrencyBasedOnCountry();
            } catch (error) {
                detectedCountry.value = 'Malawi';
                updateCurrencyBasedOnCountry();
            }
        }
    } catch (error) {
        detectedCountry.value = 'Malawi';
        updateCurrencyBasedOnCountry();
    }
};

const updateCurrencyBasedOnCountry = () => {
    const country = (enrollmentForm.country || detectedCountry.value).toLowerCase();
    if (country === 'malawi') {
        detectedCurrency.value = 'MWK';
    } else if (country === 'south africa') {
        detectedCurrency.value = 'ZAR';
    } else {
        detectedCurrency.value = 'USD';
    }
};

const toggleSubjectSelection = (subject) => {
    const index = selectedSubjects.value.findIndex(s => s.id === subject.id);
    if (index > -1) {
        selectedSubjects.value.splice(index, 1);
    } else {
        selectedSubjects.value.push(subject);
    }
    enrollmentForm.selected_subjects = selectedSubjects.value.map(s => s.id);
};

const getTotalAmount = () => {
    if (enrollmentForm.enrollment_type === 'trial') return 0;
    
    const pricePerSubject = getCurrencyInfo(selectedRegion.value).price;
    return selectedSubjects.value.length * pricePerSubject;
};

const nextEnrollmentStep = () => {
    if (enrollmentStep.value === 1 && selectedSubjects.value.length === 0) {
        alert('Please select at least one subject');
        return;
    }
    if (enrollmentStep.value < 3) {
        enrollmentStep.value++;
    }
};

const prevEnrollmentStep = () => {
    if (enrollmentStep.value > 1) {
        enrollmentStep.value--;
    }
};

const submitEnrollment = () => {
    if (enrollmentStep.value !== 3 && enrollmentForm.enrollment_type === 'paid') {
        nextEnrollmentStep();
        return;
    }
    
    enrollmentForm.post(route('enrollment.store'), {
        onSuccess: () => {
            showEnrollmentModal.value = false;
            enrollmentForm.reset();
            selectedSubjects.value = [];
            enrollmentStep.value = 1;
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

const scrollToContact = (e) => {
    e.preventDefault();
    const contactElement = document.getElementById('contact');
    if (contactElement) {
        contactElement.scrollIntoView({ behavior: 'smooth' });
    }
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
    
    // Detect user location on mount
    detectUserLocation();
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
                    <a href="#subjects" class="nav-link text-secondary-700">Subjects</a>
                    <a href="#about" class="nav-link text-secondary-700">About</a>
                    <button @click="showLibraryModal = true" class="nav-link text-secondary-700">Resources</button>
                    <a href="#contact" @click="scrollToContact" class="nav-link text-secondary-700">Contact</a>
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

    <!-- Subjects Section -->
    <section id="subjects" class="section-padding bg-white">
        <div class="container-custom">
            <div class="text-center mb-16">
                <h2 class="heading-lg text-secondary-900 mb-4">Our Academic Subjects</h2>
                <p class="text-xl text-secondary-600 max-w-3xl mx-auto">
                    Comprehensive secondary education following the official Malawi curriculum with modern teaching methods
                </p>
            </div>
            
            <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
                <div v-for="subject in subjects" :key="subject.id" class="card-hover p-6 text-center group cursor-pointer" @click="showSubjectEnrollment(subject)">
                    <div class="w-20 h-20 rounded-2xl bg-gradient-to-br from-primary-100 to-accent-100 flex items-center justify-center mx-auto mb-4 group-hover:scale-110 transition-transform duration-300">
                        <span class="text-3xl">{{ subject.icon }}</span>
                    </div>
                    <h3 class="text-lg font-semibold text-secondary-900 mb-2">{{ subject.name }}</h3>
                    <p class="text-sm text-secondary-600 mb-3">{{ subject.description }}</p>
                    <div class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-primary-50 text-primary-700">
                        {{ subject.department || (subject.type === 'core' ? 'Core Subject' : 'Optional Subject') }}
                    </div>
                    <div class="mt-3 text-xs text-secondary-500">
                        {{ subject.grade_level || 'Form 1-4' }} • Click to learn more
                    </div>
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
                        <li><a href="#subjects" class="hover:text-white transition-colors">Subjects</a></li>
                        <li><a href="#about" class="hover:text-white transition-colors">About</a></li>
                        <li><button @click="showLibraryModal = true" class="hover:text-white transition-colors">Resources</button></li>
                    </ul>
                </div>
                
                <div id="contact">
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

    <!-- Comprehensive Enrollment Modal -->
    <div v-if="showEnrollmentModal" class="modal-overlay flex items-center justify-center p-4" @click.self="showEnrollmentModal = false">
        <div class="modal-content p-8 max-w-6xl w-full max-h-[95vh] overflow-y-auto">
            <!-- Header with Progress -->
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h2 class="text-3xl font-bold text-secondary-900">Join StudySeco</h2>
                    <p class="text-secondary-600 mt-1">Excellence in Malawian Secondary Education</p>
                </div>
                <button @click="showEnrollmentModal = false" class="p-2 hover:bg-secondary-100 rounded-lg transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"/>
                        <line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                </button>
            </div>
            
            <!-- Progress Steps -->
            <div class="flex items-center justify-center mb-8">
                <div class="flex items-center space-x-4">
                    <div :class="['flex items-center justify-center w-10 h-10 rounded-full text-sm font-semibold transition-colors', enrollmentStep >= 1 ? 'bg-primary-600 text-white' : 'bg-gray-200 text-gray-600']">1</div>
                    <div :class="['w-16 h-1 transition-colors', enrollmentStep >= 2 ? 'bg-primary-600' : 'bg-gray-200']"></div>
                    <div :class="['flex items-center justify-center w-10 h-10 rounded-full text-sm font-semibold transition-colors', enrollmentStep >= 2 ? 'bg-primary-600 text-white' : 'bg-gray-200 text-gray-600']">2</div>
                    <div v-if="enrollmentForm.enrollment_type === 'paid'" :class="['w-16 h-1 transition-colors', enrollmentStep >= 3 ? 'bg-primary-600' : 'bg-gray-200']"></div>
                    <div v-if="enrollmentForm.enrollment_type === 'paid'" :class="['flex items-center justify-center w-10 h-10 rounded-full text-sm font-semibold transition-colors', enrollmentStep >= 3 ? 'bg-primary-600 text-white' : 'bg-gray-200 text-gray-600']">3</div>
                </div>
            </div>
            
            <form @submit.prevent="submitEnrollment" class="space-y-8">
                <!-- Step 1: Subject Selection & Enrollment Type -->
                <div v-show="enrollmentStep === 1" class="space-y-8">
                    <div class="text-center mb-8">
                        <h3 class="text-2xl font-semibold text-secondary-900 mb-3">Choose Your Learning Path</h3>
                        <p class="text-secondary-600">Select subjects and enrollment type for your Malawi secondary education journey</p>
                    </div>
                    
                    <!-- Trial vs Paid Options -->
                    <div class="bg-gradient-to-r from-blue-50 to-green-50 p-8 rounded-2xl mb-8">
                        <div class="grid md:grid-cols-2 gap-6">
                            <div :class="['border-2 rounded-xl p-6 cursor-pointer transition-all transform hover:scale-105', enrollmentForm.enrollment_type === 'trial' ? 'border-green-500 bg-green-50 shadow-lg' : 'border-gray-200 hover:border-green-300']" @click="enrollmentForm.enrollment_type = 'trial'">
                                <div class="flex items-center mb-4">
                                    <input type="radio" v-model="enrollmentForm.enrollment_type" value="trial" class="mr-3 text-green-500">
                                    <div class="flex items-center space-x-2">
                                        <span class="text-2xl">🎯</span>
                                        <h5 class="font-bold text-green-700 text-lg">Free 7-Day Trial</h5>
                                    </div>
                                </div>
                                <div class="bg-white p-4 rounded-lg mb-4">
                                    <p class="text-green-600 font-semibold text-center text-xl">FREE for 7 days</p>
                                </div>
                                <ul class="text-sm text-green-600 space-y-2">
                                    <li class="flex items-center"><span class="mr-2">✓</span>Full access to all features</li>
                                    <li class="flex items-center"><span class="mr-2">✓</span>All selected subjects included</li>
                                    <li class="flex items-center"><span class="mr-2">✓</span>Email & phone verification required</li>
                                    <li class="flex items-center"><span class="mr-2">✓</span>Perfect for exploring StudySeco</li>
                                    <li class="flex items-center"><span class="mr-2">✓</span>No payment needed to start</li>
                                </ul>
                            </div>
                            <div :class="['border-2 rounded-xl p-6 cursor-pointer transition-all transform hover:scale-105', enrollmentForm.enrollment_type === 'paid' ? 'border-blue-500 bg-blue-50 shadow-lg' : 'border-gray-200 hover:border-blue-300']" @click="enrollmentForm.enrollment_type = 'paid'">
                                <div class="flex items-center mb-4">
                                    <input type="radio" v-model="enrollmentForm.enrollment_type" value="paid" class="mr-3 text-blue-500">
                                    <div class="flex items-center space-x-2">
                                        <span class="text-2xl">📚</span>
                                        <h5 class="font-bold text-blue-700 text-lg">Full Access (4 Months)</h5>
                                    </div>
                                </div>
                                <div class="bg-white p-4 rounded-lg mb-4">
                                    <div class="text-center">
                                        <p class="text-blue-600 font-semibold">{{ getCurrencyInfo(selectedRegion).symbol }}{{ getCurrencyInfo(selectedRegion).price }} per subject</p>
                                        <p class="text-xs text-blue-500">4 months access guaranteed</p>
                                    </div>
                                </div>
                                <ul class="text-sm text-blue-600 space-y-2">
                                    <li class="flex items-center"><span class="mr-2">✓</span>4 months unlimited access</li>
                                    <li class="flex items-center"><span class="mr-2">✓</span>Pay per subject selected</li>
                                    <li class="flex items-center"><span class="mr-2">✓</span>Extension options available</li>
                                    <li class="flex items-center"><span class="mr-2">✓</span>Full MANEB curriculum support</li>
                                    <li class="flex items-center"><span class="mr-2">✓</span>Certificate eligible</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Subject Selection Grid -->
                    <div>
                        <h4 class="text-xl font-semibold text-secondary-900 mb-6 text-center">Choose Your Subjects (Select at least 1, maximum 12)</h4>
                        <div class="grid md:grid-cols-3 lg:grid-cols-4 gap-4 mb-6">
                            <div v-for="subject in subjects" :key="subject.id" 
                                 :class="['card p-4 cursor-pointer transition-all border-2 transform hover:scale-105', selectedSubjects.some(s => s.id === subject.id) ? 'border-primary-500 bg-primary-50 shadow-lg' : 'border-gray-200 hover:border-primary-300']"
                                 @click="toggleSubjectSelection(subject)">
                                <div class="text-center">
                                    <div class="text-3xl mb-3">{{ subject.icon || '📚' }}</div>
                                    <h5 class="font-semibold text-sm text-secondary-900 mb-2">{{ subject.name }}</h5>
                                    <p class="text-xs text-secondary-600 mb-2">{{ subject.grade_level || 'Forms 1-4' }}</p>
                                    <p class="text-xs text-secondary-500 mb-3">{{ subject.department }}</p>
                                    <div v-if="selectedSubjects.some(s => s.id === subject.id)" class="mt-2">
                                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-primary-100 text-primary-800">
                                            ✓ Selected
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Selection Summary -->
                        <div v-if="selectedSubjects.length > 0" class="bg-secondary-50 p-6 rounded-xl border">
                            <h5 class="font-semibold text-secondary-900 mb-4">Selected Subjects ({{ selectedSubjects.length }})</h5>
                            <div class="flex flex-wrap gap-2 mb-4">
                                <span v-for="subject in selectedSubjects" :key="subject.id" 
                                      class="inline-flex items-center px-3 py-2 rounded-full text-sm bg-primary-100 text-primary-800">
                                    {{ subject.icon || '📚' }} {{ subject.name }}
                                    <button type="button" @click="toggleSubjectSelection(subject)" class="ml-2 hover:text-primary-600 font-bold">×</button>
                                </span>
                            </div>
                            
                            <!-- Cost Summary -->
                            <div class="bg-white p-4 rounded-lg">
                                <div class="flex justify-between items-center mb-2">
                                    <span class="font-medium text-secondary-700">Selected Subjects:</span>
                                    <span class="font-semibold">{{ selectedSubjects.length }}</span>
                                </div>
                                <div v-if="enrollmentForm.enrollment_type === 'paid'" class="flex justify-between items-center mb-2">
                                    <span class="font-medium text-secondary-700">Price per Subject:</span>
                                    <span class="font-semibold">{{ getCurrencyInfo(selectedRegion).symbol }}{{ getCurrencyInfo(selectedRegion).price.toLocaleString() }}</span>
                                </div>
                                <div class="flex justify-between items-center mb-2">
                                    <span class="font-medium text-secondary-700">Access Duration:</span>
                                    <span class="font-semibold">{{ enrollmentForm.enrollment_type === 'trial' ? '7 days' : '4 months' }}</span>
                                </div>
                                <div class="border-t pt-3 flex justify-between items-center text-lg font-bold">
                                    <span class="text-secondary-700">Total Amount:</span>
                                    <span :class="enrollmentForm.enrollment_type === 'trial' ? 'text-green-600' : 'text-primary-600'">
                                        {{ enrollmentForm.enrollment_type === 'trial' ? 'FREE' : `${getCurrencyInfo(selectedRegion).symbol}${getTotalAmount().toLocaleString()} ${getCurrencyInfo(selectedRegion).currency}` }}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Step 2: Personal Information & Verification -->
                <div v-show="enrollmentStep === 2" class="space-y-8">
                    <div class="text-center mb-8">
                        <h3 class="text-2xl font-semibold text-secondary-900 mb-3">Your Information</h3>
                        <p class="text-secondary-600">Provide your details for account creation and verification</p>
                    </div>
                    
                    <!-- Verification Notice -->
                    <div class="bg-amber-50 border border-amber-200 p-6 rounded-xl">
                        <div class="flex items-start space-x-3">
                            <div class="text-amber-500 mt-1">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10"/>
                                    <line x1="12" y1="8" x2="12" y2="12"/>
                                    <line x1="12" y1="16" x2="12.01" y2="16"/>
                                </svg>
                            </div>
                            <div>
                                <h5 class="font-semibold text-amber-800 mb-2">Email & Phone Verification Required</h5>
                                <p class="text-sm text-amber-700">To prevent fake registrations and ensure security, we will verify both your email address and phone number during enrollment. You'll receive verification codes after submitting this form.</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Personal Information Form -->
                    <div class="grid md:grid-cols-2 gap-6">
                        <div>
                            <label class="form-label">Full Name *</label>
                            <input v-model="enrollmentForm.name" type="text" class="form-input" required placeholder="Enter your full legal name">
                            <p class="text-xs text-secondary-600 mt-1">As it appears on your identification</p>
                        </div>
                        <div>
                            <label class="form-label">Email Address *</label>
                            <input v-model="enrollmentForm.email" type="email" class="form-input" required placeholder="your@email.com">
                            <p class="text-xs text-secondary-600 mt-1">Verification email will be sent here</p>
                        </div>
                        <div>
                            <label class="form-label">Phone Number *</label>
                            <input v-model="enrollmentForm.phone" type="tel" class="form-input" required placeholder="+265 123 456 789">
                            <p class="text-xs text-secondary-600 mt-1">SMS verification code will be sent</p>
                        </div>
                        <div>
                            <label class="form-label">Country/Location *</label>
                            <select v-model="enrollmentForm.country" @change="updateCurrencyBasedOnCountry" class="form-input" required>
                                <option value="">Select your country</option>
                                <option value="Malawi">🇲🇼 Malawi</option>
                                <option value="South Africa">🇿🇦 South Africa</option>
                                <option value="United Kingdom">🇬🇧 United Kingdom</option>
                                <option value="United States">🇺🇸 United States</option>
                                <option value="Canada">🇨🇦 Canada</option>
                                <option value="Australia">🇦🇺 Australia</option>
                                <option value="Other">🌍 Other</option>
                            </select>
                            <p class="text-xs text-secondary-600 mt-1">Determines your currency and payment methods</p>
                        </div>
                        <div class="md:col-span-2">
                            <label class="form-label">Address (Optional)</label>
                            <textarea v-model="enrollmentForm.address" class="form-input" rows="2" placeholder="Your current address"></textarea>
                        </div>
                    </div>
                    
                    <!-- Current Selection Summary -->
                    <div class="bg-blue-50 p-6 rounded-xl border border-blue-200">
                        <h5 class="font-semibold text-blue-900 mb-3">Enrollment Summary</h5>
                        <div class="grid md:grid-cols-2 gap-4 text-sm">
                            <div>
                                <p class="text-blue-700 mb-1"><strong>Enrollment Type:</strong></p>
                                <p class="text-blue-600">{{ enrollmentForm.enrollment_type === 'trial' ? '🎯 7-Day Free Trial' : '📚 4-Month Full Access' }}</p>
                            </div>
                            <div>
                                <p class="text-blue-700 mb-1"><strong>Subjects Selected:</strong></p>
                                <p class="text-blue-600">{{ selectedSubjects.length }} subjects</p>
                            </div>
                            <div>
                                <p class="text-blue-700 mb-1"><strong>Total Cost:</strong></p>
                                <p class="text-blue-600 font-semibold">{{ enrollmentForm.enrollment_type === 'trial' ? 'FREE' : `${getCurrencyInfo(selectedRegion).symbol}${getTotalAmount().toLocaleString()}` }}</p>
                            </div>
                            <div>
                                <p class="text-blue-700 mb-1"><strong>Access Duration:</strong></p>
                                <p class="text-blue-600">{{ enrollmentForm.enrollment_type === 'trial' ? '7 days' : '4 months' }}</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Step 3: Payment (Only for paid enrollment) -->
                <div v-show="enrollmentStep === 3 && enrollmentForm.enrollment_type === 'paid'" class="space-y-8">
                    <div class="text-center mb-8">
                        <h3 class="text-2xl font-semibold text-secondary-900 mb-3">Payment & Verification</h3>
                        <p class="text-secondary-600">Complete your enrollment with payment verification</p>
                    </div>
                    
                    <!-- Payment Summary -->
                    <div class="bg-gradient-to-r from-primary-50 to-accent-50 p-8 rounded-2xl border">
                        <h4 class="font-bold text-secondary-900 mb-6 text-center text-xl">Payment Summary</h4>
                        <div class="grid md:grid-cols-2 gap-6">
                            <div class="space-y-3">
                                <div class="flex justify-between">
                                    <span class="text-secondary-700">Selected Subjects:</span>
                                    <span class="font-semibold">{{ selectedSubjects.length }}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-secondary-700">Price per Subject:</span>
                                    <span class="font-semibold">{{ getCurrencyInfo(selectedRegion).symbol }}{{ getCurrencyInfo(selectedRegion).price.toLocaleString() }} {{ getCurrencyInfo(selectedRegion).currency }}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-secondary-700">Access Duration:</span>
                                    <span class="font-semibold">4 months (120 days)</span>
                                </div>
                            </div>
                            <div class="bg-white p-6 rounded-xl border">
                                <div class="text-center">
                                    <p class="text-secondary-600 mb-2">Total Amount Due</p>
                                    <p class="text-3xl font-bold text-primary-600">{{ getCurrencyInfo(selectedRegion).symbol }}{{ getTotalAmount().toLocaleString() }}</p>
                                    <p class="text-sm text-secondary-500">{{ getCurrencyInfo(selectedRegion).currency }}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Payment Method Selection -->
                    <div>
                        <label class="form-label">Payment Method *</label>
                        <div class="grid md:grid-cols-2 gap-4 mt-3">
                            <div v-if="enrollmentForm.country === 'Malawi'" class="space-y-3">
                                <div :class="['border-2 rounded-xl p-4 cursor-pointer transition-all', enrollmentForm.payment_method_id === '1' ? 'border-primary-500 bg-primary-50' : 'border-gray-200 hover:border-primary-300']" @click="enrollmentForm.payment_method_id = '1'">
                                    <div class="flex items-center">
                                        <input type="radio" v-model="enrollmentForm.payment_method_id" value="1" class="mr-3">
                                        <div>
                                            <h5 class="font-semibold">Airtel Money</h5>
                                            <p class="text-sm text-secondary-600">Pay via Airtel Money</p>
                                        </div>
                                    </div>
                                </div>
                                <div :class="['border-2 rounded-xl p-4 cursor-pointer transition-all', enrollmentForm.payment_method_id === '2' ? 'border-primary-500 bg-primary-50' : 'border-gray-200 hover:border-primary-300']" @click="enrollmentForm.payment_method_id = '2'">
                                    <div class="flex items-center">
                                        <input type="radio" v-model="enrollmentForm.payment_method_id" value="2" class="mr-3">
                                        <div>
                                            <h5 class="font-semibold">TNM Mpamba</h5>
                                            <p class="text-sm text-secondary-600">Pay via TNM Mpamba</p>
                                        </div>
                                    </div>
                                </div>
                                <div :class="['border-2 rounded-xl p-4 cursor-pointer transition-all', enrollmentForm.payment_method_id === '3' ? 'border-primary-500 bg-primary-50' : 'border-gray-200 hover:border-primary-300']" @click="enrollmentForm.payment_method_id = '3'">
                                    <div class="flex items-center">
                                        <input type="radio" v-model="enrollmentForm.payment_method_id" value="3" class="mr-3">
                                        <div>
                                            <h5 class="font-semibold">Bank Transfer</h5>
                                            <p class="text-sm text-secondary-600">Direct bank transfer</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div v-else class="text-center p-8">
                                <p class="text-secondary-600 mb-4">Payment methods will be shown based on your selected country.</p>
                                <p class="text-sm text-secondary-500">Please select your country in the previous step.</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Payment Instructions -->
                    <div class="bg-blue-50 p-6 rounded-xl border border-blue-200">
                        <h5 class="font-semibold text-blue-800 mb-4 flex items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                                <circle cx="12" cy="12" r="10"/>
                                <path d="M16 12l-4-4-4 4"/>
                                <path d="M12 16V8"/>
                            </svg>
                            Payment Instructions
                        </h5>
                        <ol class="text-sm text-blue-700 space-y-2 list-decimal list-inside">
                            <li>Make payment using your selected payment method above</li>
                            <li>Enter the exact transaction reference number you receive</li>
                            <li>Upload clear proof of payment (screenshot or receipt)</li>
                            <li>Submit for verification - processing takes up to 24 hours</li>
                            <li>You'll receive email and SMS confirmation once approved</li>
                        </ol>
                    </div>
                    
                    <!-- Payment Verification Form -->
                    <div class="grid md:grid-cols-2 gap-6">
                        <div>
                            <label class="form-label">Payment Reference Number *</label>
                            <input v-model="enrollmentForm.payment_reference" type="text" class="form-input" required placeholder="e.g., TXN123456789">
                            <p class="text-xs text-secondary-600 mt-1">Exactly as shown in your payment confirmation</p>
                        </div>
                        <div>
                            <label class="form-label">Upload Payment Proof *</label>
                            <input type="file" @input="enrollmentForm.payment_proof = $event.target.files[0]" 
                                   accept=".jpg,.jpeg,.png,.pdf" class="form-input" required>
                            <p class="text-xs text-secondary-600 mt-1">Screenshot or receipt (JPG, PNG, PDF - max 5MB)</p>
                        </div>
                    </div>
                </div>
                
                <!-- Terms and Conditions -->
                <div class="bg-gray-50 p-6 rounded-xl">
                    <div class="flex items-start space-x-3">
                        <input v-model="enrollmentForm.terms_accepted" type="checkbox" class="mt-1 rounded border-secondary-300 text-primary-600 focus:ring-primary-500" required>
                        <div class="text-sm text-secondary-700 leading-relaxed">
                            <p class="mb-2">
                                I agree to StudySeco's 
                                <a href="#" class="text-primary-600 hover:text-primary-700 underline">Terms of Service</a> 
                                and 
                                <a href="#" class="text-primary-600 hover:text-primary-700 underline">Privacy Policy</a>.
                            </p>
                            <p v-if="enrollmentForm.enrollment_type === 'trial'" class="text-green-600">
                                ✓ I understand my <strong>7-day free trial</strong> begins immediately upon email/phone verification.
                            </p>
                            <p v-else class="text-blue-600">
                                ✓ I understand my <strong>4-month access</strong> begins after payment verification and account creation.
                            </p>
                        </div>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="flex gap-4 pt-6">
                    <button type="button" @click="enrollmentStep > 1 ? prevEnrollmentStep() : (showEnrollmentModal = false)" 
                            class="btn-secondary flex-1 py-3 text-lg">
                        {{ enrollmentStep > 1 ? '← Previous' : 'Cancel' }}
                    </button>
                    
                    <button v-if="enrollmentStep < 2 || (enrollmentStep < 3 && enrollmentForm.enrollment_type === 'paid')"
                            type="button" @click="nextEnrollmentStep" class="btn-primary flex-1 py-3 text-lg font-semibold">
                        Continue →
                    </button>
                    
                    <button v-else type="submit" :disabled="enrollmentForm.processing" class="btn-primary flex-1 py-3 text-lg font-semibold">
                        <span v-if="enrollmentForm.processing">
                            <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white inline" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                            Processing...
                        </span>
                        <span v-else-if="enrollmentForm.enrollment_type === 'trial'">🎯 Start Free Trial</span>
                        <span v-else>💳 Submit for Payment Verification</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Chat Modal -->
    <div v-if="showChatModal" class="fixed inset-0 z-50 pointer-events-none">
        <div class="absolute bottom-20 right-6 w-96 h-96 pointer-events-auto">
            <div class="modal-content w-full h-full flex flex-col">
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
            
            <div class="text-center mb-8">
                <div class="w-20 h-20 rounded-full bg-yellow-100 flex items-center justify-center mx-auto mb-4">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-yellow-600">
                        <path d="M12 9v4l2 2"/>
                        <circle cx="12" cy="12" r="10"/>
                    </svg>
                </div>
                <h3 class="text-xl font-semibold text-secondary-900 mb-2">Enrollment Required</h3>
                <p class="text-secondary-600 mb-6">Please enroll in our program to access learning resources including digital library, video lessons, practice tests, and study groups.</p>
                <button @click="showLibraryModal = false; toggleEnrollmentModal()" class="btn-primary px-8 py-3">
                    Enroll Now to Access Resources
                </button>
            </div>
            
            <div class="grid md:grid-cols-2 gap-6 opacity-50 pointer-events-none">
                <div class="card p-6">
                    <h3 class="font-semibold text-secondary-900 mb-4">📚 Digital Library</h3>
                    <p class="text-secondary-600 mb-4">Access textbooks, references, and study materials for all subjects.</p>
                    <button class="btn-secondary w-full">Browse Library</button>
                </div>
                
                <div class="card p-6">
                    <h3 class="font-semibold text-secondary-900 mb-4">🎥 Video Lessons</h3>
                    <p class="text-secondary-600 mb-4">Watch recorded lessons from our certified teachers anytime.</p>
                    <button class="btn-secondary w-full">Watch Lessons</button>
                </div>
                
                <div class="card p-6">
                    <h3 class="font-semibold text-secondary-900 mb-4">📝 Practice Tests</h3>
                    <p class="text-secondary-600 mb-4">Prepare for MSCE with past papers and practice questions.</p>
                    <button class="btn-secondary w-full">Start Practice</button>
                </div>
                
                <div class="card p-6">
                    <h3 class="font-semibold text-secondary-900 mb-4">👥 Study Groups</h3>
                    <p class="text-secondary-600 mb-4">Connect with other students in virtual study sessions.</p>
                    <button class="btn-secondary w-full">Join Groups</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Subject Enrollment Modal -->
    <div v-if="showSubjectModal" class="modal-overlay flex items-center justify-center p-4" @click.self="showSubjectModal = false">
        <div class="modal-content p-8 max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold text-secondary-900">{{ selectedSubject?.name }}</h2>
                <button @click="showSubjectModal = false" class="p-2 hover:bg-secondary-100 rounded-lg transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"/>
                        <line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                </button>
            </div>
            
            <div class="text-center mb-8">
                <div class="w-24 h-24 rounded-2xl bg-gradient-to-br from-primary-100 to-accent-100 flex items-center justify-center mx-auto mb-4">
                    <span class="text-4xl">{{ selectedSubject?.icon }}</span>
                </div>
                <h3 class="text-xl font-semibold text-secondary-900 mb-2">{{ selectedSubject?.name }}</h3>
                <p class="text-secondary-600 mb-4">{{ selectedSubject?.description }}</p>
                
                <div class="bg-secondary-50 p-6 rounded-xl mb-6">
                    <h4 class="font-semibold text-secondary-900 mb-3">What you'll learn:</h4>
                    <ul class="text-sm text-secondary-700 space-y-2">
                        <li v-if="selectedSubject?.name === 'Mathematics'">• Algebra, geometry, trigonometry, and calculus</li>
                        <li v-if="selectedSubject?.name === 'Mathematics'">• Problem-solving and analytical thinking</li>
                        <li v-if="selectedSubject?.name === 'Mathematics'">• Statistical analysis and data interpretation</li>
                        
                        <li v-if="selectedSubject?.name === 'English Language'">• Advanced grammar and vocabulary</li>
                        <li v-if="selectedSubject?.name === 'English Language'">• Literature analysis and composition</li>
                        <li v-if="selectedSubject?.name === 'English Language'">• Communication and presentation skills</li>
                        
                        <li v-if="selectedSubject?.name === 'Physics'">• Mechanics, electricity, and magnetism</li>
                        <li v-if="selectedSubject?.name === 'Physics'">• Waves, optics, and modern physics</li>
                        <li v-if="selectedSubject?.name === 'Physics'">• Laboratory experiments and practical applications</li>
                        
                        <li v-if="!['Mathematics', 'English Language', 'Physics'].includes(selectedSubject?.name)">• Comprehensive curriculum covering all key topics</li>
                        <li v-if="!['Mathematics', 'English Language', 'Physics'].includes(selectedSubject?.name)">• Interactive lessons with certified teachers</li>
                        <li v-if="!['Mathematics', 'English Language', 'Physics'].includes(selectedSubject?.name)">• Practice exercises and assessments</li>
                    </ul>
                </div>
                
                <div class="text-center">
                    <div class="flex gap-4">
                        <button @click="showSubjectModal = false" class="btn-secondary flex-1">
                            Browse More Subjects
                        </button>
                        <button @click="showSubjectModal = false; toggleEnrollmentModal()" class="btn-primary flex-1">
                            Enroll Now
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>