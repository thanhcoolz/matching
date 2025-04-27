<template>
  <div class="min-h-screen w-full bg-gray-50">
    <div class="p-8 animate-fade-in">
      <!-- Welcome Section -->
      <div class="mb-8">
        <h1 class="text-3xl font-semibold text-gray-800">
          Welcome back, {{ currentClubManager?.name || "Manager" }}! 👋
        </h1>
        <p class="mt-2 text-gray-600">
          Here's what's happening in {{ currentClub?.name || "your club" }}
        </p>
      </div>

      <!-- Stats Grid -->
      <div class="mb-10">
        <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-3 gap-6">
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
              <div class="p-3 bg-green-50 rounded-lg">
                <span class="text-2xl">📊</span>
              </div>
            </div>
          </div>

          <!-- Active Reservations -->
          <div class="bg-white rounded-xl shadow-sm p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-gray-600">
                  Active Reservations
                </p>
                <p class="text-2xl font-semibold text-gray-900">
                  {{ stats.active_reservations }}
                </p>
              </div>
              <div class="p-3 bg-yellow-50 rounded-lg">
                <span class="text-2xl">🎉</span>
              </div>
            </div>
          </div>

          <!-- Revenue -->
          <div class="bg-white rounded-xl shadow-sm p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm font-medium text-gray-600">Total Revenue</p>
                <p class="text-2xl font-semibold text-gray-900">
                  {{ formatCurrency(stats.revenue) }}
                </p>
              </div>
              <div class="p-3 bg-purple-50 rounded-lg">
                <span class="text-2xl">💰</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Quick Actions -->
        <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
          <div class="mb-6">
            <h2 class="text-xl font-semibold text-gray-800">Quick Actions</h2>
            <p class="mt-1 text-gray-500">Manage your club resources</p>
          </div>
          <div class="grid grid-cols-1 gap-4">
            <button
              v-for="action in quickActions"
              :key="action.name"
              @click="navigateTo(action.route)"
              class="w-full p-4 bg-gray-50 hover:bg-white border border-gray-200 rounded-lg transition-all hover:shadow-md flex items-center justify-between"
            >
              <div class="flex items-center gap-4">
                <span class="p-2 bg-white rounded-lg text-xl">{{
                  action.icon
                }}</span>
                <div class="text-left">
                  <div class="font-medium text-gray-800">
                    {{ action.title }}
                  </div>
                  <div class="text-sm text-gray-500">
                    {{ action.description }}
                  </div>
                </div>
              </div>
              <span class="text-gray-400 text-xl transition-transform">→</span>
            </button>
          </div>
        </div>

        <!-- Recent Activity -->
        <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
          <div class="mb-6">
            <h2 class="text-xl font-semibold text-gray-800">
              Recent Reservations
            </h2>
            <p class="mt-1 text-gray-500">Latest reservations in your club</p>
          </div>

          <div v-if="loading" class="py-8 text-center">
            <div class="animate-spin text-3xl mb-2">⌛</div>
            <p class="text-gray-500">Loading recent activities...</p>
          </div>

          <div v-else class="space-y-4">
            <div
              v-for="reservation in stats.recent_reservations"
              :key="reservation.id"
              class="p-4 hover:bg-gray-50 rounded-lg transition-colors"
            >
              <div class="flex items-start gap-4">
                <div class="flex-shrink-0">
                  <img
                    v-if="reservation.player.avatar_url"
                    :src="reservation.player.avatar_url"
                    class="w-10 h-10 rounded-full"
                  />
                  <div
                    v-else
                    class="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center"
                  >
                    <span class="text-gray-600 font-medium">
                      {{ reservation.player.username[0] }}
                    </span>
                  </div>
                </div>
                <div class="flex-1">
                  <div class="flex justify-between items-start">
                    <div class="font-medium text-gray-800">
                      {{ reservation.player.username }}
                    </div>
                    <div class="text-sm text-gray-400">
                      {{ formatTime(reservation.created_at) }}
                    </div>
                  </div>
                  <div class="text-sm text-gray-500 mt-1">
                    {{ reservation.player.phone_number }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useClubAuth } from "../../store/clubAuth";
import apiClient from "../../axios.js";

const router = useRouter();
const { currentClub, currentClubManager } = useClubAuth();

const stats = ref({
  total_members: 0,
  total_reservations: 0,
  active_reservations: 0,
  revenue: 0,
  recent_reservations: [],
});

const loading = ref(false);

// Quick Actions definition
const quickActions = [
  {
    name: "managers",
    icon: "👥",
    title: "Manage Staff",
    description: "Add or remove club managers",
    route: "/club/managers",
  },
  {
    name: "reservations",
    icon: "📅",
    title: "Reservations",
    description: "View and manage reservations",
    route: "/club/reservations",
  },
];

const fetchStats = async () => {
  try {
    loading.value = true;
    const response = await apiClient.get("/api/club/dashboard");
    stats.value = response.data;
  } catch (error) {
    console.error("Failed to fetch stats:", error);
  } finally {
    loading.value = false;
  }
};

const formatCurrency = (amount) => {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(amount);
};

const formatTime = (timestamp) => {
  return new Intl.DateTimeFormat("en-US", {
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  }).format(new Date(timestamp));
};

const navigateTo = (route) => {
  router.push(route);
};

onMounted(() => {
  fetchStats();
});
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.5s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
