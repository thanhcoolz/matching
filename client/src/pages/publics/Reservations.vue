<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 py-12">
    <div class="max-w-6xl mx-auto px-6">
      <div class="mb-8">
        <h1 class="text-4xl font-bold text-gray-900">My Reservations</h1>
        <p class="mt-2 text-gray-600">Manage your upcoming</p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="reservation in reservations"
          :key="reservation.id"
          class="bg-white rounded-xl shadow-lg overflow-hidden transform hover:scale-[1.02] transition-all duration-300"
        >
          <div class="p-6 w-full">
            <div class="flex items-center justify-between w-full mb-4">
              <h3 class="text-xl font-bold text-gray-900">
                {{ reservation.club_name }}
              </h3>
              <span
                :class="{
                  'px-3 py-1 rounded-full text-sm font-medium': true,
                  'bg-green-100 text-green-800':
                    reservation.status === 'confirmed',
                  'bg-red-100 text-red-800': ['rejected', 'canceled'].includes(
                    reservation.status
                  ),
                  'bg-gray-100 text-gray-800': reservation.status === 'pending',
                }"
              >
                {{ reservation.status }}
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
                <span>{{
                  reservation.reservation_type === 1 ? "Private" : "Public"
                }}</span>
                <span v-if="reservation.reservation_type === 2"
                  >({{ reservation.number_of_player }} players)</span
                >
              </div>
              <div class="mt-4">
                <button
                  @click="cancelReservation(reservation.id)"
                  :disabled="
                    !canCancel(reservation.start_time) ||
                    ['canceled', 'rejected'].includes(reservation.status)
                  "
                  :class="{
                    'w-full px-4 py-2 text-sm font-medium rounded-md transition-colors': true,
                    'bg-red-600 text-white hover:bg-red-700':
                      canCancel(reservation.start_time) &&
                      !['canceled', 'rejected'].includes(reservation.status),
                    'bg-gray-300 text-gray-500 cursor-not-allowed':
                      !canCancel(reservation.start_time) ||
                      ['canceled', 'rejected'].includes(reservation.status),
                  }"
                >
                  Cancel Reservation
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <Toast v-model:show="showToast" :message="toastMessage" :type="toastType" />
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import apiClient from "../../axios";
import { usePlayerAuthStore } from "../../store/playerAuth";
import Toast from "../../components/Toast.vue";

const showToast = ref(false);
const toastMessage = ref("");
const toastType = ref("success");

const router = useRouter();
const playerAuthStore = usePlayerAuthStore();
const reservations = ref([]);

const checkAuth = async () => {
  const isAuthenticated = await playerAuthStore.checkAuth();
  if (!isAuthenticated) {
    router.push("/signin");
    return false;
  }
  return true;
};

const fetchReservations = async () => {
  try {
    const response = await apiClient.get(
      "/api/player/reservations?upcoming=true"
    );
    reservations.value = response.data;
  } catch (error) {
    console.error("Error fetching reservations:", error);
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

const cancelReservation = async (reservationId) => {
  try {
    await apiClient.patch(`/api/player/reservations/${reservationId}/cancel`);
    await fetchReservations();
    toastMessage.value = "success join match";
    toastType.value = "success";
    showToast.value = true;
  } catch (error) {
    console.error("Error canceling reservation:", error);
  }
};

const canCancel = (startTime) => {
  return new Date(startTime) > new Date();
};

onMounted(async () => {
  if (await checkAuth()) {
    fetchReservations();
  }
});
</script>
