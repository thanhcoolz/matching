<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 py-12">
    <div class="max-w-6xl mx-auto px-6">
      <div class="mb-8">
        <h1 class="text-4xl font-bold text-gray-900">Available Matches</h1>
        <p class="mt-2 text-gray-600">
          Find and join public matches with available slots
        </p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="reservation in publicReservations"
          :key="reservation.id"
          class="bg-white rounded-xl shadow-lg overflow-hidden transform hover:scale-[1.02] transition-all duration-300"
        >
          <div class="p-6 w-full">
            <div class="flex items-center justify-between w-full mb-4">
              <h3 class="text-xl font-bold text-gray-900">
                {{ reservation.club_name }}
              </h3>
              <span
                class="px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800"
              >
                {{ reservation.number_of_player - reservation.current_players }}
                slots left
              </span>
            </div>

            <div class="space-y-3">
              <div class="flex items-center gap-2 text-gray-600">
                <svg
                  class="w-5 h-5 text-gray-400"
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
                <span>{{ formatDate(reservation.start_time) }}</span>
              </div>

              <div class="flex items-center gap-2 text-gray-600">
                <svg
                  class="w-5 h-5 text-gray-400"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
                <span
                  >{{ formatTime(reservation.start_time) }} ({{
                    reservation.duration_hours
                  }}
                  hours)</span
                >
              </div>

              <div class="flex items-center gap-2 text-gray-600">
                <svg
                  class="w-5 h-5 text-gray-400"
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
                <span
                  >{{ reservation.current_players }}/{{
                    reservation.number_of_player
                  }}
                  players</span
                >
              </div>

              <button
                @click="joinReservation(reservation.id)"
                class="mt-4 w-full bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition-colors duration-200"
              >
                Join Match
              </button>
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
import apiClient from "../../axios";
import { usePlayerAuthStore } from "../../store/playerAuth";

const router = useRouter();
const playerAuthStore = usePlayerAuthStore();
const publicReservations = ref([]);

const checkAuth = async () => {
  const isAuthenticated = await playerAuthStore.checkAuth();
  if (!isAuthenticated) {
    router.push("/signin");
    return false;
  }
  return true;
};

const fetchPublicReservations = async () => {
  try {
    const response = await apiClient.get("/api/player/public_reservations");
    publicReservations.value = response.data;
  } catch (error) {
    console.error("Error fetching public reservations:", error);
  }
};

const joinReservation = async (reservationId) => {
  try {
    await apiClient.post(
      `/api/player/public_reservations/${reservationId}/join`
    );
    router.push("/reservations");
  } catch (error) {
    console.error("Error joining reservation:", error);
  }
};

const formatDate = (dateString) => {
  const date = new Date(dateString);
  return date.toLocaleDateString("en-US", {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  });
};

const formatTime = (dateString) => {
  const date = new Date(dateString);
  return date.toLocaleTimeString("en-US", {
    hour: "2-digit",
    minute: "2-digit",
  });
};

onMounted(async () => {
  if (await checkAuth()) {
    fetchPublicReservations();
  }
});
</script>
