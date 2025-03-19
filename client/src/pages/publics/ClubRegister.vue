<template>
  <div class="min-h-screen bg-gradient-to-r from-indigo-900 to-red-800 py-8 px-4">
    <div class="max-w-2xl mx-auto px-6">
      <!-- Header -->
      <div class="bg-white rounded-lg shadow-lg p-8 mb-10">
        <h1 class="text-3xl font-bold text-gray-800">Register Your Club</h1>
        <p class="text-gray-600 mt-2">Join our platform and reach more players</p>
      </div>

      <!-- Registration Form -->
      <div class="bg-white rounded-lg shadow-lg p-8">
        <!-- Error Messages -->
        <div v-if="errors.length > 0" class="mb-6 bg-red-50 border border-red-200 rounded-lg p-4">
          <h3 class="text-red-800 font-medium mb-2">Please fix the following errors:</h3>
          <ul class="list-disc pl-5 text-red-700">
            <li v-for="(error, index) in errors" :key="index" class="mb-1">{{ error }}</li>
          </ul>
        </div>

        <form @submit.prevent="handleSubmit" class="space-y-6">
          <!-- Basic Info -->
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Club Name</label>
              <input v-model="formData.name" type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Email Address</label>
              <input v-model="formData.email" type="email"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
              <textarea v-model="formData.description" rows="4"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"></textarea>
            </div>
          </div>

          <!-- Location -->
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">District</label>
              <select v-model="formData.district_id"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <option value="">Select District</option>
                <option v-for="district in districts" :key="district.id" :value="district.id">
                  {{ district.name }}
                </option>
              </select>
            </div>

            <div v-if="formData.district_id">
              <label class="block text-sm font-medium text-gray-700 mb-1">Street</label>
              <select v-model="formData.street_id"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <option value="">Select Street</option>
                <option v-for="street in streets" :key="street.id" :value="street.id">
                  {{ street.name }}
                </option>
              </select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Full Address</label>
              <input v-model="formData.address" type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            </div>
          </div>

          <button type="submit"
            class="w-full py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition-colors">
            Register Club
          </button>

          <!-- add sign in to redirect to login page -->
          <div class="flex justify-center">
            <div class="text-center">
              <p class="text-sm text-gray-500">Already have an account? <a href="/club/signIn"
                  class="text-blue-600 hover:underline">Sign in</a></p>
            </div>
          </div>
        </form>
      </div>
    </div>

    <!-- Success Popup -->
    <div v-if="showSuccessPopup" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-lg shadow-xl p-8 max-w-md w-full">
        <div class="text-center">
          <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100 mb-4">
            <svg class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </div>
          <h3 class="text-xl font-bold text-gray-900 mb-2">Registration Successful!</h3>
          <p class="text-gray-600 mb-6">
            Thank you for registering your club. Our admin team will review your application and send further
            instructions to {{ formData.email }}
          </p>
          <button @click="closePopup"
            class="w-full py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition-colors">
            Got it!
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import apiClient from '../../axios'

const router = useRouter()
const showSuccessPopup = ref(false)
const districts = ref([])
const streets = ref([])
const errors = ref([])

const formData = ref({
  name: '',
  email: '',
  description: '',
  district_id: '',
  street_id: '',
  address: ''
})

const fetchDistricts = async () => {
  try {
    const response = await apiClient.get('/api/public/districts')
    districts.value = response.data
  } catch (error) {
    console.error('Error fetching districts:', error)
  }
}

const fetchStreets = async (districtId) => {
  try {
    const response = await apiClient.get('/api/public/streets?district_id=' + districtId)
    streets.value = response.data
  } catch (error) {
    console.error('Error fetching streets:', error)
  }
}

const handleSubmit = async () => {
  try {
    errors.value = [] // Clear previous errors
    await apiClient.post('/api/public/clubs/register', { club: formData.value })
    showSuccessPopup.value = true
  } catch (error) {
    console.error('Error registering club:', error)
    if (error.response && error.response.data && error.response.data.errors) {
      errors.value = error.response.data.errors
    } else {
      errors.value = ['An unexpected error occurred. Please try again.']
    }
  }
}

const closePopup = () => {
  showSuccessPopup.value = false
  router.push('/clubs') // Redirect to clubs listing page
}

watch(() => formData.value.district_id, () => {
  fetchStreets(formData.value.district_id)
})

onMounted(() => {
  fetchDistricts()
})
</script>
