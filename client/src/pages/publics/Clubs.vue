<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Hero Section -->
    <section class="bg-gradient-to-r from-indigo-900 to-red-700 py-16 px-8 text-center text-white">
      <div class="max-w-4xl mx-auto">
        <h1 class="text-4xl md:text-5xl font-bold mb-4 drop-shadow-lg">Our Partner Clubs</h1>
        <p class="text-xl opacity-90">Discover premium billiards venues in your area</p>
        <router-link to="/clubs/register"
          class="inline-block mt-6 px-8 py-3 bg-white text-indigo-900 font-semibold rounded-lg hover:bg-opacity-90 transition-colors">
          Become our partner
        </router-link>
      </div>
    </section>

    <!-- Search and Filter Section -->
    <section class="bg-white py-6 px-4 shadow-md">
      <div class="max-w-3xl mx-auto">
        <div class="relative">
          <input type="text" v-model="filters.name" placeholder="Search clubs by name..."
            class="w-full pl-12 pr-4 py-4 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-900 transition-colors"
            @input="debouncedFetchClubs">
          <span class="absolute left-4 top-1/2 -translate-y-1/2">🔍</span>
        </div>
        <div class="mt-4 flex gap-4">
          <select v-model="filters.district_id" @change="handleDistrictChange"
            class="w-full py-4 px-4 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-900 transition-colors">
            <option value="">All Districts</option>
            <option v-for="district in districts" :key="district.id" :value="district.id">
              {{ district.name }}
            </option>
          </select>
          <select v-if="filters.district_id" v-model="filters.street_id" @change="fetchClubs"
            class="w-full py-4 px-4 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-900 transition-colors">
            <option value="">All Streets</option>
            <option v-for="street in streets" :key="street.id" :value="street.id">
              {{ street.name }}
            </option>
          </select>
        </div>
      </div>
    </section>

    <!-- Clubs Grid -->
    <section class="max-w-7xl mx-auto px-4 py-8">
      <div v-if="loading" class="text-center py-8">
        <div class="animate-spin h-8 w-8 border-4 border-indigo-900 border-t-transparent rounded-full mx-auto"></div>
      </div>
      <div v-else-if="clubs.length === 0" class="text-center py-8 text-gray-500">
        No clubs found
      </div>
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 p-4">
        <div v-for="club in clubs" :key="club.id"
          class="bg-white rounded-2xl overflow-hidden shadow-md hover:shadow-xl transition-all duration-300 hover:-translate-y-2 flex flex-col h-[500px]">
          <div class="relative h-[250px] overflow-hidden group">
            <img :src="club.main_image_url || 'https://placehold.co/600x400'" :alt="club.name"
              class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105">
          </div>
          <div class="p-6 flex flex-col flex-1">
            <h3 class="text-xl font-semibold text-indigo-900 mb-3 line-clamp-1">{{ club.name }}</h3>
            <p class="flex items-start gap-2 text-gray-600 mb-4 text-sm">
              <span>📍</span>
              <span class="line-clamp-2">{{ club.address }} </span>
            </p>
            <p class="text-gray-600 mb-6 line-clamp-3 flex-1">{{ club.description }}</p>
            <div class="flex gap-4 mt-auto">
              <router-link :to="`/clubs/${club.id}`"
                class="flex-1 py-3 px-4 rounded-lg bg-gray-200 text-indigo-900 font-medium text-center hover:bg-gray-300 transition-colors">
                View Details
              </router-link>
              <button
                class="flex-1 py-3 px-4 rounded-lg bg-indigo-900 text-white font-medium hover:bg-indigo-800 transition-colors">
                Book Now
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Pagination -->
      <div v-if="pagination.total_pages > 1" class="flex justify-center gap-2 mt-8">
        <button v-for="page in pagination.total_pages" :key="page" @click="changePage(page)" :class="[
            'px-4 py-2 rounded-lg transition-colors',
            page === pagination.current_page
              ? 'bg-indigo-900 text-white'
              : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
          ]">
          {{ page }}
        </button>
      </div>
    </section>
  </div>
</template>


<script setup>
import { ref, onMounted } from 'vue'
import apiClient from '../../axios';
import { debounce } from 'lodash'

const clubs = ref([])
const loading = ref(false)
const filters = ref({
  name: '',
  district_id: '',
  street_id: '',
  page: 1,
  per_page: 10
})
const pagination = ref({
  current_page: 1,
  total_pages: 0,
  total_count: 0
})

const districts = ref([])
const streets = ref([])

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
    const response = await apiClient.get('/api/public/streets', {
      params: { district_id: districtId }
    })
    streets.value = response.data
  } catch (error) {
    console.error('Error fetching streets:', error)
  }
}

const fetchClubs = async () => {
  try {
    loading.value = true
    const params = {
      ...filters.value,
      page: pagination.value.current_page
    }

    const response = await apiClient.get('/api/public/clubs', { params })
    clubs.value = response.data.clubs
    pagination.value = response.data.pagination
  } catch (error) {
    console.error('Error fetching clubs:', error)
  } finally {
    loading.value = false
  }
}

const debouncedFetchClubs = debounce(() => {
  pagination.value.current_page = 1
  fetchClubs()
}, 300)

const changePage = (page) => {
  pagination.value.current_page = page
  fetchClubs()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const handleDistrictChange = async () => {
  filters.value.street_id = ''
  streets.value = []

  if (filters.value.district_id) {
    await fetchStreets(filters.value.district_id)
  }

  fetchClubs()
}

onMounted(async () => {
  await fetchDistricts()
  fetchClubs()
})
</script>
