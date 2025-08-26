<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { onMounted, ref } from 'vue';

const props = defineProps({
    canLogin: {
        type: Boolean,
    },
    canRegister: {
        type: Boolean,
    },
    laravelVersion: {
        type: String,
        required: true,
    },
    phpVersion: {
        type: String,
        required: true,
    },
    subjects: {
        type: Array,
        default: () => []
    },
    studentCount: {
        type: Number,
        default: 500
    },
    testimonials: {
        type: Array,
        default: () => []
    },
    accessDurations: {
        type: Array,
        default: () => []
    },
    studentStories: {
        type: Array,
        default: () => []
    }
});

const navbar = ref(null);
const showEnrollmentModal = ref(false);
const showChatModal = ref(false);
const showLibraryModal = ref(false);
const showChatWidget = ref(false);
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

// Default access durations if none provided
const defaultAccessDurations = [
    { id: 1, name: '6 Months Access', days: 180, price: 50000, description: 'Perfect for semester study' },
    { id: 2, name: '1 Year Access', days: 365, price: 85000, description: 'Full academic year access' },
    { id: 3, name: '2 Years Access', days: 730, price: 150000, description: 'Complete secondary education' }
];

const accessDurations = props.accessDurations.length ? props.accessDurations : defaultAccessDurations;

// Default student stories for slider (fallback)
const defaultSliderStories = [
    {
        id: 1,
        name: 'Temwa Mwale',
        location: 'London, UK',
        country_flag: '🇬🇧',
        current_status: 'University of Edinburgh - Engineering',
        story: 'StudySeco allowed me to complete my Malawian secondary education while living in London. The teachers were incredible, and I passed my MSCE with 6 credits!',
        msce_credits: 6,
        avatar_color_from: 'emerald-500',
        avatar_color_to: 'blue-500',
        achievement_icon: '🎓'
    },
    {
        id: 2,
        name: 'Grace Kachingwe',
        location: 'Toronto, Canada',
        country_flag: '🇨🇦',
        current_status: 'University of Toronto - Medicine',
        story: 'The flexibility of studying online while maintaining the Malawian curriculum was perfect. I achieved my dream of studying medicine in Canada!',
        msce_credits: 8,
        avatar_color_from: 'purple-500',
        avatar_color_to: 'pink-500',
        achievement_icon: '🏆'
    },
    {
        id: 3,
        name: 'James Nyirenda',
        location: 'Sydney, Australia',
        country_flag: '🇦🇺',
        current_status: 'UNSW Sydney - MBA Student',
        story: 'StudySeco prepared me well for university. The quality of education was exceptional, and I\'m now pursuing my MBA while working in Sydney.',
        msce_credits: 7,
        avatar_color_from: 'orange-500',
        avatar_color_to: 'red-500',
        achievement_icon: '💼'
    }
];

const sliderStories = props.studentStories.length ? props.studentStories : defaultSliderStories;

const calculateTotal = () => {
    const selectedDuration = accessDurations.find(d => d.id == enrollmentForm.access_duration_id);
    if (!selectedDuration) return 0;
    return enrollmentForm.selected_subjects.length * selectedDuration.price;
};

const getSelectedDuration = () => {
    return accessDurations.find(d => d.id == enrollmentForm.access_duration_id);
};

const toggleSubject = (subjectId) => {
    const index = enrollmentForm.selected_subjects.indexOf(subjectId);
    if (index === -1) {
        enrollmentForm.selected_subjects.push(subjectId);
    } else {
        enrollmentForm.selected_subjects.splice(index, 1);
    }
};

const handlePaymentProofUpload = (event) => {
    enrollmentForm.payment_proof = event.target.files[0];
};

const submitEnrollment = () => {
    enrollmentForm.post('/enroll', {
        onSuccess: () => {
            showEnrollmentModal.value = false;
        }
    });
};

// Chatbot functionality
const sendMessage = async () => {
    if (!newMessage.value.trim()) return;
    
    const userMessage = newMessage.value.trim();
    chatMessages.value.push({
        type: 'user',
        message: userMessage,
        timestamp: new Date()
    });
    
    newMessage.value = '';
    isTyping.value = true;
    
    // Simulate bot response delay
    setTimeout(() => {
        const botResponse = getBotResponse(userMessage);
        chatMessages.value.push({
            type: 'bot',
            message: botResponse,
            timestamp: new Date()
        });
        isTyping.value = false;
    }, 1500);
};

const getBotResponse = (message) => {
    const msg = message.toLowerCase();
    
    if (msg.includes('price') || msg.includes('cost') || msg.includes('fee')) {
        return "Our subjects are competitively priced with flexible payment options. Click 'Enroll Now' to see detailed pricing and access durations! 💰";
    } else if (msg.includes('subject') || msg.includes('course')) {
        return "We offer all MANEB-certified subjects including Mathematics, English, Sciences, and more! Each subject is taught by qualified Malawian teachers. 📚";
    } else if (msg.includes('enroll') || msg.includes('join') || msg.includes('register')) {
        return "Great! You can enroll by clicking the 'Enroll Now' button. You'll be able to select your subjects, choose payment methods, and get started immediately! 🚀";
    } else if (msg.includes('teacher') || msg.includes('instructor')) {
        return "Our teachers are qualified professionals from top Malawian secondary schools with years of experience. They provide personalized attention to each student! 👨‍🏫";
    } else if (msg.includes('certificate') || msg.includes('qualification')) {
        return "Yes! Our courses are MANEB-certified and globally recognized. Students receive official certificates upon completion. 🏆";
    } else if (msg.includes('support') || msg.includes('help')) {
        return "We offer 24/7 student support through live chat, email, and phone. Our support team is always ready to help! 💬";
    } else if (msg.includes('hello') || msg.includes('hi') || msg.includes('hey')) {
        return "Hello! 😊 I'm here to help you with any questions about StudySeco. Feel free to ask about our courses, enrollment, or anything else!";
    } else {
        return "That's a great question! For detailed information, you can explore our website or contact our live support team. Is there anything specific about our courses I can help you with? 🤔";
    }
};

// Default subjects if none provided
const defaultSubjects = [
    { id: 1, name: 'English Language', description: 'Communication skills, literature, and composition', icon: '📚', type: 'core' },
    { id: 2, name: 'Mathematics', description: 'Algebra, geometry, statistics, and applied mathematics', icon: '📐', type: 'core' },
    { id: 3, name: 'Physical Science', description: 'Physics and chemistry fundamentals', icon: '⚗️', type: 'core' },
    { id: 4, name: 'Social Studies', description: 'History, geography, civics, and current affairs', icon: '🌍', type: 'core' },
    { id: 5, name: 'Computer Studies', description: 'Programming, hardware, and software applications', icon: '💻', type: 'core' },
    { id: 6, name: 'Creative Arts', description: 'Visual arts, music, drama, and creative expression', icon: '🎨', type: 'core' },
    { id: 7, name: 'Biology', description: 'Living organisms, ecology, and human biology', icon: '🧬', type: 'optional' },
    { id: 8, name: 'Chemistry', description: 'Chemical reactions, elements, and compounds', icon: '🧪', type: 'optional' },
    { id: 9, name: 'Physics', description: 'Motion, energy, electricity, and modern physics', icon: '⚡', type: 'optional' },
    { id: 10, name: 'Geography', description: 'Physical and human geography', icon: '🗺️', type: 'optional' },
    { id: 11, name: 'History', description: 'Malawian history, African history, and world history', icon: '🏛️', type: 'optional' },
    { id: 12, name: 'Business Studies', description: 'Principles of management, accounting, and commerce', icon: '💼', type: 'optional' }
];

// Default testimonials if none provided
const defaultTestimonials = [
    {
        name: 'Sarah Phiri',
        location: 'London, UK',
        message: 'StudySeco helped me maintain my connection to Malawian education while living abroad. The teachers are excellent!',
        rating: 5,
        avatar: 'SP'
    },
    {
        name: 'John Mwale',
        location: 'Cape Town, South Africa',
        message: 'The MANEB curriculum alignment is perfect. My son passed his MSCE with flying colors thanks to StudySeco.',
        rating: 5,
        avatar: 'JM'
    },
    {
        name: 'Grace Banda',
        location: 'Toronto, Canada',
        message: 'Flexible scheduling allowed me to study while working. The online library is incredibly comprehensive.',
        rating: 5,
        avatar: 'GB'
    }
];

const subjects = props.subjects.length ? props.subjects : defaultSubjects;
const testimonials = props.testimonials.length ? props.testimonials : defaultTestimonials;

