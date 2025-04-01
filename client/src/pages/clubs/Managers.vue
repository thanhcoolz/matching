<template>
  <div class="p-8 bg-gray-50 min-h-screen">
    <!-- Header Section -->
    <div class="bg-white rounded-xl shadow-md p-6 mb-8">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-2xl font-bold text-gray-900">Club Management</h1>
          <p class="text-gray-500 mt-1">
            Manage your club's staff and settings
          </p>
        </div>
        <router-link
          to="/club/managers/create"
          class="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-3 rounded-lg hover:from-blue-700 hover:to-blue-800 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 shadow-md transition-all duration-300 flex items-center gap-2"
        >
          <svg
            class="w-5 h-5"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 4v16m8-8H4"
            />
          </svg>
          Add Manager
        </router-link>
      </div>
    </div>

    <!-- Tabs -->
    <div class="bg-white rounded-xl shadow-md p-6 mb-8">
      <div class="border-b border-gray-200">
        <nav class="-mb-px flex space-x-8" aria-label="Tabs">
          <button
            @click="activeTab = 'managers'"
            :class="[
              activeTab === 'managers'
                ? 'border-blue-500 text-blue-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300',
              'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm',
            ]"
          >
            Managers
          </button>
          <button
            @click="activeTab = 'tables'"
            :class="[
              activeTab === 'tables'
                ? 'border-blue-500 text-blue-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300',
              'whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm',
            ]"
          >
            Tables
          </button>
        </nav>
      </div>
    </div>

    <!-- Table Numbers Manager -->
    <TableNumbersManager v-if="activeTab === 'tables'" />

    <!-- Search Section -->
    <div class="bg-white rounded-xl shadow-md p-6 mb-8">
      <div class="relative">
        <input
          v-model="search.username"
          type="text"
          placeholder="Search by manager name..."
          @input="fetchManagers"
          class="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all"
        />
        <svg
          class="w-6 h-6 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
          />
        </svg>
      </div>
    </div>

    <!-- Managers Table -->
    <div class="bg-white rounded-xl shadow-md overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-gray-50">
            <tr>
              <th
                class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider"
              >
                Manager Info
              </th>
              <th
                class="px-6 py-4 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider"
              >
                Actions
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr
              v-for="manager in managers"
              :key="manager.id"
              class="hover:bg-gray-50 transition-colors duration-200"
            >
              <td class="px-6 py-4">
                <div class="flex items-center gap-3">
                  <div
                    class="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center"
                  >
                    <span class="text-blue-700 font-medium">{{
                      manager.username[0].toUpperCase()
                    }}</span>
                  </div>
                  <div>
                    <div class="font-medium text-gray-900">
                      {{ manager.username }}
                    </div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4">
                <div class="flex items-center justify-end gap-3">
                  <router-link
                    :to="`/club/managers/${manager.id}/edit`"
                    class="inline-flex items-center px-3 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors duration-200"
                  >
                    <svg
                      class="w-4 h-4 mr-1"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                      />
                    </svg>
                    Edit
                  </router-link>
                  <button
                    class="inline-flex items-center px-3 py-2 bg-red-100 text-red-700 rounded-lg hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-red-500 transition-colors duration-200"
                    @click="confirmDelete(manager)"
                  >
                    <svg
                      class="w-4 h-4 mr-1"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                      />
                    </svg>
                    Delete
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Empty State -->
      <div v-if="managers.length === 0" class="text-center py-12">
        <div class="max-w-sm mx-auto">
          <svg
            class="w-12 h-12 mx-auto text-gray-400 mb-4"
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
          <h3 class="text-lg font-medium text-gray-900 mb-2">
            No managers found
          </h3>
          <p class="text-gray-500 mb-6">
            Add managers to help manage your club
          </p>
          <router-link
            to="/club/managers/create"
            class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
          >
            <svg
              class="w-5 h-5 mr-2"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 4v16m8-8H4"
              />
            </svg>
            Add First Manager
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import axios from "../../axios.js";
import TableNumbersManager from "../../components/TableNumbersManager.vue";

const router = useRouter();
const managers = ref([]);
const activeTab = ref("managers");
const search = ref({
  username: null,
});

const fetchManagers = async () => {
  try {
    const params = {};
    if (search.value.username) {
      params.username = search.value.username;
    }

    const response = await axios.get("/api/club/managers", { params });
    managers.value = response.data;
  } catch (error) {
    console.error("Error fetching managers:", error);
  }
};

const navigateToEdit = (managerId) => {
  router.push(`/club/managers/${managerId}/edit`);
};

const confirmDelete = (manager) => {
  if (confirm(`Are you sure you want to delete manager ${manager.username}?`)) {
    deleteManager(manager.id);
  }
};

const deleteManager = async (managerId) => {
  try {
    await axios.delete(`/api/club/managers/${managerId}`);
    await fetchManagers();
  } catch (error) {
    console.error("Error deleting manager:", error);
    alert("Failed to delete manager");
  }
};

onMounted(() => {
  fetchManagers();
});
</script>
