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
        <input
          v-model="form.username"
          type="text"
          id="username"
          placeholder="Enter username"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
      </div>

      <div class="space-y-2">
        <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
        <input
          v-model="form.password"
          type="password"
          id="password"
          placeholder="Enter password"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
      </div>

      <div class="space-y-2">
        <label for="passwordConfirmation" class="block text-sm font-medium text-gray-700">Verify Password</label>
        <input
          v-model="form.passwordConfirmation"
          type="password"
          id="passwordConfirmation"
          placeholder="Confirm password"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
      </div>

      <button
        type="submit"
        class="w-full px-4 py-2 text-white bg-blue-600 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed"
        :disabled="isSubmitting"
      >
        {{ isSubmitting ? 'Creating...' : 'Create Manager' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from '../../../axios.js'

const route = useRoute()
const router = useRouter()
const clubId = route.params.id

const form = ref({
  username: '',
  password: '',
  passwordConfirmation: ''
})

const isSubmitting = ref(false)
const errors = ref([])

const submitForm = async () => {
  isSubmitting.value = true
  errors.value = []

  try {
    const payload = {
      username: form.value.username,
      password: form.value.password,
      password_confirmation: form.value.passwordConfirmation,
    }

    await axios.post(`/api/admin/clubs/${clubId}/managers`, { club_manager: payload })
    alert("Manager created successfully")
    router.push(`/admin/clubs/${clubId}/managers`)
  } catch (error) {
    if (error.response && error.response.data.errors) {
      errors.value = error.response.data.errors
    } else {
      console.error('Error creating manager:', error)
      errors.value = ['Failed to create manager']
    }
  } finally {
    isSubmitting.value = false
  }
}
</script>
