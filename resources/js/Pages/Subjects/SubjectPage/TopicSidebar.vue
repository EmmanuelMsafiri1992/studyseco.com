<template>
  <nav>
    <ul class="topic-list">
      <li v-for="topic in topics" :key="topic.id" @click="$emit('select-topic', topic.id)" class="topic-item">
        {{ topic.title }}
      </li>
    </ul>
  </nav>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue';

defineProps({
  topics: {
    type: Array,
    required: true
  }
});

defineEmits(['select-topic']);
</script>

<style scoped>
.topic-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.topic-item {
  padding: 1rem;
  cursor: pointer;
  border-bottom: 1px solid #dee2e6;
  transition: background-color 0.2s ease;
  font-weight: 500;
  color: #495057;
}

.topic-item:last-child {
  border-bottom: none;
}

.topic-item:hover {
  background-color: #e9ecef;
}
</style>
