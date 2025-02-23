<template>
  <div class="pagination">
    <button class="pagination-btn" :disabled="currentPage === 1" @click="handlePageChange(currentPage - 1)">
      Previous
    </button>
    <span class="page-info">
      Page {{ currentPage }} of {{ totalPages }}
    </span>
    <button class="pagination-btn" :disabled="currentPage === totalPages" @click="handlePageChange(currentPage + 1)">
      Next
    </button>
  </div>
</template>

<script setup>
const props = defineProps({
  currentPage: {
    type: Number,
    required: true
  },
  totalPages: {
    type: Number,
    required: true
  },
})

const emit = defineEmits(['page-change', 'per-page-change'])

const handlePageChange = (page) => {
  emit('page-change', page)
}
</script>

<style scoped>
.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1.5rem;
  margin: 2rem 0;
  padding: 1rem;
  background-color: #f8f9fa;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.pagination-btn {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 6px;
  background-color: #007bff;
  color: white;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.pagination-btn:hover:not(:disabled) {
  background-color: #0056b3;
  transform: translateY(-1px);
}

.pagination-btn:disabled {
  background-color: #6c757d;
  cursor: not-allowed;
  opacity: 0.7;
}

.page-info {
  font-size: 1.1rem;
  font-weight: 500;
  color: #495057;
}

.per-page-select {
  padding: 0.5rem 1rem;
  border: 1px solid #ced4da;
  border-radius: 6px;
  background-color: white;
  font-size: 1rem;
  cursor: pointer;
  transition: border-color 0.2s ease;
  color: black;
}

.per-page-select:hover {
  border-color: #007bff;
}

.per-page-select:focus {
  outline: none;
  border-color: #007bff;
  box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25);
}

.per-page-select option {
  color: black;
}
</style>
