<template>
  <div class="flex min-h-screen w-full bg-gray-50">
    <!-- Sidebar -->
    <div class="flex flex-col fixed top-0 left-0 bottom-0 z-50 bg-gray-800 text-white transition-all duration-300"
      :class="{ 'w-16': isSidebarCollapsed, 'w-64': !isSidebarCollapsed }">
      <div class="flex items-center justify-between p-5 border-b border-gray-700">
        <h2 class="text-lg font-semibold whitespace-nowrap overflow-hidden">🎮 Admin</h2>
        <button class="p-1 text-white hover:bg-gray-700 rounded focus:outline-none" @click="toggleSidebar">
          {{ isSidebarCollapsed ? '→' : '←' }}
        </button>
      </div>
      <nav class="flex-1 py-4 overflow-y-auto">
        <router-link to="/admin/dashboard"
          class="flex items-center px-5 py-3 text-gray-300 hover:bg-gray-700 transition-colors"
          active-class="bg-gray-700 border-l-4 border-blue-500">
          <span class="text-lg">📊</span>
          <span class="ml-3 whitespace-nowrap" v-show="!isSidebarCollapsed">Dashboard</span>
        </router-link>
        <router-link to="/admin/players"
          class="flex items-center px-5 py-3 text-gray-300 hover:bg-gray-700 transition-colors"
          active-class="bg-gray-700 border-l-4 border-blue-500">
          <span class="text-lg">👥</span>
          <span class="ml-3 whitespace-nowrap" v-show="!isSidebarCollapsed">Players</span>
        </router-link>
        <router-link to="/admin/clubs"
          class="flex items-center px-5 py-3 text-gray-300 hover:bg-gray-700 transition-colors"
          active-class="bg-gray-700 border-l-4 border-blue-500">
          <span class="text-lg">🏢</span>
          <span class="ml-3 whitespace-nowrap" v-show="!isSidebarCollapsed">Clubs</span>
        </router-link>
        <router-link to="/admin/parties"
          class="flex items-center px-5 py-3 text-gray-300 hover:bg-gray-700 transition-colors"
          active-class="bg-gray-700 border-l-4 border-blue-500">
          <span class="text-lg">🎉</span>
          <span class="ml-3 whitespace-nowrap" v-show="!isSidebarCollapsed">Parties</span>
        </router-link>
      </nav>
      <div class="p-5 border-t border-gray-700">
        <button
          class="w-full flex items-center justify-center px-4 py-2 border border-gray-600 rounded text-gray-300 hover:bg-gray-700 transition-colors"
          @click="handleLogout">
          <span class="text-lg">🚪</span>
          <span class="ml-3 whitespace-nowrap" v-show="!isSidebarCollapsed">Logout</span>
        </button>
      </div>
    </div>

    <!-- Main Content -->
    <div class="flex-1 transition-all duration-300"
      :class="{ 'ml-16': isSidebarCollapsed, 'ml-64': !isSidebarCollapsed }">
      <header class="bg-white shadow-sm sticky top-0 z-40">
        <div class="px-6 py-4 flex justify-between items-center">
          <h1 class="text-xl font-semibold text-gray-800">{{ currentPageTitle }}</h1>
          <div class="flex items-center gap-2">
            <span class="text-lg">👤</span>
            <span class="text-gray-800">Admin</span>
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
import { ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useAuth } from '../store/auth.js';

const route = useRoute();
const router = useRouter();
const { clearAuth } = useAuth();
const isSidebarCollapsed = ref(false);

const currentPageTitle = computed(() => {
  const path = route.path.split('/').pop();
  return path.charAt(0).toUpperCase() + path.slice(1);
});

const toggleSidebar = () => {
  isSidebarCollapsed.value = !isSidebarCollapsed.value;
};

const handleLogout = async () => {
  await clearAuth();
  router.push('/admin/signIn');
};
</script>
