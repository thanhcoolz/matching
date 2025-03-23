<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 py-12">
    <div class="max-w-6xl mx-auto px-6">
      <!-- Header with Main Image -->
      <div class="relative bg-white rounded-xl shadow-2xl overflow-hidden mb-12">
        <img :src="club.main_image_url || 'https://placehold.co/1920x1080'" :alt="club.name"
          class="w-full h-80 object-cover transition-transform duration-700 hover:scale-105">
        <div
          class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/50 to-transparent flex items-end justify-start p-12">
          <div class="text-left">
            <h1 class="text-5xl font-extrabold text-white mb-4 drop-shadow-lg">{{ club.name }}</h1>
            <div class="flex items-center gap-3 text-gray-200">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
              <span class="text-xl font-medium">{{ club.address }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="grid grid-cols-12 gap-12">
        <!-- Left Column - Info (4) -->
        <div class="col-span-12 lg:col-span-4 space-y-8">
          <!-- Info Bar -->
          <div
            class="bg-white rounded-xl shadow-lg p-8 space-y-6 transform hover:scale-[1.02] transition-transform duration-300">
            <div class="flex items-center space-x-4">
              <div class="p-3 bg-blue-50 rounded-lg">
                <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                </svg>
              </div>
              <div>
                <span class="text-sm font-medium text-gray-500">District</span>
                <p class="text-lg font-bold text-gray-900">{{ club.district_name }}</p>
              </div>
            </div>
            <div class="flex items-center space-x-4">
              <div class="p-3 bg-purple-50 rounded-lg">
                <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
                </svg>
              </div>
              <div>
                <span class="text-sm font-medium text-gray-500">Street</span>
                <p class="text-lg font-bold text-gray-900">{{ club.street_name }}</p>
              </div>
            </div>
          </div>

          <!-- About -->
          <div class="bg-white rounded-xl shadow-lg p-8 transform hover:scale-[1.02] transition-transform duration-300">
            <div class="flex items-center gap-3 mb-6">
              <div class="p-3 bg-green-50 rounded-lg">
                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h2 class="text-2xl font-bold text-gray-900">About the Club</h2>
            </div>
            <p class="text-gray-600 leading-relaxed text-lg">{{ club.description }}</p>
          </div>

          <!-- Tables -->
          <div class="bg-white rounded-xl shadow-lg p-8 transform hover:scale-[1.02] transition-transform duration-300">
            <div class="flex items-center gap-3 mb-6">
              <div class="p-3 bg-amber-50 rounded-lg">
                <svg class="w-6 h-6 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M4 6h16M4 10h16M4 14h16M4 18h16" />
                </svg>
              </div>
              <h2 class="text-2xl font-bold text-gray-900">Available Tables</h2>
            </div>
            <div class="flex items-center justify-center">
              <div class="text-center">
                <span class="text-5xl font-bold text-blue-600">{{ club.table_numbers }}</span>
                <p class="text-gray-500 mt-2">Total Tables</p>
              </div>
            </div>
          </div>

          <!-- Actions -->
          <div
            class="bg-white rounded-xl shadow-lg p-8 space-y-4 transform hover:scale-[1.02] transition-transform duration-300">
            <h3 class="text-2xl font-bold text-gray-900 mb-6">Ready to Play?</h3>
            <button @click="handleBookNowClick"
              class="w-full py-4 bg-gradient-to-r from-blue-600 to-blue-700 text-white text-lg font-semibold rounded-xl hover:from-blue-700 hover:to-blue-800 transition-all duration-300 shadow-lg hover:shadow-xl">
              Book Now
            </button>
          </div>
        </div>

        <!-- Right Column - Gallery (8) -->
        <div class="col-span-12 lg:col-span-8">
          <div class="grid grid-cols-2 gap-6">
            <div v-for="(image, index) in club.sub_image_urls" :key="index"
              class="aspect-[4/3] rounded-xl overflow-hidden bg-gray-200 shadow-lg group">
              <img :src="image" :alt="`Gallery image ${index + 1}`"
                class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110">
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Reservation Modal -->
    <div v-if="showReservationModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-2xl p-8 max-w-md w-full mx-4 shadow-2xl" @click.stop>
        <div class="flex justify-between items-center mb-6">
          <h3 class="text-2xl font-bold text-gray-900">Make a Reservation</h3>
          <button @click="showReservationModal = false" class="text-gray-500 hover:text-gray-700">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <form @submit.prevent="createReservation" class="space-y-6">
          <!-- Date Picker -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Date</label>
            <input type="date" v-model="reservation.date"
              class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              :min="today">
          </div>

          <!-- Time Picker -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Time</label>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-xs text-gray-500 mb-1">Hour</label>
                <select v-model="reservation.hour"
                  class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                  <option v-for="hour in 24" :key="hour" :value="String(hour - 1).padStart(2, '0')">
                    {{ String(hour - 1).padStart(2, '0') }}
                  </option>
                </select>
              </div>
              <div>
                <label class="block text-xs text-gray-500 mb-1">Minute</label>
                <select v-model="reservation.minute"
                  class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                  <option value="00">00</option>
                  <option value="30">30</option>
                </select>
              </div>
            </div>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Duration (hours)</label>
            <select v-model="reservation.duration"
              class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
              <option v-for="duration in 8" :key="duration" :value="duration">
                {{ duration }} {{ duration === 1 ? 'hour' : 'hours' }}
              </option>
            </select>
          </div>

          <!-- Reservation Type -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Reservation Type</label>
            <div class="grid grid-cols-2 gap-4">
              <button type="button" @click="reservation.type = 1" :class="[
                  'py-3 px-4 rounded-xl text-center font-medium transition-all duration-200',
                  reservation.type === 1
                    ? 'bg-blue-600 text-white shadow-lg'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                ]">
                Private
              </button>
              <button type="button" @click="reservation.type = 2" :class="[
                  'py-3 px-4 rounded-xl text-center font-medium transition-all duration-200',
                  reservation.type === 2
                    ? 'bg-blue-600 text-white shadow-lg'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                ]">
                Public
              </button>
            </div>
          </div>

          <button type="submit"
            class="w-full py-4 bg-gradient-to-r from-blue-600 to-blue-700 text-white text-lg font-semibold rounded-xl hover:from-blue-700 hover:to-blue-800 transition-all duration-300 shadow-lg hover:shadow-xl">
            Confirm Reservation
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import apiClient from '../../axios'
import { usePlayerAuthStore } from '../../store/playerAuth'

