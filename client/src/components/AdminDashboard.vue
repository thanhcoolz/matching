<template>
  <div class="dashboard">
    <div class="stats-grid">
      <div class="stat-card">
        <h3>Players</h3>
        <div class="stat-value">{{ stats.players }}</div>
      </div>
      <div class="stat-card">
        <h3>Clubs</h3>
        <div class="stat-value">{{ stats.clubs }}</div>
      </div>
      <div class="stat-card">
        <h3>Parties</h3>
        <div class="stat-value">{{ stats.parties }}</div>
      </div>
      <div class="stat-card">
        <h3>Club Managers</h3>
        <div class="stat-value">{{ stats.clubManagers }}</div>
      </div>
    </div>

    <div class="management-section">
      <h2>Quick Actions</h2>
      <div class="action-buttons">
        <button @click="navigateTo('players')">
          Manage Players
        </button>
        <button @click="navigateTo('clubs')">
          Manage Clubs
        </button>
        <button @click="navigateTo('parties')">
          Manage Parties
        </button>
        <button @click="navigateTo('managers')">
          Manage Club Managers
        </button>
      </div>
    </div>

    <div class="recent-activity">
      <h2>Recent Activity</h2>
      <div v-if="loading" class="loading">Loading...</div>
      <div v-else class="activity-list">
        <div v-for="activity in recentActivities" :key="activity.id" class="activity-item">
          <span class="activity-time">{{ formatTime(activity.timestamp) }}</span>
          <span class="activity-description">{{ activity.description }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import apiClient from '../axios.js';

export default {
  name: 'AdminDashboard',
  setup() {
    const router = useRouter();
    const stats = ref({
      players: 0,
      clubs: 0,
      parties: 0,
      clubManagers: 0
    });
    const recentActivities = ref([]);
    const loading = ref(true);

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
      return new Date(timestamp).toLocaleString();
    };

    onMounted(() => {
      fetchStats();
      fetchRecentActivities();
    });

    return {
      stats,
      recentActivities,
      loading,
      navigateTo,
      formatTime
    };
  }
};
</script>

<style scoped>
.dashboard {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin-bottom: 40px;
}

.stat-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  text-align: center;
}

.stat-card h3 {
  margin: 0;
  color: #666;
  font-size: 16px;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #007bff;
  margin-top: 10px;
}

.management-section {
  margin-bottom: 40px;
}

.action-buttons {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 15px;
  margin-top: 20px;
}

button {
  padding: 12px 20px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

button:hover {
  background-color: #0056b3;
}

.recent-activity {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.activity-list {
  margin-top: 20px;
}

.activity-item {
  padding: 10px 0;
  border-bottom: 1px solid #eee;
  display: flex;
  align-items: center;
}

.activity-time {
  color: #666;
  font-size: 14px;
  margin-right: 15px;
  min-width: 150px;
}

.activity-description {
  color: #333;
}

.loading {
  text-align: center;
  color: #666;
  padding: 20px;
}

h2 {
  color: #333;
  margin-bottom: 20px;
}
</style>
