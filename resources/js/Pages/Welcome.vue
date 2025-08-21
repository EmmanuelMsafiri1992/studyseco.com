<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { onMounted, ref } from 'vue';

defineProps({
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
});

const navbar = ref(null);

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
    const particleCount = 50;
    for (let i = 0; i < particleCount; i++) {
        const particle = document.createElement('div');
        particle.classList.add('particle');
        const x = Math.random() * 100;
        const y = Math.random() * 100;
        const size = Math.random() * 2 + 2;
        const delay = Math.random() * 10;
        const duration = Math.random() * 8 + 6;
        particle.style.left = `${x}vw`;
        particle.style.top = `${y}vh`;
        particle.style.width = `${size}px`;
        particle.style.height = `${size}px`;
        particle.style.animationDelay = `-${delay}s`;
        particle.style.animationDuration = `${duration}s`;
        particlesContainer.appendChild(particle);
    }

    // Magnetic button effect
    const magneticButtons = document.querySelectorAll('.magnetic-btn');
    magneticButtons.forEach(btn => {
        btn.addEventListener('mousemove', (e) => {
            const rect = btn.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            const centerX = rect.width / 2;
            const centerY = rect.height / 2;
            const moveX = (x - centerX) * 0.1;
            const moveY = (y - centerY) * 0.1;
            btn.style.transform = `translate(${moveX}px, ${moveY}px)`;
        });
        btn.addEventListener('mouseleave', () => {
            btn.style.transform = `translate(0, 0)`;
        });
    });

    // Navbar shrink on scroll
    window.addEventListener('scroll', () => {
        if (navbar.value) {
            if (window.scrollY > 50) {
                navbar.value.style.background = 'rgba(12, 12, 12, 0.8)';
                navbar.value.style.backdropFilter = 'blur(10px)';
            } else {
                navbar.value.style.background = 'rgba(255, 255, 255, 0.1)';
                navbar.value.style.backdropFilter = 'blur(20px)';
            }
        }
    });
});
</script>

