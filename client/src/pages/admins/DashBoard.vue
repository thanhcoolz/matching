<template>
  <div class="min-h-screen w-full bg-gray-50">
    <div class="p-8 animate-fade-in">
      <!-- Welcome Section -->
      <div class="mb-8">
        <h1 class="text-3xl font-semibold text-gray-800">
          Welcome back, Admin! 👋
        </h1>
        <p class="mt-2 text-gray-600">
          Here's what's happening in your platform
        </p>
      </div>

      <!-- Stats Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total Players -->
        <div class="bg-white rounded-xl shadow-sm p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-600">Total Players</p>
              <p class="text-2xl font-semibold text-gray-900">
                {{ stats.total_players }}
              </p>
            </div>
            <div class="p-3 bg-blue-50 rounded-lg">
              <svg
                class="w-6 h-6 text-blue-500"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
                />
              </svg>
            </div>
          </div>
        </div>

        <!-- Total Clubs -->
        <div class="bg-white rounded-xl shadow-sm p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-600">Total Clubs</p>
              <p class="text-2xl font-semibold text-gray-900">
                {{ stats.total_clubs }}
              </p>
            </div>
            <div class="p-3 bg-green-50 rounded-lg">
              <svg
                class="w-6 h-6 text-green-500"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                />
              </svg>
            </div>
          </div>
        </div>

        <!-- Active Clubs -->
        <div class="bg-white rounded-xl shadow-sm p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-600">Active Clubs</p>
              <p class="text-2xl font-semibold text-gray-900">
                {{ stats.active_clubs }}
              </p>
            </div>
            <div class="p-3 bg-yellow-50 rounded-lg">
              <svg
                class="w-6 h-6 text-yellow-500"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"
                />
              </svg>
            </div>
          </div>
        </div>

        <!-- Total Reservations -->
        <div class="bg-white rounded-xl shadow-sm p-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-gray-600">
                Total Reservations
              </p>
              <p class="text-2xl font-semibold text-gray-900">
                {{ stats.total_reservations }}
              </p>
            </div>
            <div class="p-3 bg-purple-50 rounded-lg">
              <svg
                class="w-6 h-6 text-purple-500"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                />
              </svg>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Recent Players -->
        <div class="bg-white rounded-xl shadow-sm p-6">
          <h2 class="text-lg font-semibold text-gray-900 mb-4">
            Recent Players
          </h2>
          <div class="space-y-4">
            <div
              v-for="player in stats.recent_players"
              :key="player.id"
              class="flex items-center space-x-4"
            >
              <div class="flex-shrink-0">
                <img
                  v-if="player.avatar_url"
                  :src="player.avatar_url"
                  class="w-10 h-10 rounded-full"
                />
                <div
                  v-else
                  class="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center"
                >
                  <span class="text-gray-600 font-medium">{{
                    player.username[0]
                  }}</span>
                </div>
              </div>
              <div>
                <p class="text-sm font-medium text-gray-900">
                  {{ player.username }}
                </p>
                <p class="text-sm text-gray-500">{{ player.phone_number }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Recent Clubs -->
        <div class="bg-white rounded-xl shadow-sm p-6">
          <h2 class="text-lg font-semibold text-gray-900 mb-4">Recent Clubs</h2>
          <div class="space-y-4">
            <div
              v-for="club in stats.recent_clubs"
              :key="club.id"
              class="flex items-center justify-between"
            >
              <div>
                <p class="text-sm font-medium text-gray-900">{{ club.name }}</p>
                <p class="text-sm text-gray-500">
                  {{ club.district.name }}, {{ club.street.name }}
                </p>
              </div>
              <span
                :class="[
                  'px-2 py-1 text-xs font-medium rounded-full',
                  club.active
                    ? 'bg-green-100 text-green-800'
                    : 'bg-gray-100 text-gray-800',
                ]"
              >
                {{ club.active ? "Active" : "Inactive" }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// Import các hàm cần thiết từ Vue và module axios đã được cấu hình
import { ref, onMounted } from "vue";
import axios from "../../axios.js";

// Khởi tạo biến reactive stats để lưu trữ dữ liệu thống kê dashboard
// Các giá trị mặc định được thiết lập để tránh lỗi khi render trước khi dữ liệu được tải
const stats = ref({
  total_players: 0,        // Tổng số người chơi
  total_clubs: 0,          // Tổng số câu lạc bộ
  active_clubs: 0,         // Số câu lạc bộ đang hoạt động
  total_reservations: 0,   // Tổng số đặt chỗ
  recent_players: [],      // Danh sách người chơi gần đây
  recent_clubs: [],        // Danh sách câu lạc bộ gần đây
});

// Hàm gọi API để lấy dữ liệu thống kê cho dashboard
const fetchDashboardStats = async () => {
  try {
    // Gửi request GET đến API endpoint của admin dashboard
    const response = await axios.get("/api/admin/dashboard");
    // Cập nhật biến stats với dữ liệu nhận được từ API
    stats.value = response.data;
  } catch (error) {
    // Xử lý lỗi nếu có, ghi log lỗi ra console
    console.error("Error fetching dashboard stats:", error);
  }
};

// Gọi hàm fetchDashboardStats khi component được mount vào DOM
onMounted(() => {
  fetchDashboardStats();
});
</script>
