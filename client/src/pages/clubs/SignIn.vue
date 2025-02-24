<template>

  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          Sign in to Club Manager
        </h2>
      </div>
      <form class="mt-8 space-y-6" @submit.prevent="handleSubmit">
        <div class="rounded-md shadow-sm -space-y-px">
          <div class="relative">
            <label for="club-search" class="sr-only">Club Name</label>
            <input id="club-search" v-model="clubSearch" type="text" required
              class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
              placeholder="Search club name" @input="debouncedSearch" />
            <div v-if="showDropdown && clubs.length > 0"
              class="absolute z-10 w-full bg-white border border-gray-300 rounded-b-md shadow-lg">
              <ul class="max-h-60 overflow-auto">
                <li v-for="club in clubs" :key="club.id" class="px-3 py-2 hover:bg-gray-100 cursor-pointer"
                  @click="selectClub(club)">
                  {{ club.name }}
                </li>
              </ul>
            </div>
          </div>
          <div>
            <label for="username" class="sr-only">Username</label>
            <input id="username" v-model="username" type="text" required
              class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
              placeholder="Username" />
          </div>
          <div>
            <label for="password" class="sr-only">Password</label>
            <input id="password" v-model="password" type="password" required
              class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
              placeholder="Password" />
          </div>
        </div>

        <div v-if="errorMessage" class="mb-4 text-center text-red-600">
          {{ errorMessage }}
        </div>

        <div>
          <button @click="handleSubmit"
            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            :disabled="loading">
            {{ loading ? 'Signing in...' : 'Sign in' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>


<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useClubAuth } from '../../store/clubAuth'
import apiClient from '../../axios.js';
import debounce from 'lodash/debounce'

const router = useRouter()
const { setAuth } = useClubAuth()

const clubSearch = ref('')
const clubs = ref([])
const showDropdown = ref(false)
const selectedClubId = ref(null)
const username = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')

const searchClubs = async (query) => {
  if (!query) {
    clubs.value = []
    showDropdown.value = false
    return
  }

  try {
    const response = await apiClient.get('/api/clubs', {
      params: { name: query }
    })
    clubs.value = response.data
    showDropdown.value = true
  } catch (error) {
    console.error('Error searching clubs:', error)
    clubs.value = []
  }
}

const debouncedSearch = debounce(() => {
  searchClubs(clubSearch.value)
}, 1000)

const selectClub = (club) => {
  clubSearch.value = club.name
  selectedClubId.value = club.id
  showDropdown.value = false
}

const handleSubmit = async () => {
  if (!selectedClubId.value) {
    alert('Please select a club')
    return
  }

  loading.value = true
  errorMessage.value = ''

  try {
    const response = await apiClient.post('/api/club/club_sessions', {
      club_id: selectedClubId.value,
      username: username.value,
      password: password.value
    })

    if (response.data) {
      setAuth(response.data.current_club, response.data.club_manager)
      router.push('/club/dashboard')
    } else {
      errorMessage.value = 'Authentication failed. Please try again.'
    }
  } catch (error) {
    errorMessage.value = error.response?.data?.error || 'Sign in failed'
  } finally {
    loading.value = false
  }
}

// Close dropdown when clicking outside
onMounted(() => {
  document.addEventListener('click', (e) => {
    if (!e.target.closest('#club-search')) {
      showDropdown.value = false
    }
  })
})
</script>