onMounted(() => {
    // Scroll reveal effect
    const revealElements = document.querySelectorAll('.reveal');
    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                observer.unobserve(entry.target);
            }
        });
    }, {
        rootMargin: '0px 0px -50px 0px'
    });

    revealElements.forEach(el => observer.observe(el));

    // Floating particles
    const particlesContainer = document.getElementById('particles');
    if (particlesContainer) {
        const particleCount = 30;
        for (let i = 0; i < particleCount; i++) {
            const particle = document.createElement('div');
            particle.classList.add('particle');
            const x = Math.random() * 100;
            const y = Math.random() * 100;
            const size = Math.random() * 3 + 2;
            const delay = Math.random() * 10;
            const duration = Math.random() * 10 + 8;
            particle.style.left = `${x}vw`;
            particle.style.top = `${y}vh`;
            particle.style.width = `${size}px`;
            particle.style.height = `${size}px`;
            particle.style.animationDelay = `-${delay}s`;
            particle.style.animationDuration = `${duration}s`;
            particlesContainer.appendChild(particle);
        }
    }

    // Navbar shrink on scroll
    window.addEventListener('scroll', () => {
        if (navbar.value) {
            if (window.scrollY > 50) {
                navbar.value.classList.add('scrolled');
            } else {
                navbar.value.classList.remove('scrolled');
            }
        }
    });

    // Student Slider functionality
    let currentSlide = 0;
    const slides = document.querySelectorAll('.slide');
    const totalSlides = slides.length;
    const slidesContainer = document.getElementById('studentSlides');
    const slideDots = document.querySelectorAll('.slide-dot');

    function updateSlider() {
        if (slidesContainer) {
            slidesContainer.style.transform = `translateX(-${currentSlide * 100}%)`;
        }
        
        // Update dots
        slideDots.forEach((dot, index) => {
            dot.classList.remove('bg-emerald-500');
            dot.classList.add('bg-gray-300');
            if (index === currentSlide) {
                dot.classList.add('bg-emerald-500');
                dot.classList.remove('bg-gray-300');
            }
        });
    }

    function nextSlide() {
        currentSlide = (currentSlide + 1) % totalSlides;
        updateSlider();
    }

    function prevSlide() {
        currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
        updateSlider();
    }

    function goToSlide(slideIndex) {
        currentSlide = slideIndex;
        updateSlider();
    }

    // Add event listeners
    const nextBtn = document.getElementById('nextSlide');
    const prevBtn = document.getElementById('prevSlide');
    
    if (nextBtn) nextBtn.addEventListener('click', nextSlide);
    if (prevBtn) prevBtn.addEventListener('click', prevSlide);

    // Dot navigation
    slideDots.forEach((dot, index) => {
        dot.addEventListener('click', () => goToSlide(index));
    });

    // Auto-slide every 8 seconds
    setInterval(nextSlide, 8000);

    // Hero Image Slider functionality
    let currentHeroSlide = 0;
    const heroImageSlides = document.querySelectorAll('.hero-image-slide');
    const totalHeroSlides = heroImageSlides.length;
    const heroImageSlidesContainer = document.getElementById('heroImageSlides');
    const heroImageDots = document.querySelectorAll('.hero-image-dot');

    function updateHeroImageSlider() {
        if (heroImageSlidesContainer) {
            heroImageSlidesContainer.style.transform = `translateX(-${currentHeroSlide * 100}%)`;
        }
        
        // Update dots
        heroImageDots.forEach((dot, index) => {
            dot.classList.remove('bg-white/80');
            dot.classList.add('bg-white/40');
            if (index === currentHeroSlide) {
                dot.classList.add('bg-white/80');
                dot.classList.remove('bg-white/40');
            }
        });
    }

    function nextHeroImageSlide() {
        currentHeroSlide = (currentHeroSlide + 1) % totalHeroSlides;
        updateHeroImageSlider();
    }

    function prevHeroImageSlide() {
        currentHeroSlide = (currentHeroSlide - 1 + totalHeroSlides) % totalHeroSlides;
        updateHeroImageSlider();
    }

    function goToHeroSlide(slideIndex) {
        currentHeroSlide = slideIndex;
        updateHeroImageSlider();
    }

    // Hero image slider navigation
    const nextHeroBtn = document.getElementById('nextHeroSlide');
    const prevHeroBtn = document.getElementById('prevHeroSlide');
    
    if (nextHeroBtn) nextHeroBtn.addEventListener('click', nextHeroImageSlide);
    if (prevHeroBtn) prevHeroBtn.addEventListener('click', prevHeroImageSlide);

    // Hero dot navigation
    heroImageDots.forEach((dot, index) => {
        dot.addEventListener('click', () => goToHeroSlide(index));
    });

    // Auto-slide hero every 5 seconds
    setInterval(nextHeroImageSlide, 5000);
});
</script>

