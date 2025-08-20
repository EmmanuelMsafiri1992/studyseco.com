<template>
  <div class="subject-container">
    <aside class="sidebar-container">
      <h2 class="sidebar-title">Subject Content</h2>
      <TopicSidebar :topics="subjectData.topics" @select-topic="handleTopicSelection" />
    </aside>
    <main class="main-content-area">
      <div v-if="selectedTopic" class="topic-section">
        <h3 class="topic-title">{{ selectedTopic.title }}</h3>
        <ul class="lessons-list">
          <li v-for="lesson in selectedTopic.lessons" :key="lesson.id">
            <LessonCard :lesson="lesson" />
          </li>
        </ul>
      </div>
      <div v-else class="welcome-message">
        <p>Select a topic to get started!</p>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import TopicSidebar from './TopicSidebar.vue';
import LessonCard from './LessonCard.vue';

// Mock data for the subject
const subjectData = {
  id: 1,
  title: 'High School Chemistry',
  topics: [
    {
      id: 101,
      title: 'Introduction to Elements',
      lessons: [
        { id: 1001, title: 'What is an Atom?', duration: '5 min' },
        { id: 1002, title: 'The Periodic Table', duration: '8 min' },
        { id: 1003, title: 'Chemical Bonds', duration: '6 min' }
      ]
    },
    {
      id: 102,
      title: 'Chemical Reactions',
      lessons: [
        { id: 1004, title: 'Balancing Equations', duration: '10 min' },
        { id: 1005, title: 'Types of Reactions', duration: '7 min' },
        { id: 1006, title: 'Acids and Bases', duration: '9 min' }
      ]
    }
  ]
};

const selectedTopic = ref(null);

const handleTopicSelection = (topicId) => {
  selectedTopic.value = subjectData.topics.find(topic => topic.id === topicId);
};
</script>

<style scoped>
.subject-container {
  display: flex;
  min-height: 100vh;
  font-family: sans-serif;
  color: #333;
}

.sidebar-container {
  width: 300px;
  background-color: #f8f9fa;
  padding: 2rem;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
  overflow-y: auto;
}

.sidebar-title {
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  color: #2c3e50;
  border-bottom: 2px solid #e9ecef;
  padding-bottom: 0.5rem;
}

.main-content-area {
  flex-grow: 1;
  padding: 2rem;
  background-color: #ffffff;
}

.welcome-message {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  font-size: 1.2rem;
  color: #6c757d;
}

.topic-title {
  font-size: 2rem;
  color: #34495e;
  margin-bottom: 1.5rem;
}

.lessons-list {
  list-style: none;
  padding: 0;
}
</style>
