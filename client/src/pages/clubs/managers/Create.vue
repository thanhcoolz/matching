<template>
  <div class="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-md">
    <h1 class="text-2xl font-bold mb-6 text-gray-800">Add New Manager</h1>
    <form @submit.prevent="submitForm" class="space-y-6">
      <div v-if="errors.length" class="bg-red-50 p-4 rounded-md">
        <ul class="text-sm text-red-600 space-y-1">
          <li v-for="error in errors" :key="error">{{ error }}</li>
        </ul>
      </div>

      <div class="space-y-2">
        <label for="username" class="block text-sm font-medium text-gray-700">Username</label>
        <input v-model="form.username" type="text" id="username" placeholder="Enter username"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
      </div>

      <div class="space-y-2">
        <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
        <input v-model="form.password" type="password" id="password" placeholder="Enter password"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
      </div>

      <div class="space-y-2">
        <label for="passwordConfirmation" class="block text-sm font-medium text-gray-700">Confirm Password</label>
        <input v-model="form.passwordConfirmation" type="password" id="passwordConfirmation"
          placeholder="Confirm password"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
      </div>

      <div class="flex justify-end space-x-3">
        <button type="button" @click="router.back()"
          class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500">
          Cancel
        </button>
        <button type="submit"
          class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
          :disabled="loading">
          <span v-if="loading">Creating...</span>
          <span v-else>Create Manager</span>
        </button>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import axios from '../../../axios'

const router = useRouter()
const errors = ref([])
const loading = ref(false)
const form = ref({
  username: '',
  password: '',
  passwordConfirmation: ''
})

const submitForm = async () => {
  loading.value = true
  errors.value = []

  try {
    await axios.post('/api/club/managers', {
      club_manager: {
        username: form.value.username,
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
</script>