const playerAuthStore = usePlayerAuthStore()

const route = useRoute()
const router = useRouter()
const club = ref({
  name: '',
  address: '',
  description: '',
  district_name: '',
  street_name: '',
  main_image_url: '',
  sub_image_urls: [],
  table_numbers: 0
})

const showReservationModal = ref(false)
const reservation = ref({
  date: '',
  hour: '00',
  minute: '00',
  duration: 2,
  type: 1
})

const today = computed(() => {
  const date = new Date()
  return date.toISOString().split('T')[0]
})

const fetchClubDetails = async () => {
  try {
    const response = await apiClient.get(`/api/public/clubs/${route.params.id}`)
    club.value = response.data
  } catch (error) {
    console.error('Error fetching club details:', error)
  }
}

const handleBookNowClick = async () => {
  const isAuthenticated = await playerAuthStore.checkAuth()
  if (!isAuthenticated) {
    alert('You must be logged in to book a table.')
    window.location.href = '/login'
    return
  }
  showReservationModal.value = true
}

const createReservation = async () => {
  try {
    const startTime = new Date(`${reservation.value.date}T${reservation.value.hour}:${reservation.value.minute}:00`)

    const response = await apiClient.post(`/api/player/reservations`, {
      reservation: {
        start_time: startTime.toISOString(),
        duration_hours: reservation.value.duration,
        reservation_type: reservation.value.type,
        club_id: route.params.id
      }
    })

    // const response = await apiClient.post(`/api/public/clubs/${route.params.id}/reservations`, {
    //   start_time: startTime.toISOString(),
    //   reservation_type: reservation.value.type
    // })

    // showReservationModal.value = false
    // router.push('/reservations')
  } catch (error) {
    console.error('Error creating reservation:', error)
  }
}

onMounted(() => {
  fetchClubDetails()
})
</script>