<template>
    <Head title="Studyseco - Malawi Secondary School Online Education for Global Malawians" />

    <div id="particles" class="particles"></div>

    <nav ref="navbar" class="fixed top-0 w-full z-50 transition-all duration-300 glass border-b border-white/10">
        <div class="max-w-7xl mx-auto px-6">
            <div class="flex items-center justify-between h-20">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 rounded-xl bg-gradient-to-r from-emerald-500 to-blue-500 flex items-center justify-center pulse-glow">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                            <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                        </svg>
                    </div>
                    <span class="text-2xl font-bold bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">Studyseco</span>
                </div>

                <div class="hidden md:flex items-center space-x-8">
                    <a href="#home" class="nav-link text-gray-300 hover:text-white transition-all duration-300 relative group">
                        Home
                        <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-emerald-500 to-blue-500 group-hover:w-full transition-all duration-300"></span>
                    </a>
                    <a href="#about" class="nav-link text-gray-300 hover:text-white transition-all duration-300 relative group">
                        About
                        <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-emerald-500 to-blue-500 group-hover:w-full transition-all duration-300"></span>
                    </a>
                    <a href="#subjects" class="nav-link text-gray-300 hover:text-white transition-all duration-300 relative group">
                        Subjects
                        <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-emerald-500 to-blue-500 group-hover:w-full transition-all duration-300"></span>
                    </a>
                    <a href="#features" class="nav-link text-gray-300 hover:text-white transition-all duration-300 relative group">
                        Features
                        <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-emerald-500 to-blue-500 group-hover:w-full transition-all duration-300"></span>
                    </a>
                    <a href="#contact" class="nav-link text-gray-300 hover:text-white transition-all duration-300 relative group">
                        Contact
                        <span class="absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-emerald-500 to-blue-500 group-hover:w-full transition-all duration-300"></span>
                    </a>
                </div>

                <div class="flex items-center space-x-4" v-if="canLogin">
                    <Link
                        v-if="$page.props.auth.user"
                        :href="route('dashboard')"
                        class="px-6 py-2 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full magnetic-btn hover:shadow-lg transition-all duration-300"
                    >
                        Dashboard
                    </Link>
                    <template v-else>
                        <Link
                            :href="route('login')"
                            class="px-6 py-2 text-white border border-white/20 rounded-full hover:bg-white/10 transition-all duration-300"
                        >
                            Login
                        </Link>
                        <Link
                            v-if="canRegister"
                            :href="route('register')"
                            class="px-6 py-2 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full magnetic-btn hover:shadow-lg transition-all duration-300"
                        >
                            Enroll Now
                        </Link>
                    </template>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="min-h-screen flex items-center justify-center relative overflow-hidden">
        <div class="absolute inset-0 bg-gradient-to-br from-black/80 via-emerald-900/20 to-blue-900/20"></div>

        <div class="absolute top-20 left-10 w-20 h-20 bg-emerald-500/20 rounded-full floating"></div>
        <div class="absolute top-40 right-20 w-32 h-32 bg-blue-500/20 rounded-full floating" style="animation-delay: -2s;"></div>
        <div class="absolute bottom-20 left-20 w-16 h-16 bg-black/20 rounded-full floating" style="animation-delay: -4s;"></div>

        <div class="relative z-10 max-w-7xl mx-auto px-6 text-center">
            <div class="space-y-8 reveal">
                <div class="inline-flex items-center px-4 py-2 rounded-full glass border border-white/20 text-sm font-mono">
                    <span class="w-2 h-2 bg-emerald-400 rounded-full mr-2 animate-pulse"></span>
                    Malawi Secondary School Online - Serving Global Malawians
                </div>

                <h1 class="hero-title text-6xl md:text-8xl font-black leading-tight">
                    <span class="bg-gradient-to-r from-white via-emerald-200 to-blue-200 bg-clip-text text-transparent">
                        Complete Malawi
                    </span>
                    <br>
                    <span class="gradient-animated bg-clip-text text-transparent">
                        Secondary Education
                    </span>
                </h1>

                <p class="hero-subtitle text-xl md:text-2xl text-gray-300 max-w-4xl mx-auto font-light">
                    Study all Form 1-4 subjects with qualified teachers, flexible schedules, and globally recognized qualifications.
                </p>

                <div class="flex flex-wrap justify-center gap-4 text-sm">
                    <span class="px-4 py-2 bg-blue-600/20 rounded-full border border-blue-600/30">🇲🇼 MANEB Certified</span>
                    <span class="px-4 py-2 bg-emerald-600/20 rounded-full border border-emerald-600/30">🌍 Global Access</span>
                    <span class="px-4 py-2 bg-cyan-600/20 rounded-full border border-cyan-600/30">📚 All Subjects</span>
                    <span class="px-4 py-2 bg-purple-600/20 rounded-full border border-purple-600/30">👨‍🏫 Qualified Teachers</span>
                </div>

                <div class="flex flex-col sm:flex-row items-center justify-center gap-6 pt-8">
                    <Link
                        v-if="canRegister"
                        :href="route('register')"
                        class="group relative px-8 py-4 bg-gradient-to-r from-emerald-500 to-blue-500 rounded-full text-white font-semibold text-lg magnetic-btn hover-lift"
                    >
                        <span class="relative z-10">Start Your Education Journey</span>
                        <div class="absolute inset-0 rounded-full bg-gradient-to-r from-emerald-400 to-blue-400 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                    </Link>
                    <button class="group px-8 py-4 border-2 border-white/30 rounded-full text-white font-semibold text-lg hover:bg-white/10 transition-all duration-300">
                        <span class="flex items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2">
                                <polygon points="5,3 19,12 5,21"/>
                            </svg>
                            Virtual Campus Tour
                        </span>
                    </button>
                </div>

                <div class="grid grid-cols-2 md:grid-cols-4 gap-8 pt-16">
                    <div class="text-center">
                        <div class="text-3xl font-bold bg-gradient-to-r from-emerald-400 to-blue-400 bg-clip-text text-transparent">500+</div>
                        <div class="text-gray-400 text-sm">Enrolled Students</div>
                    </div>
                    <div class="text-center">
                        <div class="text-3xl font-bold bg-gradient-to-r from-blue-400 to-cyan-400 bg-clip-text text-transparent">98%</div>
                        <div class="text-gray-400 text-sm">MSCE Pass Rate</div>
                    </div>
                    <div class="text-center">
                        <div class="text-3xl font-bold bg-gradient-to-r from-cyan-400 to-purple-400 bg-clip-text text-transparent">25+</div>
                        <div class="text-gray-400 text-sm">Countries Served</div>
                    </div>
                    <div class="text-center">
                        <div class="text-3xl font-bold bg-gradient-to-r from-purple-400 to-emerald-400 bg-clip-text text-transparent">12</div>
                        <div class="text-gray-400 text-sm">Core Subjects</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section id="about" class="py-32 relative">
        <div class="max-w-7xl mx-auto px-6">
            <div class="grid lg:grid-cols-2 gap-16 items-center">
                <div class="reveal">
                    <h2 class="text-5xl font-bold mb-8">
                        <span class="bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">
                            Bringing Malawi Education
                        </span>
                        <br>
                        <span class="bg-gradient-to-r from-emerald-400 to-blue-400 bg-clip-text text-transparent">
                            to the World
                        </span>
                    </h2>

                    <p class="text-xl text-gray-300 mb-8 leading-relaxed">
                        Studyseco bridges the gap for Malawian students living abroad or in remote areas who want to maintain
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
                                <h3 class="text-xl font-semibold text-white">MANEB-Certified Curriculum</h3>
                                <p class="text-gray-400">Fully aligned with Malawi National Examinations Board standards</p>
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
                                <h3 class="text-xl font-semibold text-white">Qualified Malawian Teachers</h3>
                                <p class="text-gray-400">Experienced educators from top Malawian secondary schools</p>
                            </div>
                        </div>

                        <div class="flex items-center space-x-4">
                            <div class="w-12 h-12 bg-gradient-to-r from-cyan-500 to-purple-500 rounded-xl flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-xl font-semibold text-white">MSCE Preparation</h3>
                                <p class="text-gray-400">Comprehensive preparation for Malawi School Certificate examinations</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="reveal relative">
                    <div class="glass rounded-3xl p-8 hover-lift">
                        <div class="space-y-6">
                            <div class="bg-gradient-to-r from-emerald-600/20 to-blue-600/20 rounded-2xl p-6">
                                <div class="flex items-center justify-between mb-4">
                                    <h4 class="text-white font-semibold">Student Progress - Form 3</h4>
                                    <span class="text-green-400 text-sm font-mono">MSCE Ready: 92%</span>
                                </div>
                                <div class="w-full bg-gray-700 rounded-full h-3 mb-4">
                                    <div class="bg-gradient-to-r from-emerald-500 to-blue-500 h-3 rounded-full" style="width: 92%"></div>
                                </div>
                                <div class="grid grid-cols-3 gap-4 text-center">
                                    <div>
                                        <div class="text-2xl font-bold text-emerald-400">12</div>
                                        <div class="text-xs text-gray-400">Subjects</div>
                                    </div>
                                    <div>
                                        <div class="text-2xl font-bold text-blue-400">156h</div>
                                        <div class="text-xs text-gray-400">Study Time</div>
                                    </div>
                                    <div>
                                        <div class="text-2xl font-bold text-cyan-400">A</div>
                                        <div class="text-xs text-gray-400">Avg Grade</div>
                                    </div>
                                </div>
                            </div>

                            <div class="grid grid-cols-3 gap-3">
                                <div class="bg-gradient-to-r from-yellow-500/20 to-orange-500/20 rounded-xl p-3 text-center">
                                    <div class="w-8 h-8 bg-gradient-to-r from-yellow-400 to-orange-400 rounded-full mx-auto mb-2 flex items-center justify-center">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                                        </svg>
                                    </div>
                                    <div class="text-xs text-gray-300">Top Performer</div>
                                </div>
                                <div class="bg-gradient-to-r from-emerald-500/20 to-blue-500/20 rounded-xl p-3 text-center">
                                    <div class="w-8 h-8 bg-gradient-to-r from-emerald-400 to-blue-400 rounded-full mx-auto mb-2 flex items-center justify-center">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                                            <polyline points="22,4 12,14.01 9,11.01"/>
                                        </svg>
                                    </div>
                                    <div class="text-xs text-gray-300">All Assignments</div>
                                </div>
                                <div class="bg-gradient-to-r from-blue-500/20 to-cyan-500/20 rounded-xl p-3 text-center">
                                    <div class="w-8 h-8 bg-gradient-to-r from-blue-400 to-cyan-400 rounded-full mx-auto mb-2 flex items-center justify-center">
                                        <span class="text-xs font-bold">🇲🇼</span>
                                    </div>
                                    <div class="text-xs text-gray-300">Malawi Pride</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Subjects Section -->
    <section id="subjects" class="py-32 bg-gradient-to-br from-gray-900/50 to-black/50">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center mb-20 reveal">
                <h2 class="text-5xl font-bold mb-6">
                    <span class="bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">
                        Complete Malawi Secondary
                    </span>
                    <br>
                    <span class="bg-gradient-to-r from-emerald-400 to-blue-400 bg-clip-text text-transparent">
                        School Curriculum
                    </span>
                </h2>
                <p class="text-xl text-gray-300 max-w-3xl mx-auto mb-8">
                    All subjects taught in Malawian secondary schools, from Form 1 to Form 4, preparing students for MSCE examinations and beyond.
                </p>
                <div class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-emerald-600/20 to-blue-600/20 rounded-full border border-emerald-600/30">
                    <span class="text-emerald-400 font-semibold mr-2">📜</span>
                    <span class="text-white">MANEB Approved Curriculum</span>
                </div>
            </div>

            <div class="mb-16 reveal">
                <h3 class="text-3xl font-bold text-center mb-12">
                    <span class="bg-gradient-to-r from-emerald-400 to-blue-400 bg-clip-text text-transparent">
                        Core Subjects (Compulsory)
                    </span>
                </h3>
                <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div class="subject-card glass rounded-2xl p-6 hover-lift">
                        <div class="w-16 h-16 bg-gradient-to-r from-blue-500 to-indigo-500 rounded-2xl flex items-center justify-center mb-4">
                            <span class="text-2xl">⚗️</span>
                        </div>
                        <h4 class="text-xl font-bold text-white mb-2">Physical Science</h4>
                        <p class="text-gray-300 text-sm">A combination of Physics and Chemistry</p>
                    </div>

                    <div class="subject-card glass rounded-2xl p-6 hover-lift">
                        <div class="w-16 h-16 bg-gradient-to-r from-purple-500 to-pink-500 rounded-2xl flex items-center justify-center mb-4">
                            <span class="text-2xl">📐</span>
                        </div>
                        <h4 class="text-xl font-bold text-white mb-2">Mathematics</h4>
                        <p class="text-gray-300 text-sm">Fundamental concepts and problem-solving skills</p>
                    </div>

                    <div class="subject-card glass rounded-2xl p-6 hover-lift">
                        <div class="w-16 h-16 bg-gradient-to-r from-red-500 to-orange-500 rounded-2xl flex items-center justify-center mb-4">
                            <span class="text-2xl">✍️</span>
                        </div>
                        <h4 class="text-xl font-bold text-white mb-2">English</h4>
                        <p class="text-gray-300 text-sm">Language, literature, and communication skills</p>
                    </div>

                    <div class="subject-card glass rounded-2xl p-6 hover-lift">
                        <div class="w-16 h-16 bg-gradient-to-r from-green-500 to-teal-500 rounded-2xl flex items-center justify-center mb-4">
                            <span class="text-2xl">🌍</span>
                        </div>
                        <h4 class="text-xl font-bold text-white mb-2">Social and Developmental Studies</h4>
                        <p class="text-gray-300 text-sm">History, civics, and social issues</p>
                    </div>

                    <div class="subject-card glass rounded-2xl p-6 hover-lift">
                        <div class="w-16 h-16 bg-gradient-to-r from-indigo-500 to-purple-500 rounded-2xl flex items-center justify-center mb-4">
                            <span class="text-2xl">🖥️</span>
                        </div>
                        <h4 class="text-xl font-bold text-white mb-2">Computer Studies</h4>
                        <p class="text-gray-300 text-sm">Introduction to computer science and programming</p>
                    </div>

                    <div class="subject-card glass rounded-2xl p-6 hover-lift">
                        <div class="w-16 h-16 bg-gradient-to-r from-teal-500 to-cyan-500 rounded-2xl flex items-center justify-center mb-4">
                            <span class="text-2xl">🎨</span>
                        </div>
                        <h4 class="text-xl font-bold text-white mb-2">Creative Arts</h4>
                        <p class="text-gray-300 text-sm">Visual arts, music, drama, and creative expression</p>
                    </div>
                </div>
            </div>

            <div class="mb-16 reveal">
                <h3 class="text-3xl font-bold text-center mb-12">
                    <span class="bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">
                        Optional Subjects (Choose Your Path)
                    </span>
                </h3>
                <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div class="subject-card glass rounded-2xl p-6 hover-lift">
                        <div class="w-16 h-16 bg-gradient-to-r from-emerald-500 to-blue-500 rounded-2xl flex items-center justify-center mb-4">
                            <span class="text-2xl">🧬</span>
                        </div>
                        <h4 class="text-xl font-bold text-white mb-2">Biology</h4>
                        <p class="text-gray-300 text-sm">Living organisms, ecology, and human biology</p>
                    </div>

                    <div class="subject-card glass rounded-2xl p-6 hover-lift">
                        <div class="w-16 h-16 bg-gradient-to-r from-red-500 to-orange-500 rounded-2xl flex items-center justify-center mb-4">
                            <span class="text-2xl">🧪</span>
                        </div>
                        <h4 class="text-xl font-bold text-white mb-2">Chemistry</h4>
                        <p class="text-gray-300 text-sm">Chemical reactions, elements, and compounds</p>
                    </div>

                    <div class="subject-card glass rounded-2xl p-6 hover-lift">
                        <div class="w-16 h-16 bg-gradient-to-r from-purple-500 to-pink-500 rounded-2xl flex items-center justify-center mb-4">
                            <span class="text-2xl">📈</span>
                        </div>
                        <h4 class="text-xl font-bold text-white mb-2">Commerce</h4>
                        <p class="text-gray-300 text-sm">Business principles and economic theories</p>
                    </div>

                    <div class="subject-card glass rounded-2xl p-6 hover-lift">
                        <div class="w-16 h-16 bg-gradient-to-r from-indigo-500 to-purple-500 rounded-2xl flex items-center justify-center mb-4">
                            <span class="text-2xl">🗺️</span>
                        </div>
                        <h4 class="text-xl font-bold text-white mb-2">Geography</h4>
                        <p class="text-gray-300 text-sm">Physical and human geography</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="py-32 relative overflow-hidden">
        <div class="max-w-7xl mx-auto px-6">
            <div class="text-center mb-20 reveal">
                <h2 class="text-5xl font-bold mb-6">
                    <span class="bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">
                        Features Designed
                    </span>
                    <br>
                    <span class="bg-gradient-to-r from-cyan-400 to-purple-400 bg-clip-text text-transparent">
                        For Your Success
                    </span>
                </h2>
                <p class="text-xl text-gray-300 max-w-3xl mx-auto">
                    We've built a platform that combines the best of online learning with the personal touch of a classroom.
                </p>
            </div>

            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
                <div class="feature-card glass rounded-3xl p-8 hover-lift reveal">
                    <div class="w-16 h-16 bg-gradient-to-r from-emerald-500 to-blue-500 rounded-xl flex items-center justify-center mb-6">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <path d="M14 2v6h6"/>
                            <path d="M12 18V12"/>
                            <path d="M9 15h6"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-white mb-4">Interactive E-Books</h3>
                    <p class="text-gray-300">
                        Access all your learning materials in a digital format with interactive exercises and quizzes built right in.
                    </p>
                </div>

                <div class="feature-card glass rounded-3xl p-8 hover-lift reveal" style="animation-delay: 0.1s;">
                    <div class="w-16 h-16 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-xl flex items-center justify-center mb-6">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-white mb-4">Live Q&A Sessions</h3>
                    <p class="text-gray-300">
                        Join live sessions with our teachers to ask questions and get real-time clarification on any subject.
                    </p>
                </div>

                <div class="feature-card glass rounded-3xl p-8 hover-lift reveal" style="animation-delay: 0.2s;">
                    <div class="w-16 h-16 bg-gradient-to-r from-cyan-500 to-purple-500 rounded-xl flex items-center justify-center mb-6">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <path d="M2 13.064c-.378.14-.52.564-.316.892L3.684 16.9a.86.86 0 0 0 1.25.105L8.2 13.626l4.636 5.82a.86.86 0 0 0 1.348-.138L21.492 5.09a.86.86 0 0 0-.82-.606L4.852 4.098a.86.86 0 0 0-.958.82L2 13.064z"/>
                            <path d="M17 6c.552 0 1-.448 1-1V5c0-.552-.448-1-1-1h-6c-.552 0-1 .448-1 1v1"/>
                            <path d="M12 13l2.8-2.8"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-white mb-4">Performance Analytics</h3>
                    <p class="text-gray-300">
                        Track your progress with detailed reports and insights to identify areas for improvement and celebrate your wins.
                    </p>
                </div>

                <div class="feature-card glass rounded-3xl p-8 hover-lift reveal" style="animation-delay: 0.3s;">
                    <div class="w-16 h-16 bg-gradient-to-r from-purple-500 to-pink-500 rounded-xl flex items-center justify-center mb-6">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <path d="M12 21.35l-1.45-1.32C5.4 15.35 2 12.28 2 8.5A5.5 5.5 0 0 1 7.5 3c1.74 0 3.41.81 4.5 2.15C13.09 3.81 14.76 3 16.5 3A5.5 5.5 0 0 1 22 8.5c0 3.78-3.4 6.85-8.55 11.54L12 21.35z"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-white mb-4">Mentorship & Support</h3>
                    <p class="text-gray-300">
                        Our dedicated mentors are here to guide you through your academic journey and help you stay motivated.
                    </p>
                </div>

                <div class="feature-card glass rounded-3xl p-8 hover-lift reveal" style="animation-delay: 0.4s;">
                    <div class="w-16 h-16 bg-gradient-to-r from-pink-500 to-red-500 rounded-xl flex items-center justify-center mb-6">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <path d="M10 20h4V4h-4"/>
                            <path d="M17 20h4V4h-4"/>
                            <path d="M3 20h4V4H3"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-white mb-4">Flexible Learning Schedules</h3>
                    <p class="text-gray-300">
                        Learn at your own pace, on your own time. Our pre-recorded lessons and materials are available 24/7.
                    </p>
                </div>

                <div class="feature-card glass rounded-3xl p-8 hover-lift reveal" style="animation-delay: 0.5s;">
                    <div class="w-16 h-16 bg-gradient-to-r from-red-500 to-orange-500 rounded-xl flex items-center justify-center mb-6">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                            <path d="M12 19c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"/>
                            <path d="M18 19c.552 0 1-.448 1-1s-.448-1-1-1h-2v-2c0-.552-.448-1-1-1s-1 .448-1 1v2h-2c-.552 0-1 .448-1 1s.448 1 1 1h2v2c0 .552.448 1 1 1s1-.448 1-1v-2h2c.552 0 1-.448 1-1z"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-white mb-4">Community & Collaboration</h3>
                    <p class="text-gray-300">
                        Connect with fellow students and work on group projects in our collaborative virtual campus.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="py-32 relative">
        <div class="max-w-7xl mx-auto px-6">
            <div class="grid lg:grid-cols-2 gap-16 items-center">
                <div class="reveal">
                    <h2 class="text-5xl font-bold mb-6">
                        <span class="bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">
                            Ready to Start Your
                        </span>
                        <br>
                        <span class="bg-gradient-to-r from-emerald-400 to-blue-400 bg-clip-text text-transparent">
                            Education Journey?
                        </span>
                    </h2>
                    <p class="text-xl text-gray-300 mb-8 leading-relaxed">
                        Get in touch with us to learn more about our curriculum, enrollment process, and how we can help you achieve your academic goals.
                    </p>
                    <div class="space-y-6">
                        <div class="flex items-start space-x-4">
                            <div class="w-12 h-12 bg-gradient-to-r from-emerald-500 to-blue-500 rounded-xl flex items-center justify-center flex-shrink-0">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-1-11v4h2V9h-2z"/>
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-xl font-semibold text-white">Call Us</h3>
                                <p class="text-gray-400">+265 99 123 4567</p>
                            </div>
                        </div>
                        <div class="flex items-start space-x-4">
                            <div class="w-12 h-12 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-xl flex items-center justify-center flex-shrink-0">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                                    <path d="M22 6c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6zm-2 0l-8 5-8-5m0 12V8l8 5 8-5v10"/>
                                </svg>
                            </div>
                            <div>
                                <h3 class="text-xl font-semibold text-white">Email Us</h3>
                                <p class="text-gray-400">info@studyseco.com</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="reveal">
                    <form action="#" class="glass p-8 rounded-3xl space-y-6 hover-lift">
                        <div class="space-y-2">
                            <label for="name" class="text-gray-300">Full Name</label>
                            <input type="text" id="name" name="name" placeholder="John Doe" class="w-full bg-white/5 border border-white/20 rounded-lg py-3 px-4 text-white focus:outline-none focus:ring-2 focus:ring-emerald-500 transition-colors">
                        </div>
                        <div class="space-y-2">
                            <label for="email" class="text-gray-300">Email Address</label>
                            <input type="email" id="email" name="email" placeholder="you@example.com" class="w-full bg-white/5 border border-white/20 rounded-lg py-3 px-4 text-white focus:outline-none focus:ring-2 focus:ring-emerald-500 transition-colors">
                        </div>
                        <div class="space-y-2">
                            <label for="message" class="text-gray-300">Your Message</label>
                            <textarea id="message" name="message" rows="4" placeholder="How can we help you?" class="w-full bg-white/5 border border-white/20 rounded-lg py-3 px-4 text-white focus:outline-none focus:ring-2 focus:ring-emerald-500 transition-colors"></textarea>
                        </div>
                        <button type="submit" class="w-full px-8 py-4 bg-gradient-to-r from-emerald-500 to-blue-500 text-white rounded-full font-semibold text-lg hover-lift magnetic-btn">
                            Send Message
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer Section -->
    <footer class="py-12 relative border-t border-white/10">
        <div class="max-w-7xl mx-auto px-6 text-center">
            <div class="flex items-center justify-center space-x-3 mb-4">
                <div class="w-12 h-12 rounded-xl bg-gradient-to-r from-emerald-500 to-blue-500 flex items-center justify-center pulse-glow">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="text-white">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"/>
                    </svg>
                </div>
                <span class="text-2xl font-bold bg-gradient-to-r from-white to-gray-300 bg-clip-text text-transparent">Studyseco</span>
            </div>
            <p class="text-gray-400 text-sm mb-6">
                &copy; 2024 Studyseco. All rights reserved.
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
                <a href="#" class="text-gray-400 hover:text-white transition-colors duration-300">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.75s.784-1.75 1.75-1.75 1.75.79 1.75 1.75-.784 1.75-1.75 1.75zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/></svg>
                </a>
            </div>
        </div>
    </footer>
