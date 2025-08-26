<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed, onMounted } from 'vue';

const props = defineProps({
    auth: Object,
    lesson: Object,
});

const user = props.auth?.user || { name: 'Guest', role: 'guest', profile_photo_url: null };
const videoPlayer = ref(null);
const currentTime = ref(0);
const duration = ref(0);
const isPlaying = ref(false);
const volume = ref(1);
const showControls = ref(true);
const isFullscreen = ref(false);

const formattedCurrentTime = computed(() => formatTime(currentTime.value));
const formattedDuration = computed(() => formatTime(duration.value));
const progress = computed(() => duration.value > 0 ? (currentTime.value / duration.value) * 100 : 0);

const formatTime = (seconds) => {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = Math.floor(seconds % 60);
    
    if (hours > 0) {
        return `${hours}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    }
    return `${minutes}:${secs.toString().padStart(2, '0')}`;
};

const togglePlay = () => {
    if (videoPlayer.value) {
        if (isPlaying.value) {
            videoPlayer.value.pause();
        } else {
            videoPlayer.value.play();
        }
    }
};

const setCurrentTime = (event) => {
    const rect = event.target.getBoundingClientRect();
    const percent = (event.clientX - rect.left) / rect.width;
    const newTime = percent * duration.value;
    
    if (videoPlayer.value) {
        videoPlayer.value.currentTime = newTime;
    }
};

const changeVolume = (event) => {
    const newVolume = event.target.value / 100;
    volume.value = newVolume;
    if (videoPlayer.value) {
        videoPlayer.value.volume = newVolume;
    }
};

const toggleFullscreen = () => {
    if (!document.fullscreenElement) {
        videoPlayer.value.requestFullscreen();
        isFullscreen.value = true;
    } else {
        document.exitFullscreen();
        isFullscreen.value = false;
    }
};

const skipTime = (seconds) => {
    if (videoPlayer.value) {
        videoPlayer.value.currentTime += seconds;
    }
};

onMounted(() => {
    if (videoPlayer.value) {
        videoPlayer.value.addEventListener('loadedmetadata', () => {
            duration.value = videoPlayer.value.duration;
        });
        
        videoPlayer.value.addEventListener('timeupdate', () => {
            currentTime.value = videoPlayer.value.currentTime;
        });
        
        videoPlayer.value.addEventListener('play', () => {
            isPlaying.value = true;
        });
        
        videoPlayer.value.addEventListener('pause', () => {
            isPlaying.value = false;
        });
        
        videoPlayer.value.addEventListener('ended', () => {
            isPlaying.value = false;
        });

        // Auto-hide controls
        let controlsTimeout;
        const resetControlsTimeout = () => {
            clearTimeout(controlsTimeout);
            showControls.value = true;
            controlsTimeout = setTimeout(() => {
                if (isPlaying.value) {
                    showControls.value = false;
                }
            }, 3000);
        };

        videoPlayer.value.addEventListener('mousemove', resetControlsTimeout);
        videoPlayer.value.addEventListener('click', togglePlay);
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', (e) => {
        if (e.target.tagName.toLowerCase() === 'input' || e.target.tagName.toLowerCase() === 'textarea') {
            return;
        }
        
        switch(e.code) {
            case 'Space':
                e.preventDefault();
                togglePlay();
                break;
            case 'ArrowLeft':
                e.preventDefault();
                skipTime(-10);
                break;
            case 'ArrowRight':
                e.preventDefault();
                skipTime(10);
                break;
            case 'KeyF':
                e.preventDefault();
                toggleFullscreen();
                break;
        }
    });
});
</script>

<template>
    <Head :title="lesson.title" />
    
    <div class="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 font-sans text-slate-800">
        <!-- Header -->
        <header class="h-16 bg-white/70 backdrop-blur-xl border-b border-slate-200/50 px-6 flex items-center justify-between relative z-50">
            <div class="flex items-center space-x-4">
                <Link :href="route('subjects.show', lesson.topic.subject.id)" class="p-2 hover:bg-slate-100 rounded-xl transition-colors duration-200">
                    <svg class="w-5 h-5 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                    </svg>
                </Link>
                <div>
                    <h1 class="text-lg font-bold text-slate-800 line-clamp-1">{{ lesson.title }}</h1>
                    <p class="text-sm text-slate-500">{{ lesson.topic.subject.name }} • {{ lesson.topic.name }}</p>
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
        <div class="flex h-[calc(100vh-64px)]">
            <!-- Video Player -->
            <div class="flex-1 bg-black flex items-center justify-center relative">
                <video 
                    ref="videoPlayer"
                    :src="lesson.video_url"
                    class="w-full h-full object-contain"
                    :poster="lesson.thumbnail_url"
                >
                    Your browser does not support the video tag.
                </video>

                <!-- Custom Video Controls -->
                <div 
                    :class="[
                        'absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-6 transition-opacity duration-300',
                        showControls ? 'opacity-100' : 'opacity-0'
                    ]"
                    @mouseover="showControls = true"
                >
                    <!-- Progress Bar -->
                    <div class="mb-4">
                        <div class="w-full h-1 bg-white/30 rounded-full cursor-pointer" @click="setCurrentTime">
                            <div class="h-full bg-indigo-500 rounded-full transition-all duration-200" :style="{ width: progress + '%' }"></div>
                        </div>
                    </div>

                    <!-- Controls -->
                    <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-4">
                            <!-- Play/Pause -->
                            <button @click="togglePlay" class="p-2 hover:bg-white/20 rounded-full transition-colors duration-200">
                                <svg v-if="!isPlaying" class="w-8 h-8 text-white" fill="currentColor" viewBox="0 0 24 24">
                                    <path d="M8 5v14l11-7z"/>
                                </svg>
                                <svg v-else class="w-8 h-8 text-white" fill="currentColor" viewBox="0 0 24 24">
                                    <path d="M6 4h4v16H6zM14 4h4v16h-4z"/>
                                </svg>
                            </button>

                            <!-- Skip Buttons -->
                            <button @click="skipTime(-10)" class="p-1 hover:bg-white/20 rounded-full transition-colors duration-200">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12.066 11.2a1 1 0 000 1.6l5.334 4A1 1 0 0019 16V8a1 1 0 00-1.6-.8l-5.334 4zM4.066 11.2a1 1 0 000 1.6l5.334 4A1 1 0 0011 16V8a1 1 0 00-1.6-.8l-5.334 4z"></path>
                                </svg>
                            </button>
                            <button @click="skipTime(10)" class="p-1 hover:bg-white/20 rounded-full transition-colors duration-200">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.933 12.8a1 1 0 000-1.6L6.6 7.2A1 1 0 005 8v8a1 1 0 001.6.8l5.333-4zM19.933 12.8a1 1 0 000-1.6l-5.333-4A1 1 0 0013 8v8a1 1 0 001.6.8l5.333-4z"></path>
                                </svg>
                            </button>

                            <!-- Volume -->
                            <div class="flex items-center space-x-2">
                                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.536 8.464a5 5 0 010 7.072m-2.829-2.829a2.5 2.5 0 010-3.536M6 10H4a1 1 0 00-1 1v2a1 1 0 001 1h2l4 4V6l-4 4z"></path>
                                </svg>
                                <input type="range" min="0" max="100" :value="volume * 100" @input="changeVolume" class="w-20 accent-indigo-500">
                            </div>

                            <!-- Time -->
                            <div class="text-white text-sm">
                                {{ formattedCurrentTime }} / {{ formattedDuration }}
                            </div>
                        </div>

                        <!-- Right Controls -->
                        <div class="flex items-center space-x-2">
                            <!-- Fullscreen -->
                            <button @click="toggleFullscreen" class="p-2 hover:bg-white/20 rounded-full transition-colors duration-200">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"></path>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Loading/Error States -->
                <div v-if="!lesson.video_url" class="absolute inset-0 flex items-center justify-center bg-black">
                    <div class="text-center text-white">
                        <svg class="w-16 h-16 mx-auto mb-4 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"></path>
                        </svg>
                        <h3 class="text-lg font-semibold mb-2">Video not available</h3>
                        <p class="text-sm opacity-75">This lesson doesn't have a video file uploaded yet.</p>
                    </div>
                </div>
            </div>

            <!-- Lesson Sidebar -->
            <div class="w-96 bg-white/80 backdrop-blur-xl border-l border-slate-200/50 flex flex-col">
                <!-- Lesson Info -->
                <div class="p-6 border-b border-slate-200/50">
                    <h2 class="text-xl font-bold text-slate-800 mb-2">{{ lesson.title }}</h2>
                    <p v-if="lesson.description" class="text-slate-600 text-sm mb-4">{{ lesson.description }}</p>
                    <div class="flex items-center justify-between text-xs text-slate-500">
                        <span v-if="lesson.duration_minutes">Duration: {{ lesson.formatted_duration }}</span>
                        <span v-if="lesson.video_filename">{{ lesson.video_filename }}</span>
                    </div>
                </div>

                <!-- Lesson Notes -->
                <div v-if="lesson.notes" class="p-6 border-b border-slate-200/50">
                    <h3 class="text-lg font-semibold text-slate-800 mb-3">Lesson Notes</h3>
                    <div class="bg-slate-50 rounded-2xl p-4">
                        <p class="text-sm text-slate-700 whitespace-pre-wrap">{{ lesson.notes }}</p>
                    </div>
                </div>

                <!-- Keyboard Shortcuts -->
                <div class="p-6 border-b border-slate-200/50">
                    <h3 class="text-lg font-semibold text-slate-800 mb-3">Keyboard Shortcuts</h3>
                    <div class="space-y-2 text-sm">
                        <div class="flex justify-between">
                            <span class="text-slate-600">Play/Pause</span>
                            <span class="bg-slate-100 px-2 py-1 rounded text-slate-800 font-mono">Space</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-slate-600">Skip back 10s</span>
                            <span class="bg-slate-100 px-2 py-1 rounded text-slate-800 font-mono">←</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-slate-600">Skip forward 10s</span>
                            <span class="bg-slate-100 px-2 py-1 rounded text-slate-800 font-mono">→</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-slate-600">Fullscreen</span>
                            <span class="bg-slate-100 px-2 py-1 rounded text-slate-800 font-mono">F</span>
                        </div>
                    </div>
                </div>

                <!-- Navigation -->
                <div class="flex-1 p-6">
                    <h3 class="text-lg font-semibold text-slate-800 mb-3">Subject Navigation</h3>
                    <div class="space-y-2">
                        <Link :href="route('subjects.show', lesson.topic.subject.id)" 
                              class="flex items-center space-x-3 p-3 rounded-xl hover:bg-slate-100 transition-colors duration-200">
                            <svg class="w-5 h-5 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13.447m0-13.447l6.818-4.757M12 6.253l-6.818-4.757m6.818 4.757l-.547 4.197"></path>
                            </svg>
                            <div>
                                <p class="font-semibold text-slate-800">{{ lesson.topic.subject.name }}</p>
                                <p class="text-xs text-slate-500">Back to subject</p>
                            </div>
                        </Link>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>