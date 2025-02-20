<template>
  <div class="clubs-list">
    <div class="header">
      <h1>Clubs List</h1>
      <button class="create-btn" @click="navigateToCreate">Create New Club</button>
    </div>

    <div class="filters">
      <input v-model="searchQuery" type="text" placeholder="Search by name..." class="search-input" />
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
          <td>{{ club.district?.name }}</td>
          <td>{{ club.street?.name }}</td>
          <td>
            <button class="action-btn">Edit</button>
            <button class="action-btn delete">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import apiClient from '../../axios.js'

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
    const response = await apiClient.get('/api/admin/clubs', { params })
    clubs.value = response.data
  } catch (error) {
    console.error('Error fetching clubs:', error)
  }
}

const fetchDistricts = async () => {
  try {
    const response = await apiClient.get('/api/admin/districts')
    districts.value = response.data
  } catch (error) {
    console.error('Error fetching districts:', error)
  }
}

const fetchStreets = async () => {
  try {
    const response = await apiClient.get('/api/admin/streets')
    streets.value = response.data
  } catch (error) {
    console.error('Error fetching streets:', error)
  }
}

const navigateToCreate = () => {
  router.push('/admin/clubs/new')
}

onMounted(() => {
  fetchClubs()
  fetchDistricts()
  fetchStreets()
})
</script>

<style scoped>
.clubs-list {
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.create-btn {
  background-color: #4CAF50;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.filters {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.search-input {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  flex: 1;
}

.filter-select {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.clubs-table {
  width: 100%;
  border-collapse: collapse;
}

.clubs-table th,
.clubs-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

.clubs-table th {
  background-color: #f5f5f5;
}

.action-btn {
  padding: 6px 12px;
  margin-right: 5px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.action-btn.delete {
  background-color: #f44336;
  color: white;
}
</style>
