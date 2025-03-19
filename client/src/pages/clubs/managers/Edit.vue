<template>
  <div class="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-md">
    <h1 class="text-2xl font-bold mb-6 text-gray-800">Edit Manager Password</h1>
    <form @submit.prevent="submitForm" class="space-y-6">
      <div v-if="errors.length" class="bg-red-50 p-4 rounded-md">
        <ul class="text-sm text-red-600 space-y-1">
          <li v-for="error in errors" :key="error">{{ error }}</li>
        </ul>
      </div>

      <div class="space-y-2">
        <label class="block text-sm font-medium text-gray-700">Username</label>
        <div class="text-gray-900 py-2">{{ manager.username }}</div>
      </div>

      <div class="space-y-2">
        <label for="password" class="block text-sm font-medium text-gray-700">New Password</label>
        <input
          v-model="form.password"
          type="password"
          id="password"
          placeholder="Enter new password"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
      </div>

      <div class="space-y-2">
        <label for="passwordConfirmation" class="block text-sm font-medium text-gray-700">Confirm New Password</label>
        <input
          v-model="form.passwordConfirmation"
          type="password"
          id="passwordConfirmation"
          placeholder="Confirm new password"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
      </div>

      <div class="flex justify-end space-x-3">
        <button
          type="button"
          @click="router.back()"
          class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          Cancel
        </button>
        <button
          type="submit"
          class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
          :disabled="loading"
        >
          <span v-if="loading">Updating...</span>
          <span v-else>Update Password</span>
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import axios from '../../../axios'

const router = useRouter()
const route = useRoute()
const errors = ref([])
const loading = ref(false)
const manager = ref({})
const form = ref({
  password: '',
  passwordConfirmation: ''
})

const fetchManager = async () => {
  try {
    const response = await axios.get(`/api/club/managers/${route.params.id}`)
    manager.value = response.data
  } catch (error) {
    console.error('Error fetching manager:', error)
    router.push('/club/managers')
  }
}

const submitForm = async () => {
  loading.value = true
  errors.value = []

  try {
    await axios.patch(`/api/club/managers/${route.params.id}`, {
      club_manager: {
        password: form.value.password,
        password_confirmation: form.value.passwordConfirmation
      }
    })

    router.push('/club/managers')
  } catch (error) {
    if (error.response?.data?.errors) {
      errors.value = error.response.data.errors
    } else {
      errors.value = ['An unexpected error occurred']
    }
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchManager()
})
</script>
