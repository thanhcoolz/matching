<template>
  <div class="pagination">
    <button
      class="pagination-btn"
      :disabled="currentPage === 1"
      @click="handlePageChange(currentPage - 1)"
    >
      Previous
    </button>
    <span class="page-info">
      Page {{ currentPage }} of {{ totalPages }}
    </span>
    <button
      class="pagination-btn"
      :disabled="currentPage === totalPages"
      @click="handlePageChange(currentPage + 1)"
    >
      Next
    </button>
    <select
      class="per-page-select"
      :value="perPage"
      @change="handlePerPageChange($event)"
    >
      <option value="10">10 per page</option>
      <option value="20">20 per page</option>
      <option value="50">50 per page</option>
      <option value="100">100 per page</option>
    </select>
  </div>
</template>

<script setup>
defineProps({
  currentPage: {
    type: Number,
    required: true
  },
  totalPages: {
    type: Number,
    required: true
  },
  perPage: {
    type: Number,
    required: true
  }
})

const emit = defineEmits(['page-change', 'per-page-change'])

const handlePageChange = (page) => {
  emit('page-change', page)
}

const handlePerPageChange = (event) => {
  emit('per-page-change', Number(event.target.value))
}
</script>

<style scoped>
.pagination {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-top: 1rem;
}

.pagination-btn {
  padding: 0.5rem 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  background-color: #fff;
  cursor: pointer;
}

.pagination-btn:disabled {
  background-color: #eee;
  cursor: not-allowed;
}

.per-page-select {
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}
</style>
