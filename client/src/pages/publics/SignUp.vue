<template>
  <div class="min-h-screen bg-gradient-to-r from-indigo-900 to-red-800 py-8 px-4">
    <div class="max-w-2xl mx-auto px-6">
      <!-- Header -->
      <div class="bg-white rounded-lg shadow-lg p-8 mb-10">
        <h1 class="text-3xl font-bold text-gray-800">Sign Up</h1>
        <p class="text-gray-600 mt-2">Create your account to join games</p>
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
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Username</label>
              <input v-model="formData.username" type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Phone Number</label>
              <input v-model="formData.phone_number" type="text"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Age</label>
              <select v-model="formData.age"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <option value="">Select Age</option>
                <option v-for="age in ageOptions" :key="age" :value="age">{{ age }}</option>
              </select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Gender</label>
              <select v-model="formData.gender"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                <option value="">Select Gender</option>
                <option v-for="gender in genderOptions" :key="gender.value" :value="gender.value">{{ gender.label }}
                </option>
              </select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
              <input v-model="formData.password" type="password"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Password Confirmation</label>
              <input v-model="formData.password_confirmation" type="password"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            </div>

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
          </div>

          <button type="submit"
            class="w-full py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition-colors">
            Sign Up
          </button>

          <div class="text-center mt-4">
            <p class="text-gray-600">
              Already have an account?
              <router-link to="/signIn" class="text-blue-600 hover:text-blue-700">Sign In</router-link>
            </p>
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
            Your account has been created successfully. You can now sign in.
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

const ageOptions = Array.from({ length: 43 }, (_, i) => i + 18);
const genderOptions = [
  { value: 1, label: 'Male' },
  { value: 2, label: 'Female' },
]

const showSuccessPopup = ref(false)
const errors = ref([])
const districts = ref([])
const streets = ref([])

const formData = ref({
  username: '',
  phone_number: '',
  gender: '',
  password: '',
  password_confirmation: '',
  district_id: '',
  street_id: '',
  age: '',
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

watch(() => formData.value.district_id, () => {
  if (formData.value.district_id) {
    formData.value.street_id = ''
    fetchStreets(formData.value.district_id)
  }
})

const handleSubmit = async () => {
  try {
    errors.value = []
    await apiClient.post('/api/public/players/register', { player: formData.value })
    showSuccessPopup.value = true
  } catch (error) {
    console.error('Error during sign up:', error)
    if (error.response?.data?.errors) {
      errors.value = error.response.data.errors
    } else {
      errors.value = ['An unexpected error occurred. Please try again.']
    }
  }
}

const closePopup = () => {
  showSuccessPopup.value = false
  router.push('/signIn')
}

onMounted(() => {
  fetchDistricts()
})
</script>
