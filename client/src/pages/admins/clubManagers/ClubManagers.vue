<template>
  <div class="club-managers">
    <div class="header">
      <h1>Club Managers</h1>
      <button class="create-btn" @click="navigateToCreate">Add Manager</button>
    </div>

    <div class="search-container">
      <div class="search-box">
        <input
          v-model="searchTerm"
          class="search-input"
          type="text"
          placeholder="Search by manager name..."
        />
      </div>
    </div>

    <table class="managers-table">
      <thead>
        <tr>
          <th>Username</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="manager in filteredManagers" :key="manager.id">
          <td>{{ manager.username }}</td>
          <td>
            <button class="action-btn" @click="navigateToEdit(manager.id)">Edit</button>
            <button class="action-btn delete" @click="confirmDelete(manager)">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '../../../axios.js'

const route = useRoute()
const router = useRouter()
const clubId = route.params.id
const managers = ref([])
const searchTerm = ref('')

const filteredManagers = computed(() => {
  if (!searchTerm.value) return managers.value
  return managers.value.filter(manager =>
    manager.name.toLowerCase().includes(searchTerm.value.toLowerCase())
  )
})

const fetchManagers = async () => {
  try {
    const response = await axios.get(`/api/admin/clubs/${clubId}/managers`)
    managers.value = response.data
  } catch (error) {
    console.error('Error fetching managers:', error)
  }
}

const navigateToCreate = () => {
  router.push(`/admin/clubs/${clubId}/managers/new`)
}

const navigateToEdit = (managerId) => {
  router.push(`/admin/clubs/${clubId}/managers/${managerId}/edit`)
}

const confirmDelete = (manager) => {
  if (confirm(`Are you sure you want to delete ${manager.name}?`)) {
    deleteManager(manager.id)
  }
}

const deleteManager = async (managerId) => {
  try {
    await axios.delete(`/api/admin/clubs/${clubId}/managers/${managerId}`)
    await fetchManagers()
  } catch (error) {
    console.error('Error deleting manager:', error)
    alert('Failed to delete manager')
  }
}

onMounted(() => {
  fetchManagers()
})
</script>

<style scoped>
@import '../../../assets/styles/admins/club-managers.css';
</style>
