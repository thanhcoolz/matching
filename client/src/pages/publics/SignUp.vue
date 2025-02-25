<template>
  <div class="min-h-screen bg-gradient-to-r from-indigo-900 to-red-800 py-8 px-4">
    <div class="max-w-2xl mx-auto">
      <div class="bg-white rounded-2xl shadow-lg p-8">
        <h1 class="text-3xl font-bold text-indigo-900 text-center mb-2">Join Our Community</h1>
        <p class="text-gray-600 text-center mb-8">Create your account to start matching</p>

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
              placeholder="Create a password" required>
          </div>

          <!-- Password Confirmation -->
          <div>
            <label for="passwordConfirmation" class="block text-sm font-medium text-indigo-900 mb-2">Confirm
              Password</label>
            <input type="password" id="passwordConfirmation" v-model="formData.passwordConfirmation"
              class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:border-indigo-900 focus:outline-none transition-colors"
              placeholder="Confirm your password" required>
          </div>

          <!-- Age -->
          <div>
            <label for="age" class="block text-sm font-medium text-indigo-900 mb-2">Age</label>
            <select id="age" v-model="formData.age"
              class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:border-indigo-900 focus:outline-none transition-colors"
              required>
              <option value="" disabled selected>Select your age</option>
              <option v-for="age in ageRange" :key="age" :value="age">{{ age }}</option>
            </select>
          </div>

          <!-- Gender -->
          <div>
            <label class="block text-sm font-medium text-indigo-900 mb-2">Gender</label>
            <div class="flex gap-8">
              <label class="flex items-center gap-2 cursor-pointer">
                <input type="radio" v-model="formData.gender" value="male"
                  class="w-4 h-4 text-indigo-900 focus:ring-indigo-900" required>
                <span class="text-gray-700">Male</span>
              </label>
              <label class="flex items-center gap-2 cursor-pointer">
                <input type="radio" v-model="formData.gender" value="female"
                  class="w-4 h-4 text-indigo-900 focus:ring-indigo-900" required>
                <span class="text-gray-700">Female</span>
              </label>
            </div>
          </div>

          <!-- District -->
          <div>
            <label for="district" class="block text-sm font-medium text-indigo-900 mb-2">District</label>
            <select id="district" v-model="formData.districtId"
              class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:border-indigo-900 focus:outline-none transition-colors"
              @change="handleDistrictChange" required>
              <option value="" disabled selected>Select your district</option>
              <option v-for="district in districts" :key="district.id" :value="district.id">
                {{ district.name }}
              </option>
            </select>
          </div>

          <!-- Street -->
          <div>
            <label for="street" class="block text-sm font-medium text-indigo-900 mb-2">Street</label>
            <select id="street" v-model="formData.streetId"
              class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:border-indigo-900 focus:outline-none transition-colors"
              required>
              <option value="" disabled selected>Select your street</option>
              <option v-for="street in streets" :key="street.id" :value="street.id">
                {{ street.name }}
              </option>
            </select>
          </div>

          <button type="submit"
            class="w-full py-4 bg-indigo-900 text-white text-lg font-medium rounded-lg hover:bg-indigo-800 transition-colors">
            Create Account
          </button>
        </form>

        <p class="text-center text-gray-600 mt-6">
          Already have an account?
          <router-link to="/signIn" class="text-indigo-600 hover:underline">Sign in</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const formData = ref({
  phone: '',
  password: '',
  passwordConfirmation: '',
  age: '',
  gender: '',
  districtId: '',
  streetId: ''
})

// Generate age range from 18 to 80
const ageRange = computed(() => {
  return Array.from({ length: 63 }, (_, i) => i + 18)
})

// Dummy data for districts
const districts = ref([
  { id: 1, name: 'District 1' },
  { id: 2, name: 'District 2' },
  { id: 3, name: 'District 3' },
  { id: 4, name: 'District 4' },
])

// Dummy data for streets
const streets = ref([
  { id: 1, name: 'Street A', districtId: 1 },
  { id: 2, name: 'Street B', districtId: 1 },
  { id: 3, name: 'Street C', districtId: 2 },
  { id: 4, name: 'Street D', districtId: 2 },
])

const handleDistrictChange = () => {
  formData.value.streetId = '' // Reset street selection when district changes
}

const handleSubmit = async () => {
  try {
    // Add your API call here
    console.log('Form submitted:', formData.value)
    // Redirect to success page or login
    router.push('/login')
  } catch (error) {
    console.error('Signup failed:', error)
  }
}
</script>

<style scoped>
.signup-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #1a2a6c, #b21f1f);
  padding: 2rem;
}

.form-section {
  max-width: 600px;
  margin: 0 auto;
  padding: 2rem;
}

.form-container {
  background: white;
  padding: 2rem;
  border-radius: 1rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.form-title {
  font-size: 2rem;
  color: #1a2a6c;
  text-align: center;
  margin-bottom: 0.5rem;
}

.form-subtitle {
  text-align: center;
  color: #666;
  margin-bottom: 2rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #1a2a6c;
  font-weight: 500;
}

.form-input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 0.5rem;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.form-input:focus {
  outline: none;
  border-color: #1a2a6c;
}

.gender-options {
  display: flex;
  gap: 2rem;
}

.radio-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
}

.submit-btn {
  width: 100%;
  padding: 1rem;
  background: #1a2a6c;
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-size: 1.1rem;
  cursor: pointer;
  transition: background-color 0.3s;
}

.submit-btn:hover {
  background: #283c8e;
}

.login-link {
  text-align: center;
  margin-top: 1.5rem;
  color: #666;
}

@media (max-width: 768px) {
  .form-section {
    padding: 1rem;
  }

  .form-container {
    padding: 1.5rem;
  }

  .form-title {
    font-size: 1.75rem;
  }
}
</style>
