<template>
  <div v-if="path" class="bg-neutral-100 dark:bg-neutral-850 w-full py-4 px-6 rounded-xl ring-1 ring-neutral-200 dark:ring-neutral-750 overflow-hidden relative" :class="[ props.customClass ]">
    <div class="text-center">
      <span class="text-neutral-800 dark:text-neutral-200 font-medium" :title="path">{{ fileName }}</span>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  path: { type: String, default: null },
  customClass: { type: String, default: null }
});

// Extract the file name from the path
const fileName = computed(() => {
  if (!props.path) return '';
  return props.path.split('/').pop(); // Get the last part of the path as the file name
});
</script>
