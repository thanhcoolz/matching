<template>
  <div class="min-h-screen bg-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Dashboard Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Club Dashboard</h1>
      </div>

      <!-- Stats Cards -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white rounded-lg shadow p-6">
          <h3 class="text-lg font-medium text-gray-900">Total Members</h3>
          <p class="text-3xl font-bold text-indigo-600">{{ totalMembers }}</p>
        </div>
        <div class="bg-white rounded-lg shadow p-6">
          <h3 class="text-lg font-medium text-gray-900">Active Events</h3>
          <p class="text-3xl font-bold text-green-600">{{ activeEvents }}</p>
        </div>
        <div class="bg-white rounded-lg shadow p-6">
          <h3 class="text-lg font-medium text-gray-900">Monthly Revenue</h3>
          <p class="text-3xl font-bold text-blue-600">${{ revenue }}</p>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-200">
          <h2 class="text-xl font-medium text-gray-900">Recent Activity</h2>
        </div>
        <div class="p-6">
          <ul class="divide-y divide-gray-200">
            <li v-for="activity in recentActivities" :key="activity.id" class="py-4">
              <div class="flex items-center">
                <span class="text-sm text-gray-500">{{ activity.date }}</span>
                <p class="ml-4 text-sm text-gray-900">{{ activity.description }}</p>
              </div>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

// Dashboard data
const totalMembers = ref(156)
const activeEvents = ref(8)
const revenue = ref(12500)

const recentActivities = ref([
  {
    id: 1,
    date: '2024-01-15',
    description: 'New member registration: John Doe'
  },
  {
    id: 2,
    date: '2024-01-14',
    description: 'Event created: Weekend Workshop'
  },
  {
    id: 3,
    date: '2024-01-13',
    description: 'Payment received: $500 for membership fees'
  },
  {
    id: 4,
    date: '2024-01-12',
    description: 'Updated club policy documents'
  }
])
</script>
