<template>
  <div class="min-h-screen w-full bg-gray-50">
    <div class="p-8 animate-fade-in">
      <!-- Welcome Section -->
      <div class="mb-8">
        <h1 class="text-3xl font-semibold text-gray-800">Welcome back, Admin! 👋</h1>
        <p class="mt-2 text-gray-600">Here's what's happening in your platform</p>
      </div>

      <!-- Stats Grid -->
      <div class="mb-10">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div
            v-for="(value, key) in stats"
            :key="key"
            class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow"
          >
            <div class="flex justify-between items-start mb-5">
              <div class="p-3 rounded-lg bg-gray-50 text-xl">
                {{ getStatIcon(key) }}
              </div>
              <div class="flex items-center gap-2 px-3 py-1 rounded-full bg-green-50 text-green-600 text-sm">
                <span>↗</span>
                <span>+5%</span>
              </div>
            </div>
            <div>
              <h3 class="text-gray-500 text-sm font-medium mb-2">
                {{ formatStatName(key) }}
              </h3>
              <div class="text-3xl font-semibold text-gray-800" v-animate-number="value">
                {{ value }}
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
            <p class="mt-1 text-gray-500">Manage your platform resources</p>
          </div>
          <div class="grid grid-cols-1 gap-4">
            <button
              v-for="action in quickActions"
              :key="action.name"
              @click="navigateTo(action.route)"
              class="w-full p-4 bg-gray-50 hover:bg-white border border-gray-200 rounded-lg transition-all hover:shadow-md flex items-center justify-between"
            >
              <div class="flex items-center gap-4">
                <span class="p-2 bg-white rounded-lg text-xl">{{ action.icon }}</span>
                <div class="text-left">
                  <div class="font-medium text-gray-800">{{ action.title }}</div>
                  <div class="text-sm text-gray-500">{{ action.description }}</div>
                </div>
              </div>
              <span class="text-gray-400 text-xl transition-transform">→</span>
            </button>
          </div>
        </div>

        <!-- Recent Activity -->
        <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
          <div class="mb-6">
            <h2 class="text-xl font-semibold text-gray-800">Recent Activity</h2>
            <p class="mt-1 text-gray-500">Latest actions across the platform</p>
          </div>

          <div v-if="loading" class="py-8 text-center">
            <div class="animate-spin text-3xl mb-2">⌛</div>
            <p class="text-gray-500">Loading recent activities...</p>
          </div>

          <div v-else class="space-y-4">
            <div
              v-for="activity in recentActivities"
              :key="activity.id"
              class="p-4 hover:bg-gray-50 rounded-lg transition-colors"
            >
              <div class="flex items-start gap-4">
                <div class="p-2 bg-gray-50 rounded-lg text-xl">
                  {{ getActivityIcon(activity.type) }}
                </div>
                <div class="flex-1">
                  <div class="flex justify-between items-start">
                    <div class="font-medium text-gray-800">{{ activity.description }}</div>
                    <div class="text-sm text-gray-400">{{ formatTime(activity.timestamp) }}</div>
                  </div>
                  <div v-if="activity.details" class="text-sm text-gray-500 mt-1">
                    {{ activity.details }}
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
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import apiClient from '../../axios.js';

// Custom number animation directive
const vAnimateNumber = {
  mounted(el, binding) {
    const start = 0;
    const end = binding.value;
    const duration = 1000;
    const startTime = performance.now();

    function update(currentTime) {
      const elapsed = currentTime - startTime;
      const progress = Math.min(elapsed / duration, 1);

      const value = Math.floor(start + (end - start) * progress);
      el.textContent = value.toLocaleString();

      if (progress < 1) {
        requestAnimationFrame(update);
      }
    }

    requestAnimationFrame(update);
  }
};

const router = useRouter();
const stats = ref({
  players: 0,
  clubs: 0,
  parties: 0,
  clubManagers: 0
});
const recentActivities = ref([]);
const loading = ref(true);

const quickActions = [
  {
    icon: '👥',
    title: 'Manage Players',
    description: 'View and manage player profiles',
    route: 'players'
  },
  {
    icon: '🏢',
    title: 'Manage Clubs',
    description: 'Oversee club operations',
    route: 'clubs'
  },
  {
    icon: '🎉',
    title: 'Manage Parties',
    description: 'Monitor ongoing parties',
    route: 'parties'
  },
  {
    icon: '👔',
    title: 'Manage Club Managers',
    description: 'Supervise club management',
    route: 'managers'
  }
];

const getStatIcon = (type) => {
  const icons = {
    players: '👥',
    clubs: '🏢',
    parties: '🎉',
    clubManagers: '👔'
  };
  return icons[type] || '📊';
};

const formatStatName = (key) => {
  return key
    .replace(/([A-Z])/g, ' $1')
    .split(' ')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
};

const getActivityIcon = (type) => {
  const icons = {
    create: '➕',
    update: '✏️',
    delete: '🗑️',
    login: '🔑'
  };
  return icons[type] || '📝';
};

const fetchStats = async () => {
  try {
    const response = await apiClient.get('/api/admin/dashboard/stats');
    stats.value = response.data;
  } catch (error) {
    console.error('Failed to fetch stats:', error);
  }
};

const fetchRecentActivities = async () => {
  try {
    const response = await apiClient.get('/api/admin/dashboard/activities');
    recentActivities.value = response.data;
  } catch (error) {
    console.error('Failed to fetch activities:', error);
  } finally {
    loading.value = false;
  }
};

const navigateTo = (section) => {
  router.push(`/admin/${section}`);
};

const formatTime = (timestamp) => {
  const date = new Date(timestamp);
  const now = new Date();
  const diff = now - date;

  // If less than 24 hours, show relative time
  if (diff < 24 * 60 * 60 * 1000) {
    const hours = Math.floor(diff / (60 * 60 * 1000));
    if (hours < 1) {
      const minutes = Math.floor(diff / (60 * 1000));
      return `${minutes} minute${minutes !== 1 ? 's' : ''} ago`;
    }
    return `${hours} hour${hours !== 1 ? 's' : ''} ago`;
  }

  // Otherwise show date
  return date.toLocaleDateString(undefined, {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

onMounted(() => {
  fetchStats();
  fetchRecentActivities();
});
</script>
