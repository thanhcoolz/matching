<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
    <!-- Hero Section -->
    <section
      class="bg-gradient-to-r from-indigo-900 via-purple-800 to-red-700 py-20 px-8 text-center text-white relative overflow-hidden">
      <div class="absolute inset-0 bg-[url('data:image/svg+xml,...')] opacity-10"></div>
      <div class="max-w-4xl mx-auto relative z-10">
        <h1 class="text-5xl md:text-6xl font-bold mb-6 drop-shadow-lg">Our Partner Clubs</h1>
        <p class="text-xl md:text-2xl opacity-90 mb-8">Discover premium billiards venues in your area</p>
        <router-link to="/clubs/register"
          class="inline-block px-10 py-4 bg-white text-indigo-900 font-semibold rounded-xl hover:bg-opacity-95 transition-all duration-300 transform hover:scale-105 shadow-lg">
          Become our partner
        </router-link>
      </div>
    </section>

    <!-- Search and Filter Section -->
    <section class="bg-white py-8 px-4 shadow-lg relative -mt-8 rounded-t-3xl">
      <div class="max-w-3xl mx-auto">
        <div class="relative mb-6">
          <input type="text" v-model="filters.name" placeholder="Search clubs by name..."
            class="w-full pl-14 pr-4 py-4 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-all"
            @input="debouncedFetchClubs">
          <svg class="w-6 h-6 absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" fill="none" stroke="currentColor"
            viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </div>
        <div class="grid md:grid-cols-2 gap-4">
          <select v-model="filters.district_id" @change="handleDistrictChange"
            class="w-full py-4 px-4 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-all">
            <option value="">All Districts</option>
            <option v-for="district in districts" :key="district.id" :value="district.id">
              {{ district.name }}
            </option>
          </select>
          <select v-if="filters.district_id" v-model="filters.street_id" @change="fetchClubs"
            class="w-full py-4 px-4 border-2 border-gray-200 rounded-xl focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200 transition-all">
            <option value="">All Streets</option>
            <option v-for="street in streets" :key="street.id" :value="street.id">
              {{ street.name }}
            </option>
          </select>
        </div>
      </div>
    </section>

    <!-- Clubs Grid -->
    <section class="max-w-7xl mx-auto px-4 py-12">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <div class="inline-flex items-center px-4 py-2 bg-indigo-100 text-indigo-700 rounded-xl">
          <svg class="animate-spin h-5 w-5 mr-3" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
            </path>
          </svg>
          Loading clubs...
        </div>
      </div>

      <!-- Empty State -->
      <div v-else-if="clubs.length === 0" class="text-center py-12">
        <div class="max-w-md mx-auto">
          <svg class="w-16 h-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
          </svg>
          <h3 class="text-lg font-medium text-gray-900 mb-2">No clubs found</h3>
          <p class="text-gray-500">Try adjusting your search or filter criteria</p>
        </div>
      </div>

      <!-- Clubs Grid -->
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div v-for="club in clubs" :key="club.id"
          class="bg-white rounded-2xl overflow-hidden shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 group">
          <div class="relative h-[250px] overflow-hidden">
            <img :src="club.main_image_url || 'https://placehold.co/600x400'" :alt="club.name"
              class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110">
            <div
              class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300">
            </div>
          </div>
          <div class="p-6">
            <h3 class="text-xl font-bold text-gray-900 mb-3 line-clamp-1 group-hover:text-indigo-600 transition-colors">
              {{ club.name }}
            </h3>
            <p class="flex items-start gap-2 text-gray-600 mb-4">
              <svg class="w-5 h-5 text-indigo-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
              <span class="line-clamp-2 text-sm">{{ club.address }}</span>
            </p>
            <p class="text-gray-600 mb-6 line-clamp-3 text-sm">{{ club.description }}</p>
            <div class="flex gap-4">
              <router-link :to="`/clubs/${club.id}`"
                class="flex-1 py-3 px-4 rounded-xl bg-gray-100 text-gray-900 font-medium text-center hover:bg-gray-200 transition-colors">
                View Details
              </router-link>
              <button
                class="flex-1 py-3 px-4 rounded-xl bg-indigo-600 text-white font-medium hover:bg-indigo-700 transition-colors shadow-md hover:shadow-lg">
                Book Now
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Pagination -->
      <div v-if="pagination.total_pages > 1" class="flex justify-center gap-2 mt-12">
        <button v-for="page in pagination.total_pages" :key="page" @click="changePage(page)" :class="[
            'px-4 py-2 rounded-xl transition-all duration-300 min-w-[40px]',
            page === pagination.current_page
              ? 'bg-indigo-600 text-white shadow-lg scale-110'
              : 'bg-white text-gray-700 hover:bg-gray-100 shadow'
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