</template>

<style>
/* Base Styles */
body {
    background: #0c0c0c;
    color: #fff;
    font-family: 'Inter', sans-serif;
    overflow-x: hidden;
}

/* Glassmorphism Effect */
.glass {
    background: rgba(255, 255, 255, 0.05);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.1);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

/* Hover Lift Effect */
.hover-lift {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.hover-lift:hover {
    transform: translateY(-8px);
    box-shadow: 0 15px 25px rgba(0, 0, 0, 0.2);
}

/* Floating Particles */
.particles {
    position: absolute;
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
    background: rgba(255, 255, 255, 0.1);
    border-radius: 50%;
    animation: floating 15s infinite;
}

@keyframes floating {
    0% { transform: translateY(0); opacity: 0.5; }
    50% { transform: translateY(-50vh); opacity: 1; }
    100% { transform: translateY(-100vh); opacity: 0.5; }
}

/* Magnetic Button Effect */
.magnetic-btn {
    transition: transform 0.1s ease-out, box-shadow 0.3s ease;
}

/* Pulse Glow Effect */
.pulse-glow {
    animation: pulse-glow 2s infinite cubic-bezier(0.4, 0, 0.6, 1);
}

@keyframes pulse-glow {
    0%, 100% {
        box-shadow: 0 0 0 0 rgba(100, 255, 255, 0.7);
    }
    50% {
        box-shadow: 0 0 0 15px rgba(100, 255, 255, 0);
    }
}

/* Scroll Reveal Effect */
.reveal {
    opacity: 0;
    transform: translateY(20px);
    transition: opacity 0.6s cubic-bezier(0.1, 0.2, 0.3, 1), transform 0.6s cubic-bezier(0.1, 0.2, 0.3, 1);
}

.reveal.active {
    opacity: 1;
    transform: translateY(0);
}

.reveal .reveal {
    transition-delay: 0.2s;
}
</style>