<template>
    <Head title="StudySeco - Complete Malawi Secondary Education Online" />

    <div id="particles" class="particles"></div>

    <!-- Navigation -->
    <nav ref="navbar" class="fixed top-0 w-full z-50 transition-all duration-300 bg-white/90 backdrop-blur-lg border-b border-gray-200/50 shadow-sm">
        <div class="max-w-7xl mx-auto px-6">
            <div class="flex items-center justify-between h-16">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 rounded-xl bg-gradient-to-r from-emerald-500 to-blue-500 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                            <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                        </svg>
                    </div>
                    <span class="text-xl font-bold bg-gradient-to-r from-emerald-600 to-blue-600 bg-clip-text text-transparent">StudySeco</span>
                </div>

                <div class="hidden md:flex items-center space-x-8">
                    <a href="#home" class="text-gray-700 hover:text-emerald-600 transition-colors duration-300 font-medium">Home</a>
                    <a href="#about" class="text-gray-700 hover:text-emerald-600 transition-colors duration-300 font-medium">About</a>
                    <a href="#subjects" class="text-gray-700 hover:text-emerald-600 transition-colors duration-300 font-medium">Subjects</a>
                    <button @click="showLibraryModal = true" class="text-gray-700 hover:text-emerald-600 transition-colors duration-300 font-medium">Library</button>
                    <button @click="showChatModal = true" class="text-gray-700 hover:text-emerald-600 transition-colors duration-300 font-medium">Student Chat</button>
                </div>

                <div class="flex items-center space-x-4" v-if="canLogin">
                    <Link
                        v-if="$page.props.auth.user"
                        :href="route('dashboard')"
                        class="px-6 py-2 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full hover:shadow-lg transition-all duration-300 font-medium"
                    >
                        Dashboard
                    </Link>
                    <template v-else>
                        <Link
                            :href="route('login')"
                            class="px-6 py-2 text-gray-700 hover:text-emerald-600 transition-colors duration-300 font-medium"
                        >
                            Login
                        </Link>
                        <button
                            @click="showEnrollmentModal = true"
                            class="px-6 py-2 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full hover:shadow-lg transition-all duration-300 font-medium"
                        >
                            Enroll Now
                        </button>
                    </template>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="min-h-screen flex items-center justify-center relative overflow-hidden bg-gradient-to-br from-blue-50 via-white to-emerald-50">
        <!-- Floating decorations -->
        <div class="absolute top-20 left-10 w-20 h-20 bg-emerald-100 rounded-full opacity-40 animate-pulse"></div>
        <div class="absolute top-40 right-20 w-32 h-32 bg-blue-100 rounded-full opacity-40 animate-pulse" style="animation-delay: -2s;"></div>
        <div class="absolute bottom-20 left-20 w-16 h-16 bg-purple-100 rounded-full opacity-40 animate-pulse" style="animation-delay: -4s;"></div>

        <div class="relative z-10 max-w-7xl mx-auto px-6 text-center pt-16">
            <div class="space-y-8 reveal">
                <div class="inline-flex items-center px-4 py-2 rounded-full bg-white/80 backdrop-blur border border-emerald-200 text-sm font-medium">
                    <span class="w-2 h-2 bg-emerald-500 rounded-full mr-2 animate-pulse"></span>
                    Malawi Secondary School Online - Serving {{ studentCount }}+ Global Students
                </div>

                <!-- Main Title -->
                <h1 class="hero-title text-5xl md:text-7xl font-black leading-tight mb-8">
                    <span class="text-gray-900">
                        Complete Malawi
                    </span>
                    <br>
                    <span class="bg-gradient-to-r from-emerald-600 to-blue-600 bg-clip-text text-transparent">
                        Secondary Education
                    </span>
                </h1>

                <!-- Hero Image Slider -->
                <div class="hero-image-slider relative overflow-hidden rounded-3xl shadow-2xl mb-8 max-w-4xl mx-auto">
                    <div class="hero-image-slides flex transition-transform duration-1000 ease-in-out" id="heroImageSlides">
                        <!-- Slide 1: Students studying -->
                        <div class="hero-image-slide w-full flex-shrink-0 relative">
                            <div class="aspect-[16/9] bg-gradient-to-br from-emerald-100 to-blue-100 rounded-3xl overflow-hidden">
                                <!-- Placeholder for student studying image -->
                                <div class="absolute inset-0 bg-gradient-to-br from-emerald-500/20 to-blue-500/20"></div>
                                <div class="absolute inset-0 flex items-center justify-center">
                                    <div class="text-center text-gray-700">
                                        <div class="w-32 h-32 mx-auto mb-4 bg-emerald-100 rounded-full flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="text-emerald-600">
                                                <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                                                <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                                            </svg>
                                        </div>
                                        <h3 class="text-2xl font-bold mb-2">MANEB Certified Education</h3>
                                        <p class="text-lg">Quality Malawian curriculum taught by qualified teachers</p>
                                    </div>
                                </div>
                                <div class="absolute top-4 left-4 bg-white/90 backdrop-blur rounded-full px-4 py-2">
                                    <span class="text-emerald-600 font-semibold text-sm">📚 Form 1-4 Complete</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Slide 2: Global students -->
                        <div class="hero-image-slide w-full flex-shrink-0 relative">
                            <div class="aspect-[16/9] bg-gradient-to-br from-blue-100 to-purple-100 rounded-3xl overflow-hidden">
                                <div class="absolute inset-0 bg-gradient-to-br from-blue-500/20 to-purple-500/20"></div>
                                <div class="absolute inset-0 flex items-center justify-center">
                                    <div class="text-center text-gray-700">
                                        <div class="w-32 h-32 mx-auto mb-4 bg-blue-100 rounded-full flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="text-blue-600">
                                                <circle cx="12" cy="12" r="10"/>
                                                <path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"/>
                                                <path d="M2 12h20"/>
                                            </svg>
                                        </div>
                                        <h3 class="text-2xl font-bold mb-2">Global Learning Community</h3>
                                        <p class="text-lg">Join students from 25+ countries worldwide</p>
                                    </div>
                                </div>
                                <div class="absolute top-4 left-4 bg-white/90 backdrop-blur rounded-full px-4 py-2">
                                    <span class="text-blue-600 font-semibold text-sm">🌍 25+ Countries</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Slide 3: Online learning -->
                        <div class="hero-image-slide w-full flex-shrink-0 relative">
                            <div class="aspect-[16/9] bg-gradient-to-br from-purple-100 to-emerald-100 rounded-3xl overflow-hidden">
                                <div class="absolute inset-0 bg-gradient-to-br from-purple-500/20 to-emerald-500/20"></div>
                                <div class="absolute inset-0 flex items-center justify-center">
                                    <div class="text-center text-gray-700">
                                        <div class="w-32 h-32 mx-auto mb-4 bg-purple-100 rounded-full flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="text-purple-600">
                                                <rect x="2" y="3" width="20" height="14" rx="2" ry="2"/>
                                                <line x1="8" y1="21" x2="16" y2="21"/>
                                                <line x1="12" y1="17" x2="12" y2="21"/>
                                                <path d="M7 11l3 3 6-6"/>
                                            </svg>
                                        </div>
                                        <h3 class="text-2xl font-bold mb-2">Flexible Online Learning</h3>
                                        <p class="text-lg">Study at your own pace, anywhere in the world</p>
                                    </div>
                                </div>
                                <div class="absolute top-4 left-4 bg-white/90 backdrop-blur rounded-full px-4 py-2">
                                    <span class="text-purple-600 font-semibold text-sm">💻 24/7 Access</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Slide 4: Success stories -->
                        <div class="hero-image-slide w-full flex-shrink-0 relative">
                            <div class="aspect-[16/9] bg-gradient-to-br from-orange-100 to-red-100 rounded-3xl overflow-hidden">
                                <div class="absolute inset-0 bg-gradient-to-br from-orange-500/20 to-red-500/20"></div>
                                <div class="absolute inset-0 flex items-center justify-center">
                                    <div class="text-center text-gray-700">
                                        <div class="w-32 h-32 mx-auto mb-4 bg-orange-100 rounded-full flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="text-orange-600">
                                                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                                            </svg>
                                        </div>
                                        <h3 class="text-2xl font-bold mb-2">Proven Success</h3>
                                        <p class="text-lg">98% MSCE pass rate with excellent grades</p>
                                    </div>
                                </div>
                                <div class="absolute top-4 left-4 bg-white/90 backdrop-blur rounded-full px-4 py-2">
                                    <span class="text-orange-600 font-semibold text-sm">🏆 98% Pass Rate</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Hero Image Slider Navigation -->
                    <div class="absolute bottom-4 left-1/2 transform -translate-x-1/2">
                        <div class="flex space-x-2">
                            <button class="hero-image-dot w-3 h-3 bg-white/80 rounded-full transition-all duration-300 backdrop-blur" data-hero-slide="0"></button>
                            <button class="hero-image-dot w-3 h-3 bg-white/40 rounded-full transition-all duration-300 hover:bg-white/60 backdrop-blur" data-hero-slide="1"></button>
                            <button class="hero-image-dot w-3 h-3 bg-white/40 rounded-full transition-all duration-300 hover:bg-white/60 backdrop-blur" data-hero-slide="2"></button>
                            <button class="hero-image-dot w-3 h-3 bg-white/40 rounded-full transition-all duration-300 hover:bg-white/60 backdrop-blur" data-hero-slide="3"></button>
                        </div>
                    </div>

                    <!-- Slider Navigation Arrows -->
                    <button id="prevHeroSlide" class="absolute left-4 top-1/2 transform -translate-y-1/2 w-10 h-10 bg-white/80 backdrop-blur rounded-full flex items-center justify-center hover:bg-white transition-all duration-300 shadow-lg">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-gray-600">
                            <path d="M15 18l-6-6 6-6"/>
                        </svg>
                    </button>
                    <button id="nextHeroSlide" class="absolute right-4 top-1/2 transform -translate-y-1/2 w-10 h-10 bg-white/80 backdrop-blur rounded-full flex items-center justify-center hover:bg-white transition-all duration-300 shadow-lg">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-gray-600">
                            <path d="M9 18l6-6-6-6"/>
                        </svg>
                    </button>
                </div>

                <p class="hero-subtitle text-xl md:text-2xl text-gray-600 max-w-4xl mx-auto font-light leading-relaxed">
                    Study all Form 1-4 subjects with qualified teachers, flexible schedules, and globally recognized qualifications. Quality education accessible worldwide.
                </p>

                <div class="flex flex-wrap justify-center gap-4 text-sm">
                    <span class="px-4 py-2 bg-blue-100 text-blue-800 rounded-full border border-blue-200 font-medium">🇲🇼 MANEB Certified</span>
                    <span class="px-4 py-2 bg-emerald-100 text-emerald-800 rounded-full border border-emerald-200 font-medium">🌍 {{ studentCount }}+ Students</span>
                    <span class="px-4 py-2 bg-cyan-100 text-cyan-800 rounded-full border border-cyan-200 font-medium">📚 12+ Subjects</span>
                    <span class="px-4 py-2 bg-purple-100 text-purple-800 rounded-full border border-purple-200 font-medium">🎓 Flexible Learning</span>
                </div>

                <div class="flex flex-col sm:flex-row items-center justify-center gap-6 pt-8">
                    <button
                        @click="showEnrollmentModal = true"
                        class="group relative px-8 py-4 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full font-semibold text-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
                    >
                        Start Your Education Journey
                    </button>
                    <button @click="showChatModal = true" class="group px-8 py-4 border-2 border-gray-300 text-gray-700 rounded-full font-semibold text-lg hover:border-emerald-500 hover:text-emerald-600 transition-all duration-300">
                        <span class="flex items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                            </svg>
                            Live Support Chat
                        </span>
                    </button>
                </div>

                <div class="grid grid-cols-2 md:grid-cols-4 gap-8 pt-16">
                    <div class="text-center">
                        <div class="text-3xl font-bold bg-gradient-to-r from-emerald-600 to-blue-600 bg-clip-text text-transparent">{{ studentCount }}+</div>
                        <div class="text-gray-500 text-sm">Enrolled Students</div>
                    </div>
                    <div class="text-center">
                        <div class="text-3xl font-bold bg-gradient-to-r from-blue-600 to-cyan-600 bg-clip-text text-transparent">98%</div>
                        <div class="text-gray-500 text-sm">MSCE Pass Rate</div>
                    </div>
                    <div class="text-center">
                        <div class="text-3xl font-bold bg-gradient-to-r from-cyan-600 to-purple-600 bg-clip-text text-transparent">25+</div>
                        <div class="text-gray-500 text-sm">Countries Served</div>
                    </div>
                    <div class="text-center">
                        <div class="text-3xl font-bold bg-gradient-to-r from-purple-600 to-emerald-600 bg-clip-text text-transparent">12</div>
                        <div class="text-gray-500 text-sm">Core Subjects</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section id="about" class="py-24 bg-white relative">
        <div class="max-w-7xl mx-auto px-6">
            <div class="grid lg:grid-cols-2 gap-16 items-center">
                <div class="reveal">
                    <h2 class="text-5xl font-bold mb-8">
                        <span class="text-gray-900">
                            Bringing Malawi Education
                        </span>
                        <br>
                        <span class="bg-gradient-to-r from-emerald-600 to-blue-600 bg-clip-text text-transparent">
                            to the World
                        </span>
                    </h2>

                    <p class="text-xl text-gray-600 mb-8 leading-relaxed">
                        StudySeco bridges the gap for Malawian students living abroad or in remote areas who want to maintain
                        their connection to home while receiving quality secondary education. Our MANEB-aligned curriculum
                        ensures seamless integration with Malawi's education system.
                    </p>

                    <div class="space-y-6">
                        <div class="flex items-center space-x-4">
                            <div class="w-12 h-12 bg-gradient-to-r from-emerald-500 to-blue-500 rounded-xl flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                                    <path d="M9 12l2 2 4-4"/>
                                    <path d="M21 12c.552 0 1-.448 1-1V5c0-.552-.448-1-1-1H3c-.552 0-1 .448-1 1v6c0 .552.448 1 1 1"/>
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-xl font-semibold text-gray-900">MANEB-Certified Curriculum</h3>
                                <p class="text-gray-600">Fully aligned with Malawi National Examinations Board standards</p>
                            </div>
                        </div>

                        <div class="flex items-center space-x-4">
                            <div class="w-12 h-12 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-xl flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                    <circle cx="9" cy="7" r="4"/>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-xl font-semibold text-gray-900">Qualified Malawian Teachers</h3>
                                <p class="text-gray-600">Experienced educators from top Malawian secondary schools</p>
                            </div>
                        </div>

                        <div class="flex items-center space-x-4">
                            <div class="w-12 h-12 bg-gradient-to-r from-cyan-500 to-purple-500 rounded-xl flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-xl font-semibold text-gray-900">Quality Assurance</h3>
                                <p class="text-gray-600">Affordable quality education accessible to all students worldwide</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="reveal relative">
                    <div class="bg-white rounded-3xl p-8 shadow-xl border border-gray-100">
                        <div class="space-y-6">
                            <div class="bg-gradient-to-r from-emerald-50 to-blue-50 rounded-2xl p-6 border border-emerald-100">
                                <div class="flex items-center justify-between mb-4">
                                    <h4 class="text-gray-900 font-semibold">Student Progress - Form 3</h4>
                                    <span class="text-green-600 text-sm font-bold">MSCE Ready: 92%</span>
                                </div>
                                <div class="w-full bg-gray-200 rounded-full h-3 mb-4">
                                    <div class="bg-gradient-to-r from-emerald-500 to-blue-500 h-3 rounded-full" style="width: 92%"></div>
                                </div>
                                <div class="grid grid-cols-3 gap-4 text-center">
                                    <div>
                                        <div class="text-2xl font-bold text-emerald-600">8</div>
                                        <div class="text-xs text-gray-500">Subjects</div>
                                    </div>
                                    <div>
                                        <div class="text-2xl font-bold text-blue-600">156h</div>
                                        <div class="text-xs text-gray-500">Study Time</div>
                                    </div>
                                    <div>
                                        <div class="text-2xl font-bold text-cyan-600">A</div>
                                        <div class="text-xs text-gray-500">Avg Grade</div>
                                    </div>
                                </div>
                            </div>

                            <div class="grid grid-cols-3 gap-3">
                                <div class="bg-gradient-to-r from-yellow-50 to-orange-50 border border-yellow-100 rounded-xl p-3 text-center">
                                    <div class="w-8 h-8 bg-gradient-to-r from-yellow-500 to-orange-500 rounded-full mx-auto mb-2 flex items-center justify-center">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="currentColor" class="text-white">
                                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                                        </svg>
                                    </div>
                                    <div class="text-xs text-gray-600 font-medium">Top Performer</div>
                                </div>
                                <div class="bg-gradient-to-r from-emerald-50 to-blue-50 border border-emerald-100 rounded-xl p-3 text-center">
                                    <div class="w-8 h-8 bg-gradient-to-r from-emerald-500 to-blue-500 rounded-full mx-auto mb-2 flex items-center justify-center">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                            <polyline points="22,4 12,14.01 9,11.01"/>
                                        </svg>
                                    </div>
                                    <div class="text-xs text-gray-600 font-medium">All Complete</div>
                                </div>
                                <div class="bg-gradient-to-r from-blue-50 to-cyan-50 border border-blue-100 rounded-xl p-3 text-center">
                                    <div class="w-8 h-8 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-full mx-auto mb-2 flex items-center justify-center">
                                        <span class="text-xs font-bold text-white">🇲🇼</span>
                                    </div>
                                    <div class="text-xs text-gray-600 font-medium">Malawi Pride</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Subjects Section -->
    <section id="subjects" class="py-24 bg-gray-50">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center mb-20 reveal">
                <h2 class="text-5xl font-bold mb-6">
                    <span class="text-gray-900">
                        Complete Malawi Secondary
                    </span>
                    <br>
                    <span class="bg-gradient-to-r from-emerald-600 to-blue-600 bg-clip-text text-transparent">
                        School Curriculum
                    </span>
                </h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
                    All subjects taught in Malawian secondary schools, from Form 1 to Form 4. Quality MANEB-certified education.
                </p>
                <div class="inline-flex items-center px-6 py-3 bg-white rounded-full border border-emerald-200 shadow-sm">
                    <span class="text-emerald-600 font-semibold mr-2">📜</span>
                    <span class="text-gray-700 font-medium">MANEB Approved Curriculum</span>
                </div>
            </div>

            <div class="mb-16 reveal">
                <h3 class="text-3xl font-bold text-center mb-12">
                    <span class="bg-gradient-to-r from-emerald-600 to-blue-600 bg-clip-text text-transparent">
                        Core Subjects (Compulsory)
                    </span>
                </h3>
                <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <Link 
                        v-for="subject in subjects.filter(s => s.type === 'core')" 
                        :key="subject.id" 
                        :href="route('subject.detail', subject.id)"
                        class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-xl transition-all duration-300 hover:-translate-y-2 group cursor-pointer"
                    >
                        <div class="w-16 h-16 bg-gradient-to-r from-blue-500 to-indigo-500 rounded-2xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300">
                            <span class="text-2xl">{{ subject.icon }}</span>
                        </div>
                        <h4 class="text-xl font-bold text-gray-900 mb-2 group-hover:text-blue-600 transition-colors duration-300">{{ subject.name }}</h4>
                        <p class="text-gray-600 text-sm mb-3">{{ subject.description }}</p>
                        <div class="flex items-center justify-end">
                            <div class="text-blue-500 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M7 17l9.2-9.2M17 17V7H7"/>
                                </svg>
                            </div>
                        </div>
                    </Link>
                </div>
            </div>

            <div class="mb-16 reveal">
                <h3 class="text-3xl font-bold text-center mb-12">
                    <span class="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                        Optional Subjects
                    </span>
                </h3>
                <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <Link 
                        v-for="subject in subjects.filter(s => s.type === 'optional')" 
                        :key="subject.id" 
                        :href="route('subject.detail', subject.id)"
                        class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-xl transition-all duration-300 hover:-translate-y-2 group cursor-pointer"
                    >
                        <div class="w-16 h-16 bg-gradient-to-r from-emerald-500 to-blue-500 rounded-2xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform duration-300">
                            <span class="text-2xl">{{ subject.icon }}</span>
                        </div>
                        <h4 class="text-xl font-bold text-gray-900 mb-2 group-hover:text-emerald-600 transition-colors duration-300">{{ subject.name }}</h4>
                        <p class="text-gray-600 text-sm mb-3">{{ subject.description }}</p>
                        <div class="flex items-center justify-end">
                            <div class="text-emerald-500 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M7 17l9.2-9.2M17 17V7H7"/>
                                </svg>
                            </div>
                        </div>
                    </Link>
                </div>
            </div>
        </div>
    </section>

    <!-- Student Testimonials -->
    <section class="py-24 bg-white">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center mb-20 reveal">
                <h2 class="text-5xl font-bold mb-6 text-gray-900">
                    What Our Students Say
                </h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                    Hear from Malawian students around the world who've trusted StudySeco with their education.
                </p>
            </div>

            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
                <div v-for="testimonial in testimonials" :key="testimonial.name" class="bg-white rounded-3xl p-8 shadow-lg border border-gray-100 hover:shadow-xl transition-all duration-300 hover:-translate-y-2 reveal">
                    <div class="flex items-center mb-4">
                        <div class="w-12 h-12 bg-gradient-to-r from-emerald-500 to-blue-500 rounded-full flex items-center justify-center text-white font-bold mr-4">
                            {{ testimonial.avatar }}
                        </div>
                        <div>
                            <h4 class="text-gray-900 font-semibold">{{ testimonial.name }}</h4>
                            <p class="text-gray-600 text-sm">{{ testimonial.location }}</p>
                        </div>
                    </div>
                    <div class="flex mb-4">
                        <span v-for="star in 5" :key="star" class="text-yellow-400 text-lg">⭐</span>
                    </div>
                    <p class="text-gray-700 leading-relaxed">{{ testimonial.message }}</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Student Success Stories Slider -->
    <section class="py-24 bg-gradient-to-br from-blue-50 to-emerald-50 overflow-hidden">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center mb-16 reveal">
                <h2 class="text-5xl font-bold mb-6">
                    <span class="text-gray-900">Our Students</span>
                    <br>
                    <span class="bg-gradient-to-r from-emerald-600 to-blue-600 bg-clip-text text-transparent">
                        Around the World
                    </span>
                </h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                    Meet our successful students who are making their mark globally while staying connected to their Malawian roots.
                </p>
            </div>

            <!-- Student Slider -->
            <div class="relative">
                <div class="student-slider overflow-hidden">
                    <div class="student-slides flex transition-transform duration-700 ease-in-out" id="studentSlides">
                        <!-- Dynamic Student Stories -->
                        <div v-for="(story, index) in sliderStories" :key="story.id" class="slide w-full flex-shrink-0">
                            <div class="grid lg:grid-cols-2 gap-12 items-center">
                                <div class="relative">
                                    <div :class="`aspect-[4/3] bg-gradient-to-br from-${story.avatar_color_from.replace('-500', '-100')} to-${story.avatar_color_to.replace('-500', '-100')} rounded-3xl overflow-hidden shadow-2xl`">
                                        <div :class="`absolute inset-0 bg-gradient-to-br from-${story.avatar_color_from}/20 to-${story.avatar_color_to}/20`"></div>
                                        <div class="absolute inset-0 flex items-center justify-center">
                                            <div :class="`w-48 h-48 bg-gradient-to-br from-${story.avatar_color_from} to-${story.avatar_color_to} rounded-full flex items-center justify-center text-white text-6xl font-bold`">
                                                {{ story.name.split(' ').map(n => n[0]).join('').slice(0, 2) }}
                                            </div>
                                        </div>
                                        <div class="absolute bottom-4 left-4 bg-white/90 backdrop-blur rounded-full px-4 py-2">
                                            <div class="flex items-center space-x-2">
                                                <span class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span>
                                                <span class="text-sm font-medium text-gray-800">Currently studying in {{ story.location.split(',')[0] }}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="absolute -top-6 -right-6 w-20 h-20 bg-yellow-400 rounded-full flex items-center justify-center text-2xl animate-bounce">
                                        {{ story.achievement_icon }}
                                    </div>
                                </div>
                                <div class="space-y-6">
                                    <div class="space-y-4">
                                        <h3 class="text-4xl font-bold text-gray-900">{{ story.name }}</h3>
                                        <div class="flex items-center space-x-4">
                                            <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-medium">Top Performer</span>
                                            <span class="px-3 py-1 bg-emerald-100 text-emerald-800 rounded-full text-sm font-medium">{{ story.country_flag }} {{ story.location }}</span>
                                        </div>
                                    </div>
                                    <blockquote class="text-xl text-gray-700 italic leading-relaxed">
                                        "{{ story.story }}"
                                    </blockquote>
                                    <div class="flex items-center space-x-4">
                                        <div class="flex space-x-1">
                                            <span class="text-yellow-400 text-xl">⭐</span>
                                            <span class="text-yellow-400 text-xl">⭐</span>
                                            <span class="text-yellow-400 text-xl">⭐</span>
                                            <span class="text-yellow-400 text-xl">⭐</span>
                                            <span class="text-yellow-400 text-xl">⭐</span>
                                        </div>
                                        <span v-if="story.msce_credits" class="text-gray-600 text-lg">MSCE: {{ story.msce_credits }} Credits</span>
                                    </div>
                                    <div :class="`bg-gradient-to-r from-${story.avatar_color_from.replace('-500', '-50')} to-${story.avatar_color_to.replace('-500', '-50')} border border-${story.avatar_color_from.replace('-500', '-200')} rounded-xl p-4`">
                                        <div class="flex items-center justify-between">
                                            <span class="text-gray-700 font-medium">Current Status:</span>
                                            <span :class="`text-${story.avatar_color_from} font-semibold`">{{ story.current_status }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Slider Navigation -->
                <div class="flex justify-center mt-12 space-x-4">
                    <button id="prevSlide" class="w-12 h-12 bg-white border border-gray-300 rounded-full flex items-center justify-center hover:bg-gray-50 transition-all duration-300 shadow-sm">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-gray-600">
                            <path d="M15 18l-6-6 6-6"/>
                        </svg>
                    </button>
                    <div class="flex space-x-2">
                        <button v-for="(story, index) in sliderStories" :key="`dot-${story.id}`" 
                                class="slide-dot w-3 h-3 rounded-full transition-all duration-300 hover:bg-gray-400" 
                                :class="index === 0 ? 'bg-emerald-500' : 'bg-gray-300'"
                                :data-slide="index"></button>
                    </div>
                    <button id="nextSlide" class="w-12 h-12 bg-white border border-gray-300 rounded-full flex items-center justify-center hover:bg-gray-50 transition-all duration-300 shadow-sm">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-gray-600">
                            <path d="M9 18l6-6-6-6"/>
                        </svg>
                    </button>
                </div>

                <!-- Student Statistics -->
                <div class="grid grid-cols-2 md:grid-cols-4 gap-6 mt-16">
                    <div class="text-center bg-white/80 backdrop-blur rounded-2xl p-6 shadow-sm border border-gray-100">
                        <div class="text-3xl font-bold bg-gradient-to-r from-emerald-600 to-blue-600 bg-clip-text text-transparent">{{ studentCount }}+</div>
                        <div class="text-gray-600 text-sm font-medium">Global Students</div>
                    </div>
                    <div class="text-center bg-white/80 backdrop-blur rounded-2xl p-6 shadow-sm border border-gray-100">
                        <div class="text-3xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">25+</div>
                        <div class="text-gray-600 text-sm font-medium">Countries</div>
                    </div>
                    <div class="text-center bg-white/80 backdrop-blur rounded-2xl p-6 shadow-sm border border-gray-100">
                        <div class="text-3xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">98%</div>
                        <div class="text-gray-600 text-sm font-medium">Pass Rate</div>
                    </div>
                    <div class="text-center bg-white/80 backdrop-blur rounded-2xl p-6 shadow-sm border border-gray-100">
                        <div class="text-3xl font-bold bg-gradient-to-r from-pink-600 to-red-600 bg-clip-text text-transparent">150+</div>
                        <div class="text-gray-600 text-sm font-medium">Universities</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="py-24 bg-gradient-to-br from-emerald-50 to-blue-50">
        <div class="max-w-5xl mx-auto px-6 text-center">
            <div class="bg-white p-12 rounded-3xl shadow-xl border border-gray-100 reveal">
                <h2 class="text-4xl font-bold mb-4 text-gray-900">
                    Ready to Begin Your Journey?
                </h2>
                <p class="text-lg text-gray-600 mb-8">
                    Join {{ studentCount }}+ students worldwide. Start your educational journey today.
                </p>
                <div class="flex flex-col sm:flex-row items-center justify-center gap-6">
                    <button @click="showEnrollmentModal = true" class="group relative px-8 py-4 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full font-semibold text-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                        Enroll Now
                    </button>
                    <button @click="showChatModal = true" class="group px-8 py-4 border-2 border-gray-300 text-gray-700 rounded-full font-semibold text-lg hover:border-emerald-500 hover:text-emerald-600 transition-all duration-300">
                        Get Live Support
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="py-12 bg-gray-900 text-white">
        <div class="max-w-7xl mx-auto px-6 text-center">
            <div class="flex items-center justify-center space-x-3 mb-4">
                <div class="w-12 h-12 rounded-xl bg-gradient-to-r from-emerald-500 to-blue-500 flex items-center justify-center">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                    </svg>
                </div>
                <span class="text-2xl font-bold">StudySeco</span>
            </div>
            <p class="text-gray-400 text-sm mb-6">
                &copy; 2024 StudySeco. Bringing quality Malawian education to the world.
            </p>
            <div class="flex justify-center space-x-6">
                <a href="#" class="text-gray-400 hover:text-white transition-colors duration-300">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
                </a>
                <a href="#" class="text-gray-400 hover:text-white transition-colors duration-300">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M23 3a10.9 10.9 0 0 1-3.14 1.53 4.48 4.48 0 0 0-7.86 3v1A10.66 10.66 0 0 1 3 4s-4 9 5 13a11.64 11.64 0 0 1-7 2c9 5 20 0 20-11.5a4.5 4.5 0 0 0-.08-.83A7.72 7.72 0 0 0 23 3z"/></svg>
                </a>
                <a href="#" class="text-gray-400 hover:text-white transition-colors duration-300">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/></svg>
                </a>
            </div>
        </div>
    </footer>

    <!-- Enrollment Modal -->
    <div v-show="showEnrollmentModal" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
        <div class="bg-white rounded-3xl p-8 max-w-4xl w-full max-h-[90vh] overflow-y-auto shadow-2xl">
            <div class="flex items-center justify-between mb-8">
                <h2 class="text-3xl font-bold text-gray-900">Enroll at StudySeco</h2>
                <button @click="showEnrollmentModal = false" class="w-8 h-8 bg-gray-100 hover:bg-gray-200 rounded-full flex items-center justify-center text-gray-600 hover:text-gray-800 transition-all">
                    ✕
                </button>
            </div>

            <form @submit.prevent="submitEnrollment" class="space-y-6">
                <!-- Personal Information -->
                <div class="grid md:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Full Name *</label>
                        <input v-model="enrollmentForm.name" type="text" required class="w-full bg-gray-50 border border-gray-300 rounded-lg py-3 px-4 text-gray-900 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Email Address *</label>
                        <input v-model="enrollmentForm.email" type="email" required class="w-full bg-gray-50 border border-gray-300 rounded-lg py-3 px-4 text-gray-900 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Phone Number *</label>
                        <input v-model="enrollmentForm.phone" type="tel" required class="w-full bg-gray-50 border border-gray-300 rounded-lg py-3 px-4 text-gray-900 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent">
                    </div>
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Address *</label>
                        <input v-model="enrollmentForm.address" type="text" required class="w-full bg-gray-50 border border-gray-300 rounded-lg py-3 px-4 text-gray-900 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent">
                    </div>
                </div>

                <!-- Access Duration Selection -->
                <div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-4">Choose Access Duration</h3>
                    <div class="grid md:grid-cols-3 gap-4 mb-6">
                        <div v-for="duration in accessDurations" :key="duration.id" 
                             @click="enrollmentForm.access_duration_id = duration.id"
                             class="p-4 rounded-xl border-2 cursor-pointer transition-all"
                             :class="enrollmentForm.access_duration_id == duration.id 
                                 ? 'border-emerald-500 bg-emerald-50' 
                                 : 'border-gray-300 hover:border-gray-400'">
                            <div class="text-center">
                                <h4 class="font-semibold text-gray-900 mb-2">{{ duration.name }}</h4>
                                <p class="text-2xl font-bold text-emerald-600 mb-1">MKW {{ duration.price.toLocaleString() }}</p>
                                <p class="text-sm text-gray-600 mb-2">per subject</p>
                                <p class="text-xs text-gray-500">{{ duration.description }}</p>
                                <div class="mt-2 text-xs bg-gray-100 rounded-full px-3 py-1 inline-block">
                                    {{ Math.ceil(duration.days / 30) }} months access
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Subject Selection -->
                <div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-4">Select Subjects 
                        <span v-if="getSelectedDuration()" class="text-emerald-600 font-normal">
                            ({{ getSelectedDuration().name }} - MKW {{ getSelectedDuration().price.toLocaleString() }} each)
                        </span>
                    </h3>
                    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
                        <div v-for="subject in subjects" :key="subject.id" 
                             @click="toggleSubject(subject.id)"
                             class="p-4 rounded-xl border-2 cursor-pointer transition-all"
                             :class="enrollmentForm.selected_subjects.includes(subject.id) 
                                 ? 'border-emerald-500 bg-emerald-50' 
                                 : 'border-gray-300 hover:border-gray-400'">
                            <div class="flex items-center justify-between">
                                <div>
                                    <div class="text-2xl mb-2">{{ subject.icon }}</div>
                                    <h4 class="font-semibold text-gray-900 text-sm">{{ subject.name }}</h4>
                                    <p class="text-xs text-gray-600">MANEB Certified</p>
                                </div>
                                <div class="w-6 h-6 rounded-full border-2"
                                     :class="enrollmentForm.selected_subjects.includes(subject.id) 
                                         ? 'bg-emerald-500 border-emerald-500' 
                                         : 'border-gray-400'">
                                    <svg v-if="enrollmentForm.selected_subjects.includes(subject.id)" class="w-4 h-4 text-white m-0.5" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Cost -->
                <div v-if="enrollmentForm.selected_subjects.length > 0 && enrollmentForm.access_duration_id" class="bg-emerald-50 border border-emerald-200 rounded-xl p-6">
                    <div class="space-y-3">
                        <div class="flex items-center justify-between">
                            <span class="text-gray-900 text-lg font-medium">Total Cost:</span>
                            <span class="text-2xl font-bold text-emerald-600">MKW {{ calculateTotal().toLocaleString() }}</span>
                        </div>
                        <div class="text-sm text-gray-600 space-y-1">
                            <p>{{ enrollmentForm.selected_subjects.length }} subject(s) selected</p>
                            <p v-if="getSelectedDuration()">{{ getSelectedDuration().name }} ({{ Math.ceil(getSelectedDuration().days / 30) }} months)</p>
                            <p v-if="getSelectedDuration()" class="font-medium">{{ enrollmentForm.selected_subjects.length }} × MKW {{ getSelectedDuration().price.toLocaleString() }} = MKW {{ calculateTotal().toLocaleString() }}</p>
                        </div>
                    </div>
                </div>

                <!-- Payment Method -->
                <div v-if="enrollmentForm.selected_subjects.length > 0">
                    <h3 class="text-xl font-semibold text-gray-900 mb-4">Payment Method</h3>
                    <div class="grid md:grid-cols-3 gap-4">
                        <div @click="enrollmentForm.payment_method = 'tnm_mpamba'"
                             class="p-4 rounded-xl border-2 cursor-pointer transition-all text-center"
                             :class="enrollmentForm.payment_method === 'tnm_mpamba' 
                                 ? 'border-emerald-500 bg-emerald-50' 
                                 : 'border-gray-300 hover:border-gray-400'">
                            <div class="text-3xl mb-2">📱</div>
                            <h4 class="font-semibold text-gray-900">TNM Mpamba</h4>
                            <p class="text-xs text-gray-600">Mobile Money</p>
                        </div>
                        <div @click="enrollmentForm.payment_method = 'airtel_money'"
                             class="p-4 rounded-xl border-2 cursor-pointer transition-all text-center"
                             :class="enrollmentForm.payment_method === 'airtel_money' 
                                 ? 'border-emerald-500 bg-emerald-50' 
                                 : 'border-gray-300 hover:border-gray-400'">
                            <div class="text-3xl mb-2">💸</div>
                            <h4 class="font-semibold text-gray-900">Airtel Money</h4>
                            <p class="text-xs text-gray-600">Mobile Money</p>
                        </div>
                        <div @click="enrollmentForm.payment_method = 'bank_transfer'"
                             class="p-4 rounded-xl border-2 cursor-pointer transition-all text-center"
                             :class="enrollmentForm.payment_method === 'bank_transfer' 
                                 ? 'border-emerald-500 bg-emerald-50' 
                                 : 'border-gray-300 hover:border-gray-400'">
                            <div class="text-3xl mb-2">🏦</div>
                            <h4 class="font-semibold text-gray-900">Bank Transfer</h4>
                            <p class="text-xs text-gray-600">Direct Transfer</p>
                        </div>
                    </div>
                </div>

                <!-- Payment Details -->
                <div v-if="enrollmentForm.payment_method">
                    <h3 class="text-xl font-semibold text-gray-900 mb-4">Payment Instructions</h3>
                    <div class="bg-blue-50 border border-blue-200 rounded-xl p-6 mb-6">
                        <div v-if="enrollmentForm.payment_method === 'tnm_mpamba'" class="text-center">
                            <h4 class="font-semibold text-gray-900 mb-2">TNM Mpamba Payment</h4>
                            <p class="text-gray-700 mb-2">Send MKW {{ calculateTotal().toLocaleString() }} to:</p>
                            <p class="text-2xl font-bold text-blue-600">0888 123 456</p>
                            <p class="text-sm text-gray-600 mt-2">Reference: STUDYSECO-{{ Date.now() }}</p>
                        </div>
                        <div v-if="enrollmentForm.payment_method === 'airtel_money'" class="text-center">
                            <h4 class="font-semibold text-gray-900 mb-2">Airtel Money Payment</h4>
                            <p class="text-gray-700 mb-2">Send MKW {{ calculateTotal().toLocaleString() }} to:</p>
                            <p class="text-2xl font-bold text-red-600">0991 123 456</p>
                            <p class="text-sm text-gray-600 mt-2">Reference: STUDYSECO-{{ Date.now() }}</p>
                        </div>
                        <div v-if="enrollmentForm.payment_method === 'bank_transfer'" class="text-center">
                            <h4 class="font-semibold text-gray-900 mb-2">Bank Transfer Details</h4>
                            <p class="text-gray-700 mb-2">Transfer MKW {{ calculateTotal().toLocaleString() }} to:</p>
                            <div class="text-left bg-white p-4 rounded-lg border">
                                <p class="text-gray-900"><strong>Bank:</strong> Standard Bank</p>
                                <p class="text-gray-900"><strong>Account:</strong> 1234567890</p>
                                <p class="text-gray-900"><strong>Account Name:</strong> StudySeco Limited</p>
                                <p class="text-gray-900"><strong>Reference:</strong> STUDYSECO-{{ Date.now() }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Proof Upload -->
                    <div class="space-y-4">
                        <div>
                            <label class="block text-gray-700 font-medium mb-2">Payment Reference Number *</label>
                            <input v-model="enrollmentForm.payment_reference" type="text" required class="w-full bg-gray-50 border border-gray-300 rounded-lg py-3 px-4 text-gray-900 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent" placeholder="Enter transaction reference number">
                        </div>
                        <div>
                            <label class="block text-gray-700 font-medium mb-2">Upload Payment Proof *</label>
                            <input @change="handlePaymentProofUpload" type="file" accept="image/*,.pdf" required class="w-full bg-gray-50 border border-gray-300 rounded-lg py-3 px-4 text-gray-900 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent">
                            <p class="text-xs text-gray-600 mt-1">Upload screenshot or receipt (JPG, PNG, PDF)</p>
                        </div>
                    </div>
                </div>

                <!-- Terms and Conditions -->
                <div v-if="enrollmentForm.selected_subjects.length > 0 && enrollmentForm.access_duration_id && enrollmentForm.payment_method" class="space-y-4">
                    <div class="bg-gray-50 border border-gray-200 rounded-xl p-6">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Terms and Conditions</h3>
                        <div class="max-h-48 overflow-y-auto text-sm text-gray-700 space-y-3 border border-gray-200 rounded-lg p-4 bg-white">
                            <p><strong>1. Access Duration:</strong> Your access will be valid for the selected duration starting from enrollment confirmation. No extensions will be provided after expiration.</p>
                            <p><strong>2. Payment Policy:</strong> All payments must be verified before access is granted. Refunds are only available within 7 days of enrollment and subject to our refund policy.</p>
                            <p><strong>3. Academic Integrity:</strong> Students are expected to maintain academic honesty. Any form of cheating or plagiarism may result in suspension.</p>
                            <p><strong>4. Content Access:</strong> Course materials are for registered students only and may not be shared, distributed, or resold.</p>
                            <p><strong>5. Technical Support:</strong> We provide technical support during business hours. Students are responsible for maintaining stable internet connectivity.</p>
                            <p><strong>6. Examination:</strong> MSCE examinations are conducted according to MANEB schedules and requirements. Students must meet all prerequisites.</p>
                            <p><strong>7. Certificate Issuance:</strong> Certificates will be issued upon successful completion of coursework and examinations as per MANEB standards.</p>
                            <p><strong>8. Data Privacy:</strong> Your personal information will be used solely for educational purposes and will not be shared with third parties.</p>
                            <p><strong>9. Platform Updates:</strong> We reserve the right to update our platform and learning materials to improve educational quality.</p>
                            <p><strong>10. Dispute Resolution:</strong> Any disputes will be resolved through our internal grievance process or legal channels in Malawi.</p>
                        </div>
                        
                        <div class="mt-6 flex items-start space-x-3">
                            <input 
                                v-model="enrollmentForm.terms_accepted" 
                                type="checkbox" 
                                id="terms" 
                                class="mt-1 w-4 h-4 text-emerald-600 border-gray-300 rounded focus:ring-emerald-500"
                                required
                            >
                            <label for="terms" class="text-sm text-gray-700 cursor-pointer">
                                I have read, understood, and agree to the Terms and Conditions. I confirm that all information provided is accurate and I am committed to following StudySeco's academic policies and procedures.
                            </label>
                        </div>
                    </div>
                </div>

                <!-- Submit Button -->
                <div v-if="enrollmentForm.selected_subjects.length > 0 && enrollmentForm.access_duration_id && enrollmentForm.payment_method && enrollmentForm.terms_accepted" class="pt-6">
                    <button type="submit" :disabled="enrollmentForm.processing" class="w-full px-8 py-4 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full font-semibold text-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 disabled:opacity-50 disabled:transform-none">
                        <span v-if="enrollmentForm.processing">Processing...</span>
                        <span v-else>Submit Enrollment - MKW {{ calculateTotal().toLocaleString() }}</span>
                    </button>
                    <p class="text-center text-gray-600 text-sm mt-4">
                        Your enrollment will be reviewed and approved within 24 hours after payment verification.
                    </p>
                </div>
            </form>
        </div>
    </div>

    <!-- Student Chat Modal -->
    <div v-show="showChatModal" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
        <div class="bg-white rounded-3xl p-8 max-w-2xl w-full max-h-[80vh] shadow-2xl">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-2xl font-bold text-gray-900">Student Chat & Live Support</h2>
                <button @click="showChatModal = false" class="w-8 h-8 bg-gray-100 hover:bg-gray-200 rounded-full flex items-center justify-center text-gray-600 hover:text-gray-800 transition-all">
                    ✕
                </button>
            </div>

            <div class="space-y-6">
                <!-- Live Support -->
                <div class="bg-gradient-to-r from-emerald-50 to-blue-50 border border-emerald-200 rounded-xl p-6">
                    <h3 class="text-xl font-semibold text-gray-900 mb-4">🔴 Live Support Available</h3>
                    <p class="text-gray-700 mb-4">Get instant help with enrollment, payments, or any questions about our courses.</p>
                    <button class="w-full px-6 py-3 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full font-semibold hover:shadow-lg transition-all duration-300">
                        Start Live Chat Now
                    </button>
                </div>

                <!-- Student Chat Access -->
                <div class="bg-gray-50 rounded-xl p-6">
                    <h3 class="text-xl font-semibold text-gray-900 mb-4">💬 Student Community Chat</h3>
                    <p class="text-gray-700 mb-4">Connect with fellow Malawian students worldwide. Share experiences, study tips, and build lasting friendships.</p>
                    
                    <div v-if="!$page.props.auth.user" class="text-center">
                        <p class="text-gray-600 mb-4">Please login or enroll to access the student chat community.</p>
                        <div class="space-x-4">
                            <Link :href="route('login')" class="px-6 py-2 border border-gray-300 text-gray-700 rounded-full hover:border-emerald-500 hover:text-emerald-600 transition-all">
                                Login
                            </Link>
                            <button @click="showEnrollmentModal = true; showChatModal = false" class="px-6 py-2 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full">
                                Enroll Now
                            </button>
                        </div>
                    </div>
                    
                    <div v-else class="space-y-4">
                        <div class="bg-emerald-50 border border-emerald-200 rounded-lg p-4">
                            <p class="text-emerald-700 font-semibold">✅ You're logged in!</p>
                            <p class="text-gray-700">Access the full student chat experience in your dashboard.</p>
                        </div>
                        <Link :href="route('dashboard')" class="block w-full px-6 py-3 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full font-semibold hover:shadow-lg transition-all duration-300 text-center">
                            Go to Student Dashboard
                        </Link>
                    </div>
                </div>

                <!-- Contact Information -->
                <div class="grid md:grid-cols-2 gap-4">
                    <div class="bg-gray-50 rounded-xl p-4 text-center">
                        <div class="w-12 h-12 bg-gradient-to-r from-emerald-500 to-blue-500 rounded-full flex items-center justify-center mx-auto mb-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-white">
                                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
                            </svg>
                        </div>
                        <h4 class="font-semibold text-gray-900">Call Us</h4>
                        <p class="text-gray-600">+265 99 123 4567</p>
                    </div>
                    <div class="bg-gray-50 rounded-xl p-4 text-center">
                        <div class="w-12 h-12 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-full flex items-center justify-center mx-auto mb-3">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-white">
                                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                                <polyline points="22,6 12,13 2,6"/>
                            </svg>
                        </div>
                        <h4 class="font-semibold text-gray-900">Email Us</h4>
                        <p class="text-gray-600">info@studyseco.com</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Online Library Modal -->
    <div v-show="showLibraryModal" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
        <div class="bg-white rounded-3xl p-8 max-w-4xl w-full max-h-[80vh] overflow-y-auto shadow-2xl">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-2xl font-bold text-gray-900">📚 StudySeco Online Library</h2>
                <button @click="showLibraryModal = false" class="w-8 h-8 bg-gray-100 hover:bg-gray-200 rounded-full flex items-center justify-center text-gray-600 hover:text-gray-800 transition-all">
                    ✕
                </button>
            </div>

            <div v-if="!$page.props.auth.user" class="text-center py-12">
                <div class="w-24 h-24 bg-gradient-to-r from-emerald-500 to-blue-500 rounded-full flex items-center justify-center mx-auto mb-6">
                    <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-white">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                    </svg>
                </div>
                <h3 class="text-2xl font-bold text-gray-900 mb-4">Access Requires Enrollment</h3>
                <p class="text-gray-600 mb-6">Our comprehensive digital library is available exclusively to enrolled students. Access thousands of resources, textbooks, and study materials.</p>
                <div class="space-x-4">
                    <Link :href="route('login')" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-full hover:border-emerald-500 hover:text-emerald-600 transition-all">
                        Student Login
                    </Link>
                    <button @click="showEnrollmentModal = true; showLibraryModal = false" class="px-6 py-3 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full hover:shadow-lg transition-all duration-300">
                        Enroll Now
                    </button>
                </div>
            </div>

            <div v-else class="space-y-6">
                <div class="bg-emerald-50 border border-emerald-200 rounded-xl p-6">
                    <h3 class="text-xl font-semibold text-gray-900 mb-2">🎉 Welcome to the Library!</h3>
                    <p class="text-gray-700">Access thousands of educational resources, textbooks, and study materials from your dashboard.</p>
                </div>

                <!-- Library Categories -->
                <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div class="bg-gray-50 rounded-2xl p-6 hover:shadow-md transition-all duration-300">
                        <div class="text-3xl mb-4">📖</div>
                        <h4 class="text-lg font-semibold text-gray-900 mb-2">Textbooks</h4>
                        <p class="text-gray-600 text-sm">Complete digital textbooks for all subjects aligned with MANEB curriculum.</p>
                    </div>
                    <div class="bg-gray-50 rounded-2xl p-6 hover:shadow-md transition-all duration-300">
                        <div class="text-3xl mb-4">📊</div>
                        <h4 class="text-lg font-semibold text-gray-900 mb-2">Past Papers</h4>
                        <p class="text-gray-600 text-sm">MSCE past papers with marking schemes from the last 10 years.</p>
                    </div>
                    <div class="bg-gray-50 rounded-2xl p-6 hover:shadow-md transition-all duration-300">
                        <div class="text-3xl mb-4">🎥</div>
                        <h4 class="text-lg font-semibold text-gray-900 mb-2">Video Lessons</h4>
                        <p class="text-gray-600 text-sm">Recorded lessons from qualified Malawian teachers for all subjects.</p>
                    </div>
                    <div class="bg-gray-50 rounded-2xl p-6 hover:shadow-md transition-all duration-300">
                        <div class="text-3xl mb-4">📝</div>
                        <h4 class="text-lg font-semibold text-gray-900 mb-2">Study Guides</h4>
                        <p class="text-gray-600 text-sm">Comprehensive study guides and revision notes for exam preparation.</p>
                    </div>
                    <div class="bg-gray-50 rounded-2xl p-6 hover:shadow-md transition-all duration-300">
                        <div class="text-3xl mb-4">🧪</div>
                        <h4 class="text-lg font-semibold text-gray-900 mb-2">Lab Simulations</h4>
                        <p class="text-gray-600 text-sm">Virtual laboratory experiments for Physics, Chemistry, and Biology.</p>
                    </div>
                    <div class="bg-gray-50 rounded-2xl p-6 hover:shadow-md transition-all duration-300">
                        <div class="text-3xl mb-4">📚</div>
                        <h4 class="text-lg font-semibold text-gray-900 mb-2">Reference Books</h4>
                        <p class="text-gray-600 text-sm">Additional reading materials and reference books for deeper understanding.</p>
                    </div>
                </div>

                <div class="text-center">
                    <Link :href="route('dashboard')" class="px-8 py-4 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full font-semibold text-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1">
                        Access Full Library in Dashboard
                    </Link>
                </div>
            </div>
        </div>
    </div>

    <!-- Chatbot Widget -->
    <div class="fixed bottom-6 right-6 z-50">
        <!-- Chat Widget -->
        <div v-show="showChatWidget" class="mb-4 w-96 bg-white rounded-2xl shadow-2xl border border-gray-200 overflow-hidden animate-in slide-in-from-bottom-4 fade-in duration-300">
            <!-- Header -->
            <div class="bg-gradient-to-r from-emerald-500 to-blue-500 text-white px-6 py-4">
                <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-3">
                        <div class="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                            </svg>
                        </div>
                        <div>
                            <h3 class="font-semibold">StudySeco Assistant</h3>
                            <p class="text-xs text-white/80">Online • Ready to help</p>
                        </div>
                    </div>
                    <button @click="showChatWidget = false" class="w-6 h-6 bg-white/20 hover:bg-white/30 rounded-full flex items-center justify-center transition-colors">
                        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="18" y1="6" x2="6" y2="18"></line>
                            <line x1="6" y1="6" x2="18" y2="18"></line>
                        </svg>
                    </button>
                </div>
            </div>

            <!-- Messages -->
            <div class="h-96 overflow-y-auto p-4 space-y-4 bg-gray-50">
                <div v-for="msg in chatMessages" :key="msg.timestamp" 
                     :class="[
                         'flex',
                         msg.type === 'user' ? 'justify-end' : 'justify-start'
                     ]">
                    <div :class="[
                        'max-w-xs px-4 py-2 rounded-2xl text-sm',
                        msg.type === 'user' 
                            ? 'bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-br-sm' 
                            : 'bg-white border border-gray-200 text-gray-800 rounded-bl-sm shadow-sm'
                    ]">
                        {{ msg.message }}
                    </div>
                </div>
                
                <!-- Typing indicator -->
                <div v-if="isTyping" class="flex justify-start">
                    <div class="bg-white border border-gray-200 px-4 py-2 rounded-2xl rounded-bl-sm text-sm text-gray-600 shadow-sm">
                        <div class="flex space-x-1">
                            <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></div>
                            <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.1s;"></div>
                            <div class="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style="animation-delay: 0.2s;"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Input -->
            <div class="p-4 border-t border-gray-200 bg-white">
                <form @submit.prevent="sendMessage" class="flex space-x-2">
                    <input 
                        v-model="newMessage" 
                        type="text" 
                        placeholder="Type your message..." 
                        class="flex-1 px-4 py-2 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent text-sm"
                    >
                    <button 
                        type="submit" 
                        :disabled="!newMessage.trim()" 
                        class="w-10 h-10 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full flex items-center justify-center hover:shadow-lg transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="22" y1="2" x2="11" y2="13"></line>
                            <polygon points="22,2 15,22 11,13 2,9 22,2"></polygon>
                        </svg>
                    </button>
                </form>
                <p class="text-xs text-gray-500 mt-2 text-center">Press Enter to send • Powered by StudySeco AI</p>
            </div>
        </div>

        <!-- Chat Toggle Button -->
        <button 
            @click="showChatWidget = !showChatWidget"
            class="w-16 h-16 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full shadow-2xl hover:shadow-3xl transition-all duration-300 flex items-center justify-center group hover:scale-110 pulse-glow"
        >
            <svg v-if="!showChatWidget" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="group-hover:scale-110 transition-transform">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
            </svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
        </button>
    </div>
