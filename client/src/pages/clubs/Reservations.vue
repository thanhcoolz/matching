<template>
  <div class="space-y-6">
    <!-- Status Filter -->
    <div class="flex items-center gap-4">
      <label class="text-gray-700">Filter by Status:</label>
      <select
        v-model="selectedStatus"
        class="form-select rounded-md border-gray-300 shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 focus:ring-opacity-50"
      >
        <option value="">All</option>
        <option value="pending">Pending</option>
        <option value="confirmed">Confirmed</option>
        <option value="rejected">Rejected</option>
        <option value="canceled">Canceled</option>
      </select>
    </div>

    <!-- Reservations Table -->
    <div class="bg-white shadow-sm rounded-lg">
      <div class="w-full overflow-x-auto">
        <table class="w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th
                v-for="header in tableHeaders"
                :key="header"
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                {{ header }}
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-if="loading" class="animate-pulse">
              <td
                :colspan="tableHeaders.length"
                class="px-6 py-4 text-center text-gray-500"
              >
                Loading...
              </td>
            </tr>
            <tr v-else-if="reservations.length === 0">
              <td
                :colspan="tableHeaders.length"
                class="px-6 py-4 text-center text-gray-500"
              >
                No reservations found
              </td>
            </tr>
            <tr
              v-for="reservation in reservations"
              :key="reservation.id"
              class="hover:bg-gray-50"
            >
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ reservation.id }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ reservation.reservation_type }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ formatDate(reservation.start_time) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ formatDate(reservation.end_time) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{
                  calculateDuration(
                    reservation.start_time,
                    reservation.end_time
                  )
                }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm">
                <select
                  v-model="reservation.status"
                  @change="updateStatus(reservation)"
                  class="form-select rounded-md text-sm border-gray-300 focus:border-blue-300 focus:ring focus:ring-blue-200 focus:ring-opacity-50"
                >
                  <option value="pending">Pending</option>
                  <option value="confirmed">Confirmed</option>
                  <option value="rejected">Rejected</option>
                  <option value="canceled">Canceled</option>
                </select>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <Toast v-model:show="showToast" :message="toastMessage" :type="toastType" />
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import axios from "../../axios";
import Toast from "../../components/Toast.vue";

const showToast = ref(false);
const toastMessage = ref("");
const toastType = ref("success");

const loading = ref(false);
const reservations = ref([]);
const selectedStatus = ref("");
const tableHeaders = [
  "ID",
  "Type",
  "Start Time",
  "End Time",
  "Duration",
  "Status",
];

const fetchReservations = async () => {
  loading.value = true;
  try {
    const params = {};
    if (selectedStatus.value) {
      params.status = selectedStatus.value;
    }
    const response = await axios.get("/api/club/reservations", { params });
    reservations.value = response.data;
  } catch (error) {
    console.error("Error fetching reservations:", error);
  } finally {
    loading.value = false;
  }
};

const formatDate = (date) => {
  if (!date) return "-";
  return new Date(date).toLocaleString();
};

const calculateDuration = (start, end) => {
  if (!start || !end) return "-";
  const startTime = new Date(start);
  const endTime = new Date(end);
  const diffInMinutes = Math.round((endTime - startTime) / (1000 * 60));
  const hours = Math.floor(diffInMinutes / 60);
  const minutes = diffInMinutes % 60;
  return `${hours}h ${minutes}m`;
};

const updateStatus = async (reservation) => {
  try {
    await axios.patch(
      `/api/club/reservations/${reservation.id}/update_status`,
      {
        status: reservation.status,
      }
    );
    toastMessage.value = "Reservation status updated successfully";
    toastType.value = "success";
    showToast.value = true;
  } catch (error) {
    console.error("Error updating reservation status:", error);
    toastMessage.value = "Failed to update reservation status";
    toastType.value = "error";
    showToast.value = true;
    // Revert the status if the update fails
    await fetchReservations();
  }
};

const getStatusClass = (status) => {
  const classes = {
    pending: "bg-yellow-100 text-yellow-800",
    confirmed: "bg-green-100 text-green-800",
    cancelled: "bg-red-100 text-red-800",
    completed: "bg-blue-100 text-blue-800",
  };
  return classes[status] || "bg-gray-100 text-gray-800";
};

watch(selectedStatus, () => {
  fetchReservations();
});

onMounted(() => {
  fetchReservations();
});
</script>
