<template>
  <Transition
    enter-active-class="transition ease-out duration-300"
    enter-from-class="transform opacity-0 scale-95"
    enter-to-class="transform opacity-100 scale-100"
    leave-active-class="transition ease-in duration-200"
    leave-from-class="transform opacity-100 scale-100"
    leave-to-class="transform opacity-0 scale-95"
  >
    <div
      v-if="show"
      class="fixed top-0 right-0 z-[10000] flex items-center p-4 rounded-lg shadow-lg m-4"
      :class="{
        'bg-green-100 text-green-800': type === 'success',
        'bg-red-100 text-red-800': type === 'error',
        'bg-yellow-100 text-yellow-800': type === 'warning',
        'bg-blue-100 text-blue-800': type === 'info',
      }"
    >
      <div class="flex-shrink-0 mr-3">
        <!-- Success Icon -->
        <svg
          v-if="type === 'success'"
          class="w-5 h-5"
          fill="currentColor"
          viewBox="0 0 20 20"
        >
          <path
            fill-rule="evenodd"
            d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
            clip-rule="evenodd"
          />
        </svg>
        <!-- Error Icon -->
        <svg
          v-if="type === 'error'"
          class="w-5 h-5"
          fill="currentColor"
          viewBox="0 0 20 20"
        >
          <path
            fill-rule="evenodd"
            d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
            clip-rule="evenodd"
          />
        </svg>
      </div>
      <div class="text-sm font-medium">{{ message }}</div>
    </div>
  </Transition>
</template>

<script setup>
import { ref, watch } from "vue";

const props = defineProps({
  show: {
    type: Boolean,
    default: false,
  },
  message: {
    type: String,
    required: true,
  },
  type: {
    type: String,
    default: "success",
    validator: (value) =>
      ["success", "error", "warning", "info"].includes(value),
  },
  duration: {
    type: Number,
    default: 3000,
  },
});

const emit = defineEmits(["update:show"]);

watch(
  () => props.show,
  (newVal) => {
    if (newVal && props.duration > 0) {
      setTimeout(() => {
        emit("update:show", false);
      }, props.duration);
    }
  }
);
</script>
