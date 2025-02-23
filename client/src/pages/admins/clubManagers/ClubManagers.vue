<template>
  <div class="p-5">
    <div class="flex justify-between items-center mb-5">
      <h1 class="text-xl font-semibold text-gray-800">Club Managers</h1>
      <button
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
        @click="navigateToCreate"
      >
        Add Manager
      </button>
    </div>

    <div class="mb-6">
      <div class="mb-4">
        <input
          v-model="search.username"
          type="text"
          placeholder="Search by manager name..."
          @input="fetchManagers"
          class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
      </div>
    </div>

    <table class="w-full border border-gray-200 rounded-lg overflow-hidden">
      <thead class="bg-gray-50">
        <tr>
          <th class="px-6 py-3 text-left text-sm font-medium text-gray-500 uppercase tracking-wider">Username</th>
          <th class="px-6 py-3 text-left text-sm font-medium text-gray-500 uppercase tracking-wider">Actions</th>
        </tr>
      </thead>
      <tbody class="bg-white divide-y divide-gray-200">
        <tr v-for="manager in managers" :key="manager.id" class="hover:bg-gray-50 transition-colors">
          <td class="px-6 py-4 text-sm text-gray-900">{{ manager.username }}</td>
          <td class="px-6 py-4 text-sm text-gray-900 space-x-2">
            <button
              class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
              @click="navigateToEdit(manager.id)"
            >
              Edit
            </button>
            <button
              class="bg-red-600 text-white px-3 py-1 rounded hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500"
              @click="confirmDelete(manager)"
            >
              Delete
            </button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '../../../axios.js'

const route = useRoute()
const router = useRouter()
const clubId = route.params.id
const managers = ref([])
const search = ref({
  username: null
})

const fetchManagers = async () => {
  try {

    const response = await axios.get(`/api/admin/clubs/${clubId}/managers`, { params: { ...search.value } })
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
