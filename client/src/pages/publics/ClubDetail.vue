<template>
  <div class="min-h-screen bg-gray-50 py-12">
    <div class="max-w-5xl mx-auto px-6">
      <!-- Header with Main Image -->
      <div class="relative bg-white rounded-lg shadow-lg overflow-hidden mb-10">
        <img :src="club.main_image_url || 'https://placehold.co/1920x1080'" :alt="club.name"
          class="w-full h-48 object-cover">
        <div class="absolute inset-0 bg-black/50 flex items-center justify-center">
          <div class="text-center px-4">
            <h1 class="text-4xl font-extrabold text-white">{{ club.name }}</h1>
            <div class="flex items-center gap-2 text-gray-300 mt-2">
              <span class="text-xl">📍</span>
              <span class="text-lg">{{ club.address }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-12 gap-10">
        <!-- Left Column - Info (4) -->
        <div class="col-span-4 space-y-10">
          <!-- Info Bar -->
          <div class="bg-white rounded-lg shadow-lg p-8 space-y-6">
            <div>
              <span class="text-sm text-gray-400">District</span>
              <p class="text-lg font-semibold text-gray-800">{{ club.district_name }}</p>
            </div>
            <div>
              <span class="text-sm text-gray-400">Street</span>
              <p class="text-lg font-semibold text-gray-800">{{ club.street_name }}</p>
            </div>
          </div>

          <!-- About -->
          <div class="bg-white rounded-lg shadow-lg p-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-4">About the Club</h2>
            <p class="text-gray-600 leading-relaxed">{{ club.description }}</p>
          </div>

          <!-- Actions -->
          <div class="bg-white rounded-lg shadow-lg p-8 space-y-4">
            <h3 class="text-2xl font-bold text-gray-800 mb-4">Ready to Play?</h3>
            <button
              class="w-full py-3 bg-blue-600 text-white font-medium rounded-lg hover:bg-blue-700 transition-colors">
              Book Now
            </button>
            <button
              class="w-full py-3 bg-gray-200 text-gray-800 font-medium rounded-lg hover:bg-gray-300 transition-colors">
              Contact Club
            </button>
          </div>
        </div>

        <!-- Right Column - Gallery (8) -->
        <div class="col-span-8">
          <div class="grid grid-cols-2 gap-6">
            <div v-for="(image, index) in club.sub_image_urls" :key="index"
              class="aspect-[4/3] rounded-lg overflow-hidden bg-gray-200 shadow-lg">
              <img :src="image" :alt="`Gallery image ${index + 1}`"
                class="w-full h-full object-cover hover:scale-105 transition-transform duration-500">
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import apiClient from '../../axios'

const route = useRoute()
const club = ref({
  name: '',
  address: '',
  description: '',
  district_name: '',
  street_name: '',
  main_image_url: '',
  sub_image_urls: []
})

const fetchClubDetails = async () => {
  try {
    const response = await apiClient.get(`/api/public/clubs/${route.params.id}`)
    club.value = response.data
  } catch (error) {
    console.error('Error fetching club details:', error)
  }
}

onMounted(() => {
  fetchClubDetails()
})
</script>
