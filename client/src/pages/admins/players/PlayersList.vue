<template>
  <div class="p-8 bg-gray-50 min-h-screen">
    <!-- Header Section -->
    <div class="bg-white rounded-xl shadow-md p-6 mb-8">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-2xl font-bold text-gray-900">Players Management</h1>
          <p class="text-gray-500 mt-1">
            Manage and monitor all registered players
          </p>
        </div>
      </div>
    </div>

    <!-- Search Section -->
    <div class="bg-white rounded-xl shadow-md p-6 mb-8">
      <div class="relative">
        <input
          v-model="searchQuery"
          type="text"
          placeholder="Search players by username or email..."
          @input="debouncedFetchPlayers"
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

    <!-- Table Section -->
    <div class="bg-white rounded-xl shadow-md overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-gray-50">
            <tr>
              <th
                class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider"
              >
                Player Info
              </th>
              <th
                class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider"
              >
                Phone Number
              </th>
              <th
                class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider"
              >
                Age & Gender
              </th>
              <th
                class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider"
              >
                Location
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr
              v-for="player in players"
              :key="player.id"
              class="hover:bg-gray-50 transition-colors duration-200"
            >
              <td class="px-6 py-4">
                <div class="flex items-center gap-3">
                  <div v-if="player.avatar_url" class="flex-shrink-0 w-10 h-10">
                    <img
                      :src="player.avatar_url"
                      class="w-10 h-10 rounded-full object-cover"
                      :alt="player.username"
                    />
                  </div>
                  <div
                    v-else
                    class="flex-shrink-0 w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center"
                  >
                    <span class="text-gray-600 font-medium">{{
                      player.username[0]
                    }}</span>
                  </div>
                  <div>
                    <div class="font-medium text-gray-900">
                      {{ player.username }}
                    </div>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4 text-sm text-gray-600">
                {{ player.phone_number }}
              </td>
              <td class="px-6 py-4 text-sm text-gray-600">
                <div class="flex flex-col">
                  <span>Age: {{ player.age }}</span>
                  <span class="capitalize">{{ player.gender }}</span>
                </div>
              </td>
              <td class="px-6 py-4 text-sm text-gray-600">
                <div class="flex flex-col">
                  <span
                    >{{ player.district.name }}, {{ player.city.name }}</span
                  >
                  <span class="text-gray-500">{{ player.street.name }}</span>
                </div>
              </td>
              <!-- <td class="px-6 py-4">
                <div class="flex items-center gap-2">
                  <button
                    class="inline-flex items-center px-3 py-1.5 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors duration-200"
                    @click="viewPlayerDetails(player.id)"
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
                        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                      />
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                      />
                    </svg>
                    View
                  </button>
                </div>
              </td> -->
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Pagination -->
    <div class="mt-6">
      <PaginationControls
        :current-page="currentPage"
        :total-pages="totalPages"
        @page-change="handlePageChange"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "../../../axios.js";
import usePaging from "../../../composables/usePaging";
import { debounce } from "lodash";
import PaginationControls from "../../../components/PaginationControls.vue";

const router = useRouter();
const players = ref([]);
const searchQuery = ref("");

const fetchPlayers = async () => {
  try {
    const params = {
      search: searchQuery.value,
      page: currentPage.value,
    };
    const response = await axios.get("/api/admin/players", { params });
    players.value = response.data.players;
    updatePagination(response.data.pagination);
  } catch (error) {
    console.error("Error fetching players:", error);
  }
};

const { currentPage, totalPages, handlePageChange, updatePagination } =
  usePaging(fetchPlayers, 1, 10);

const viewPlayerDetails = (playerId) => {
  router.push(`/admin/players/${playerId}`);
};

// Remove formatDate function since we don't have created_at field
// Remove active status related code since we don't have that field

const formatDate = (date) => {
  return new Date(date).toLocaleDateString();
};

// Add debounce functionality
const debouncedFetchPlayers = debounce(() => {
  fetchPlayers();
}, 300);

onMounted(() => {
  fetchPlayers();
});
</script>
