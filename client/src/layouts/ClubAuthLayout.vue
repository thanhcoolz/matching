<template>
  <div class="flex min-h-screen w-full bg-gray-50">
    <!-- Sidebar -->
    <div
      class="flex flex-col fixed top-0 left-0 bottom-0 z-50 bg-gray-800 text-white transition-all duration-300"
      :class="{ 'w-16': isSidebarCollapsed, 'w-64': !isSidebarCollapsed }"
    >
      <div
        class="flex items-center justify-between p-5 border-b border-gray-700"
      >
        <h2 class="text-lg font-semibold whitespace-nowrap overflow-hidden">
          🎮 {{ currentClub?.name || "Club" }}
        </h2>
        <button
          class="p-1 text-white hover:bg-gray-700 rounded focus:outline-none"
          @click="toggleSidebar"
        >
          {{ isSidebarCollapsed ? "→" : "←" }}
        </button>
      </div>

      <nav class="flex-1 py-4 overflow-y-auto">
        <router-link
          to="/club/dashboard"
          class="flex items-center px-5 py-3 text-gray-300 hover:bg-gray-700 transition-colors"
          active-class="bg-gray-700 border-l-4 border-blue-500"
        >
          <span class="text-lg">📊</span>
          <span class="ml-3 whitespace-nowrap" v-show="!isSidebarCollapsed"
            >Dashboard</span
          >
        </router-link>

        <router-link
          to="/club/managers"
          class="flex items-center px-5 py-3 text-gray-300 hover:bg-gray-700 transition-colors"
          active-class="bg-gray-700 border-l-4 border-blue-500"
        >
          <span class="text-lg">👥</span>
          <span class="ml-3 whitespace-nowrap" v-show="!isSidebarCollapsed"
            >Managers</span
          >
        </router-link>

        <router-link
          to="/club/reservations"
          class="flex items-center px-5 py-3 text-gray-300 hover:bg-gray-700 transition-colors"
          active-class="bg-gray-700 border-l-4 border-blue-500"
        >
          <span class="text-lg">🎉</span>
          <span class="ml-3 whitespace-nowrap" v-show="!isSidebarCollapsed"
            >Reservations</span
          >
        </router-link>

        <router-link
          to="/club/settings"
          class="flex items-center px-5 py-3 text-gray-300 hover:bg-gray-700 transition-colors"
          active-class="bg-gray-700 border-l-4 border-blue-500"
        >
          <span class="text-lg">⚙️</span>
          <span class="ml-3 whitespace-nowrap" v-show="!isSidebarCollapsed">Settings</span>
        </router-link>
      </nav>

      <div class="p-5 border-t border-gray-700">
        <button
          class="w-full flex items-center justify-center px-4 py-2 border border-gray-600 rounded text-gray-300 hover:bg-gray-700 transition-colors"
          @click="logout"
        >
          <span class="text-lg">🚪</span>
          <span class="ml-3 whitespace-nowrap" v-show="!isSidebarCollapsed"
            >Logout</span
          >
        </button>
      </div>
    </div>

    <!-- Main Content -->
    <div
      class="flex-1 transition-all duration-300"
      :class="{ 'ml-16': isSidebarCollapsed, 'ml-64': !isSidebarCollapsed }"
    >
      <header class="bg-white shadow-sm sticky top-0 z-40">
        <div class="px-6 py-4 flex justify-between items-center">
          <h1 class="text-xl font-semibold text-gray-800">{{ pageTitle }}</h1>
          <div class="flex items-center gap-2">
            <div class="flex items-center gap-3">
              <span class="text-lg">👤</span>
              <span class="text-gray-800">{{
                currentClubManager?.username || "Club Manager"
              }}</span>
            </div>
          </div>
        </div>
      </header>
      <main class="p-6">
        <router-view></router-view>
      </main>
    </div>
  </div>
</template>

<script setup>
// Import các hàm và biến cần thiết từ Vue, Vue Router và store xác thực club
import { ref, computed } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useClubAuth } from "../store/clubAuth";

// Khởi tạo router, route và lấy thông tin club, club manager từ store
const router = useRouter();
const route = useRoute();
const { clearAuth, currentClub, currentClubManager } = useClubAuth();
const isSidebarCollapsed = ref(false);

// Tính toán tiêu đề trang dựa vào đường dẫn hiện tại
const pageTitle = computed(() => {
  const path = route.path.split("/").pop();
  return path.charAt(0).toUpperCase() + path.slice(1);
});

// Hàm thu gọn/mở rộng sidebar
const toggleSidebar = () => {
  isSidebarCollapsed.value = !isSidebarCollapsed.value;
};

// Hàm logout: xoá trạng thái xác thực và chuyển về trang đăng nhập club
const logout = async () => {
  try {
    await clearAuth();
    router.push("/club/signIn");
  } catch (error) {
    console.error("Logout failed:", error);
  }
};
</script>