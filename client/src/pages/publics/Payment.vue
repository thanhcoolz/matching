<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 py-12">
    <div class="max-w-3xl mx-auto px-6">
      <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
        <!-- Header -->
        <div class="bg-gradient-to-r from-blue-600 to-blue-700 p-8">
          <h1 class="text-3xl font-bold text-white">Chi tiết thanh toán</h1>
        </div>

        <!-- Content -->
        <div class="p-8 space-y-6">
          <!-- Club Info -->
          <div class="space-y-2">
            <h2 class="text-2xl font-semibold text-gray-900">
              Thông tin câu lạc bộ
            </h2>
            <div class="flex items-start gap-4 p-4 bg-gray-50 rounded-xl">
              <div class="p-3 bg-blue-50 rounded-lg">
                <svg
                  class="w-6 h-6 text-blue-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                  />
                </svg>
              </div>
              <div class="space-y-1">
                <p class="text-lg font-semibold text-gray-900">
                  {{ reservation.club_name }}
                </p>
                <p class="text-gray-600">{{ reservation.club_address }}</p>
              </div>
            </div>
          </div>

          <!-- Reservation Details -->
          <div class="space-y-4">
            <h2 class="text-2xl font-semibold text-gray-900">
              Chi tiết đặt bàn
            </h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <!-- Time Info -->
              <div class="p-4 bg-gray-50 rounded-xl space-y-2">
                <div class="flex items-center gap-2 text-gray-600">
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
                      d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                  <span class="font-medium">Thời gian bắt đầu:</span>
                </div>
                <p class="text-lg font-semibold text-gray-900">
                  {{ formatDateTime(reservation.start_time) }}
                </p>
              </div>

              <!-- Duration -->
              <div class="p-4 bg-gray-50 rounded-xl space-y-2">
                <div class="flex items-center gap-2 text-gray-600">
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
                      d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                  <span class="font-medium">Thời lượng:</span>
                </div>
                <p class="text-lg font-semibold text-gray-900">
                  {{ reservation.duration_hours }} giờ
                </p>
              </div>

              <!-- Type -->
              <div class="p-4 bg-gray-50 rounded-xl space-y-2">
                <div class="flex items-center gap-2 text-gray-600">
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
                      d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
                    />
                  </svg>
                  <span class="font-medium">Loại đặt bàn:</span>
                </div>
                <p class="text-lg font-semibold text-gray-900">
                  {{ reservation.type === 1 ? "Riêng tư" : "Công khai" }}
                </p>
              </div>

              <!-- Players -->
              <div class="p-4 bg-gray-50 rounded-xl space-y-2">
                <div class="flex items-center gap-2 text-gray-600">
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
                      d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"
                    />
                  </svg>
                  <span class="font-medium">Số người chơi:</span>
                </div>
                <p class="text-lg font-semibold text-gray-900">
                  {{ reservation.number_of_player }} người
                </p>
              </div>
            </div>
          </div>

          <!-- Payment Summary -->
          <div class="space-y-4">
            <h2 class="text-2xl font-semibold text-gray-900">
              Tổng thanh toán
            </h2>
            <div class="p-6 bg-gray-50 rounded-xl space-y-4">
              <div class="flex justify-between items-center text-lg">
                <span class="text-gray-600">Giá mỗi giờ</span>
                <span class="font-semibold">80,000 VNĐ</span>
              </div>
              <div class="flex justify-between items-center text-lg">
                <span class="text-gray-600">Số giờ</span>
                <span class="font-semibold"
                  >× {{ reservation.duration_hours }}</span
                >
              </div>
              <div class="h-px bg-gray-200 my-4"></div>
              <div class="flex justify-between items-center text-xl font-bold">
                <span class="text-gray-900">Tổng cộng</span>
                <span class="text-blue-600"
                  >{{
                    formatCurrency(reservation.duration_hours * 80000)
                  }}
                  VNĐ</span
                >
              </div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex gap-4 pt-6">
            <button
              @click="confirmPayment"
              class="flex-1 py-4 bg-gradient-to-r from-blue-600 to-blue-700 text-white text-lg font-semibold rounded-xl hover:from-blue-700 hover:to-blue-800 transition-all duration-300 shadow-lg hover:shadow-xl"
            >
              Xác nhận thanh toán
            </button>
            <button
              @click="$router.push('/reservations')"
              class="flex-1 py-4 bg-gray-100 text-gray-600 text-lg font-semibold rounded-xl hover:bg-gray-200 transition-all duration-300"
            >
              Hủy
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
  <Toast v-model:show="showToast" :message="toastMessage" :type="toastType" />
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useRoute, useRouter } from "vue-router";
import axios from "../../axios.js";
import Toast from "../../components/Toast.vue";

// Add these refs for toast
const showToast = ref(false);
const toastMessage = ref("");
const toastType = ref("success");

// reactive reservation object (must match your template bindings)
const reservation = ref({
  club_name: "",
  club_address: "",
  start_time: "",
  duration_hours: 0,
  type: 0,
  number_of_player: 0,
});

const route = useRoute();
const router = useRouter();

// Fetch data
async function fetchReservation(id) {
  try {
    const { data } = await axios.get(`/api/player/reservations/${id}`);
    reservation.value = data;
  } catch (err) {
    console.error("Failed to fetch reservation:", err);
  }
}

// Called when the user clicks “Xác nhận thanh toán”
async function confirmPayment() {
  try {
    // Gọi API để cập nhật trạng thái reservation sang "paid"
    await axios.put(
      `/api/player/reservations/${route.params.id}/update_payment_status`,
      {
        status: "paid",
      }
    );
    toastMessage.value = "Thanh toán thành công!";
    toastType.value = "success";
    showToast.value = true;
    setTimeout(() => {
      router.push("/reservations");
    }, 500);
  } catch (error) {
    toastMessage.value = "Có lỗi xảy ra khi thanh toán!";
    toastType.value = "error";
    showToast.value = true;
  }
}

// Helpers you call from the template:
function formatDateTime(raw) {
  // you can tweak locale/format however you like
  return new Date(raw).toLocaleString("vi-VN", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function formatCurrency(amount) {
  return new Intl.NumberFormat("vi-VN").format(amount);
}

onMounted(() => {
  fetchReservation(route.params.id);
});
</script>
<Toast v-model:show="showToast" :message="toastMessage" :type="toastType" />
