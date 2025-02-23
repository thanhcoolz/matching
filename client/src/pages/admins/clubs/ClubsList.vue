<template>
  <div class="clubs-list">
    <div class="header">
      <h1>Clubs List</h1>
      <button class="create-btn" @click="navigateToCreate">Create New Club</button>
    </div>

    <div class="search-container">
      <div class="search-box">
        <input v-model="searchQuery" type="text" placeholder="Search by name..." class="search-input" />
      </div>
      <div class="filter-group">
        <select v-model="selectedDistrict" class="filter-select">
          <option value="">All Districts</option>
          <option v-for="district in districts" :key="district.id" :value="district.id">
            {{ district.name }}
          </option>
        </select>
        <select v-model="selectedStreet" class="filter-select">
          <option value="">All Streets</option>
          <option v-for="street in streets" :key="street.id" :value="street.id">
            {{ street.name }}
          </option>
        </select>
        <button class="search-btn" @click="fetchClubs">Search</button>
      </div>
    </div>

    <table class="clubs-table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Address</th>
          <th>District</th>
          <th>Street</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="club in clubs" :key="club.id">
          <td>{{ club.name }}</td>
          <td>{{ club.address }}</td>
          <td>{{ club.district_name }}</td>
          <td>{{ club.street_name }}</td>
          <td>
            <button class="action-btn" @click="navigateToEdit(club.id)">Edit</button>
            <button class="action-btn managers" @click="navigateToManagers(club.id)">Managers</button>
            <button class="action-btn delete" @click="confirmDelete(club)">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from '../../../axios.js'

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
      street_id: selectedStreet.value
    }
    const response = await axios.get('/api/admin/clubs', { params })
    clubs.value = response.data
  } catch (error) {
    console.error('Error fetching clubs:', error)
  }
}

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
    await fetchClubs() // Refresh the list after deletion
  } catch (error) {
    console.error('Error deleting club:', error)
    alert('Failed to delete club')
  }
}

onMounted(() => {
  fetchClubs()
  fetchDistricts()
  fetchStreets()
})
</script>

<style scoped>
@import '../../../assets/styles/admins/clubs-list.css';
</style>
