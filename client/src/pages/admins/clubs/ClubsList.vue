<template>
  <div class="p-8 bg-gray-50 min-h-screen">
    <!-- Header Section -->
    <div class="flex justify-between items-center mb-8">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Clubs Management</h1>
        <p class="text-gray-600 mt-1">Manage and monitor all registered clubs</p>
      </div>
      <button
        class="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-3 rounded-lg hover:from-blue-700 hover:to-blue-800 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 shadow-lg transition-all duration-300 flex items-center gap-2"
        @click="navigateToCreate">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Create New Club
      </button>
    </div>

    <!-- Search and Filter Section -->
    <div class="bg-white rounded-xl shadow-md p-6 mb-8">
      <div class="mb-4">
        <div class="relative">
          <input v-model="searchQuery" type="text" placeholder="Search clubs by name..."
            class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
          <svg class="w-5 h-5 text-gray-400 absolute left-3 top-1/2 transform -translate-y-1/2" fill="none"
            stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </div>
      </div>
      <div class="flex flex-wrap gap-4 items-center">
        <select v-model="selectedDistrict"
          class="px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 min-w-[200px] bg-white">
          <option value="">All Districts</option>
          <option v-for="district in districts" :key="district.id" :value="district.id">
            {{ district.name }}
          </option>
        </select>

        <select v-model="selectedStreet" v-if="selectedDistrict"
          class="px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 min-w-[200px] bg-white">
          <option value="">All Streets</option>
          <option v-for="street in streets" :key="street.id" :value="street.id">
            {{ street.name }}
          </option>
        </select>
        <button
          class="bg-blue-100 text-blue-700 px-6 py-3 rounded-lg hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors duration-200 font-medium"
          @click="fetchClubs">
          Apply Filters
        </button>
      </div>
    </div>

    <!-- Table Section -->
    <div class="bg-white rounded-xl shadow-md overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Club Info
              </th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Location</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">District</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Street</th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr v-for="club in clubs" :key="club.id" class="hover:bg-gray-50 transition-colors duration-200">
              <td class="px-6 py-4">
                <div class="flex items-center gap-3">
                  <div class="flex-shrink-0 w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center">
                    <span class="text-gray-600 font-medium">{{ club.name[0] }}</span>
                  </div>
                  <div>
                    <div class="font-medium text-gray-900">{{ club.name }}</div>
                    <div v-if="!club.active"
                      class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                      Inactive
                    </div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4 text-sm text-gray-600">{{ club.address }}</td>
              <td class="px-6 py-4 text-sm text-gray-600">{{ club.district_name }}</td>
              <td class="px-6 py-4 text-sm text-gray-600">{{ club.street_name }}</td>
              <td class="px-6 py-4">
                <div class="flex items-center gap-2">
                  <button v-if="!club.active"
                    class="inline-flex items-center px-3 py-1.5 bg-green-100 text-green-700 rounded-lg hover:bg-green-200 focus:outline-none focus:ring-2 focus:ring-green-500 transition-colors duration-200"
                    @click="activateClub(club.id)">
                    <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    Activate
                  </button>
                  <button
                    class="inline-flex items-center px-3 py-1.5 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors duration-200"
                    @click="navigateToEdit(club.id)">
                    <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                    Edit
                  </button>
                  <button
                    class="inline-flex items-center px-3 py-1.5 bg-purple-100 text-purple-700 rounded-lg hover:bg-purple-200 focus:outline-none focus:ring-2 focus:ring-purple-500 transition-colors duration-200"
                    @click="navigateToManagers(club.id)">
                    <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                    </svg>
                    Managers
                  </button>
                  <button
                    class="inline-flex items-center px-3 py-1.5 bg-red-100 text-red-700 rounded-lg hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-red-500 transition-colors duration-200"
                    @click="confirmDelete(club)">
                    <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                    Delete
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Pagination -->
    <div class="mt-6">
      <PaginationControls :current-page="currentPage" :total-pages="totalPages" @page-change="handlePageChange" />
    </div>
  </div>
</template>

<script setup>

import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from '../../../axios.js'
import usePaging from '../../../composables/usePaging'
import PaginationControls from '../../../components/PaginationControls.vue'

// Khởi tạo router để điều hướng giữa các trang
const router = useRouter()
const clubs = ref([])
const districts = ref([])
const streets = ref([])
const searchQuery = ref('')
const selectedDistrict = ref('')
const selectedStreet = ref('')

// Hàm lấy danh sách club từ server với các tham số lọc và phân trang
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

// Sử dụng composable usePaging để quản lý phân trang
const {
  currentPage,
  totalPages,
  handlePageChange,
  updatePagination
} = usePaging(fetchClubs, 1, 10)

// Hàm lấy danh sách quận/huyện từ server
const fetchDistricts = async () => {
  try {
    const response = await axios.get('/api/admin/districts')
    districts.value = response.data
  } catch (error) {
    console.error('Error fetching districts:', error)
  }
}

// Hàm lấy danh sách đường/phố từ server
const fetchStreets = async () => {
  try {
    const response = await axios.get('/api/admin/streets')
    streets.value = response.data
  } catch (error) {
    console.error('Error fetching streets:', error)
  }
}

// Hàm điều hướng sang trang tạo club mới
const navigateToCreate = () => {
  router.push('/admin/clubs/new')
}

// Hàm điều hướng sang trang chỉnh sửa club
const navigateToEdit = (clubId) => {
  router.push(`/admin/clubs/${clubId}/edit`)
}

// Hàm điều hướng sang trang quản lý manager của club
const navigateToManagers = (clubId) => {
  router.push(`/admin/clubs/${clubId}/managers`)
}

// Hàm xác nhận xóa club, nếu đồng ý thì gọi hàm xóa
const confirmDelete = (club) => {
  if (confirm(`Are you sure you want to delete ${club.name}?`)) {
    deleteClub(club.id)
  }
}

// Hàm xóa club khỏi hệ thống
const deleteClub = async (clubId) => {
  try {
    await axios.delete(`/api/admin/clubs/${clubId}`)
    await fetchClubs()
  } catch (error) {
    console.error('Error deleting club:', error)
    alert('Failed to delete club')
  }
}

// Hàm kích hoạt club (nếu club đang ở trạng thái inactive)
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

// Khi component được mount, gọi các hàm lấy dữ liệu ban đầu
onMounted(() => {
  fetchClubs()
  fetchDistricts()
  fetchStreets()
})
</script>