</template>

<style scoped>
/* Light theme styling */
body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

/* Navbar scroll effect */
.scrolled {
    background: rgba(255, 255, 255, 0.95) !important;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

/* Floating particles */
.particles {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 0;
    pointer-events: none;
    overflow: hidden;
}

.particle {
    position: absolute;
    background: rgba(16, 185, 129, 0.1);
    border-radius: 50%;
    animation: floating 20s infinite;
}

@keyframes floating {
    0% { transform: translateY(100vh) rotate(0deg); opacity: 0; }
    10% { opacity: 0.6; }
    90% { opacity: 0.6; }
    100% { transform: translateY(-100vh) rotate(360deg); opacity: 0; }
}

/* Pulse glow animation for chatbot */
@keyframes pulse-glow {
    0%, 100% {
        box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.6);
    }
    50% {
        box-shadow: 0 0 0 20px rgba(16, 185, 129, 0);
    }
}

.pulse-glow {
    animation: pulse-glow 2s infinite;
}

/* Scroll reveal effect */
.reveal {
    opacity: 0;
    transform: translateY(30px);
    transition: opacity 0.8s cubic-bezier(0.1, 0.2, 0.3, 1), transform 0.8s cubic-bezier(0.1, 0.2, 0.3, 1);
}

.reveal.active {
    opacity: 1;
    transform: translateY(0);
}

/* Hero title animation */
.hero-title {
    animation: fadeInUp 1s ease-out;
}

.hero-subtitle {
    animation: fadeInUp 1s ease-out 0.2s both;
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Mobile responsiveness */
@media (max-width: 768px) {
    .hero-title { font-size: 2.5rem !important; }
    .hero-subtitle { font-size: 1.1rem !important; }
}

/* Smooth scrolling */
html {
    scroll-behavior: smooth;
}

/* Custom scrollbar */
::-webkit-scrollbar {
    width: 6px;
}

::-webkit-scrollbar-track {
    background: #f1f5f9;
}

::-webkit-scrollbar-thumb {
    background: linear-gradient(135deg, #10B981, #3B82F6);
    border-radius: 3px;
}
</style>
