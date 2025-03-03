<template>
  <div class="p-5">
    <div class="flex justify-between items-center mb-5">
      <h1 class="text-xl font-medium text-gray-900">Clubs List</h1>
      <button
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
        @click="navigateToCreate">
        Create New Club
      </button>
    </div>

    <div class="mb-6">
      <div class="mb-4">
        <input v-model="searchQuery" type="text" placeholder="Search by name..."
          class="w-full px-4 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500" />
      </div>
      <div class="flex gap-3 items-center">
        <select v-model="selectedDistrict"
          class="px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 min-w-[160px]">
          <option value="">All Districts</option>
          <option v-for="district in districts" :key="district.id" :value="district.id">
            {{ district.name }}
          </option>
        </select>

        <select v-model="selectedStreet" v-if="selectedDistrict"
          class="px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 min-w-[160px]">
          <option value="">All Streets</option>
          <option v-for="street in streets" :key="street.id" :value="street.id">
            {{ street.name }}
          </option>
        </select>
        <button
          class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
          @click="fetchClubs">
          Search
        </button>
      </div>
    </div>

    <table class="w-full border border-gray-200 rounded-lg overflow-hidden">
      <thead class="bg-gray-50">
        <tr>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Address</th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">District</th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Street</th>
          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
        </tr>
      </thead>
      <tbody class="bg-white divide-y divide-gray-200">
        <tr v-for="club in clubs" :key="club.id">
          <td class="px-6 py-4 text-sm text-gray-900">
            <span class="flex items-center gap-2">
              {{ club.name }}
              <span v-if="!club.active" class="px-2 py-0.5 text-xs font-medium bg-gray-100 text-gray-600 rounded">
                inactive
              </span>
            </span>
          </td>
          <td class="px-6 py-4 text-sm text-gray-900">{{ club.address }}</td>
          <td class="px-6 py-4 text-sm text-gray-900">{{ club.district_name }}</td>
          <td class="px-6 py-4 text-sm text-gray-900">{{ club.street_name }}</td>
          <td class="px-6 py-4 text-sm text-gray-900 space-x-2">
            <button
              class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
              @click="activateClub(club.id)" v-if="!club.active">
              Active
            </button>
            <button
              class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
              @click="navigateToEdit(club.id)">
              Edit
            </button>
            <button
              class="bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500"
              @click="navigateToManagers(club.id)">
              Managers
            </button>
            <button
              class="bg-red-600 text-white px-3 py-1 rounded hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500"
              @click="confirmDelete(club)">
              Delete
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <PaginationControls :current-page="currentPage" :total-pages="totalPages" @page-change="handlePageChange" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from '../../../axios.js'
import usePaging from '../../../composables/usePaging'
import PaginationControls from '../../../components/PaginationControls.vue'

const router = useRouter()
const clubs = ref([])
const districts = ref([])
const streets = ref([])
const searchQuery = ref('')
const selectedDistrict = ref('')
const selectedStreet = ref('')

const fetchClubs = async () => {
  try {
    const params = {
      name: searchQuery.value,
      district_id: selectedDistrict.value,
      street_id: selectedStreet.value,
      page: currentPage.value,
    }
    const response = await axios.get('/api/admin/clubs', { params })
    clubs.value = response.data.clubs
    updatePagination(response.data.pagination)
  } catch (error) {
    console.error('Error fetching clubs:', error)
  }
}

const {
  currentPage,
  totalPages,
  handlePageChange,
  updatePagination
} = usePaging(fetchClubs, 1, 10)

const fetchDistricts = async () => {
  try {
    const response = await axios.get('/api/admin/districts')
    districts.value = response.data
  } catch (error) {
    console.error('Error fetching districts:', error)
  }
}

const fetchStreets = async () => {
  try {
    const response = await axios.get('/api/admin/streets')
    streets.value = response.data
  } catch (error) {
    console.error('Error fetching streets:', error)
  }
}

const navigateToCreate = () => {
  router.push('/admin/clubs/new')
}

const navigateToEdit = (clubId) => {
  router.push(`/admin/clubs/${clubId}/edit`)
}

const navigateToManagers = (clubId) => {
  router.push(`/admin/clubs/${clubId}/managers`)
}

const confirmDelete = (club) => {
  if (confirm(`Are you sure you want to delete ${club.name}?`)) {
    deleteClub(club.id)
  }
}

const deleteClub = async (clubId) => {
  try {
    await axios.delete(`/api/admin/clubs/${clubId}`)
    await fetchClubs()
  } catch (error) {
    console.error('Error deleting club:', error)
    alert('Failed to delete club')
  }
}

const activateClub = async (clubId) => {
  if (confirm(`Are you sure you want to activate this club?`)) {
    try {
      await axios.patch(`/api/admin/clubs/${clubId}/activate`)
      await fetchClubs()
    } catch (error) {
      console.error('Error activating club:', error)
      alert('Failed to activate club')
    }
  }
}

onMounted(() => {
  fetchClubs()
  fetchDistricts()
  fetchStreets()
})
</script>
