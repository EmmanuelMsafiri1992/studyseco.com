<template>
  <div class="lesson-card">
    <div class="lesson-details">
      <h4 class="lesson-title">{{ lesson.title }}</h4>
      <span class="lesson-duration">{{ lesson.duration }}</span>
    </div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue';

defineProps({
  lesson: {
    type: Object,
    required: true
  }
});
</script>

<style scoped>
.lesson-card {
  padding: 1.5rem;
  margin-bottom: 1rem;
  background-color: #f1f3f5;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  transition: transform 0.2s ease;
  cursor: pointer;
}

.lesson-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 10px rgba(0, 0, 0, 0.1);
}

.lesson-details {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.lesson-title {
  margin: 0;
  font-size: 1.1rem;
  color: #2c3e50;
  font-weight: 600;
}

.lesson-duration {
  font-size: 0.9rem;
  color: #6c757d;
  background-color: #e9ecef;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
}
</style>
