<template>
  <div class="min-h-screen bg-gradient-to-r from-indigo-900 to-red-800 py-8 px-4">
    <div class="max-w-md mx-auto">
      <div class="bg-white rounded-2xl shadow-lg p-8">
        <h1 class="text-3xl font-bold text-indigo-900 text-center mb-2">Welcome Back</h1>
        <p class="text-gray-600 text-center mb-8">Sign in to your account</p>

        <form @submit.prevent="handleSubmit" class="space-y-6">
          <!-- Phone Number -->
          <div>
            <label for="phone" class="block text-sm font-medium text-indigo-900 mb-2">Phone Number</label>
            <input type="tel" id="phone" v-model="formData.phone"
              class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:border-indigo-900 focus:outline-none transition-colors"
              placeholder="Enter your phone number" required>
          </div>

          <!-- Password -->
          <div>
            <label for="password" class="block text-sm font-medium text-indigo-900 mb-2">Password</label>
            <input type="password" id="password" v-model="formData.password"
              class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:border-indigo-900 focus:outline-none transition-colors"
              placeholder="Enter your password" required>
          </div>

          <button type="submit"
            class="w-full py-4 bg-indigo-900 text-white text-lg font-medium rounded-lg hover:bg-indigo-800 transition-colors">
            Sign In
          </button>
        </form>

        <p class="text-center text-gray-600 mt-6">
          Don't have an account?
          <router-link to="/signUp" class="text-indigo-600 hover:underline">Sign up</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const formData = ref({
  phone: '',
  password: ''
})

const handleSubmit = async () => {
  try {
    // Add your API call here
    console.log('Form submitted:', formData.value)
    // Redirect to dashboard or home page after successful login
    router.push('/')
  } catch (error) {
    console.error('Login failed:', error)
  }
}
</script>
