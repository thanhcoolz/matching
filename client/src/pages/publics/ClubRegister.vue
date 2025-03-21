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
            <!-- Main Image Upload -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Main Image</label>
              <div class="mt-1 flex items-center space-x-4">
                <div class="w-32 h-32 rounded-lg overflow-hidden bg-gray-100">
                  <img v-if="mainImagePreview" :src="mainImagePreview" alt="Main Preview"
                    class="w-full h-full object-cover">
                  <div v-else class="w-full h-full flex items-center justify-center text-gray-400">
                    <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                </div>
                <input type="file" ref="mainImageInput" @change="handleMainImageChange" accept="image/*" class="hidden">
                <button type="button" @click="$refs.mainImageInput.click()"
                  class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors">
                  Choose Main Image
                </button>
              </div>
            </div>

            <!-- Multiple Sub Images Upload -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Sub Images (Up to 5)</label>
              <div class="mt-1 space-y-4">
                <!-- Image Previews -->
                <div class="flex flex-wrap gap-4">
                  <div v-for="(preview, index) in subImagePreviews" :key="index"
                    class="relative w-32 h-32 rounded-lg overflow-hidden bg-gray-100">
                    <img :src="preview" alt="Sub Preview" class="w-full h-full object-cover">
                    <button @click.prevent="removeSubImage(index)"
                      class="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 hover:bg-red-600">
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                          d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  </div>

                  <!-- Add Image Button -->
                  <div v-if="subImagePreviews.length < 5"
                    class="w-32 h-32 rounded-lg border-2 border-dashed border-gray-300 flex items-center justify-center cursor-pointer hover:border-gray-400"
                    @click="$refs.subImagesInput.click()">
                    <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                  </div>
                </div>
                <input type="file" ref="subImagesInput" @change="handleSubImagesChange" accept="image/*" multiple
                  class="hidden">
              </div>
            </div>

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

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Number of Tables</label>
              <input v-model="formData.table_numbers" type="number" min="1"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
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
const mainImagePreview = ref(null)
const subImagePreviews = ref([])
const mainImageInput = ref(null)
const subImagesInput = ref(null)

const formData = ref({
  name: '',
  email: '',
  description: '',
  district_id: '',
  street_id: '',
  address: '',
  table_numbers: 1,
  main_image: null,
  sub_images: []
})

const handleMainImageChange = (event) => {
  const file = event.target.files[0]
  if (file) {
    formData.value.main_image = file
    mainImagePreview.value = URL.createObjectURL(file)
  }
}

const handleSubImagesChange = (event) => {
  const files = Array.from(event.target.files)
  const remainingSlots = 5 - subImagePreviews.value.length
  const validFiles = files.slice(0, remainingSlots)

  validFiles.forEach(file => {
    formData.value.sub_images.push(file)
    subImagePreviews.value.push(URL.createObjectURL(file))
  })
}

const removeSubImage = (index) => {
  formData.value.sub_images.splice(index, 1)
  subImagePreviews.value.splice(index, 1)
}

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
    errors.value = []
    const submitData = new FormData()

    Object.keys(formData.value).forEach(key => {
      if (key === 'sub_images') {
        formData.value.sub_images.forEach((file, index) => {
          submitData.append(`club[sub_images][]`, file)
        })
      } else if (formData.value[key] !== '' && formData.value[key] !== null) {
        submitData.append(`club[${key}]`, formData.value[key])
      }
    })

    await apiClient.post('/api/public/clubs/register', submitData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
    showSuccessPopup.value = true
  } catch (error) {
    console.error('Error registering club:', error)
    if (error.response?.data?.errors) {
      errors.value = error.response.data.errors
    } else {
      errors.value = ['An unexpected error occurred. Please try again.']
    }
  }
}

const closePopup = () => {
  showSuccessPopup.value = false
  router.push('/clubs')
}

watch(() => formData.value.district_id, () => {
  if (formData.value.district_id) {
    formData.value.street_id = ''
    fetchStreets(formData.value.district_id)
  }
})

onMounted(() => {
  fetchDistricts()
})
</script>
