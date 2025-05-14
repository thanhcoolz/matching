<template>
  <div class="bg-white p-10 rounded-xl shadow-lg w-full max-w-md">
    <h1 class="text-2xl font-semibold text-gray-800 text-center mb-8">Admin Panel</h1>
    <form @submit.prevent="handleSignIn" class="flex flex-col gap-6">
      <div class="flex flex-col gap-2">
        <label for="email" class="text-sm font-medium text-gray-700">Email</label>
        <div class="relative">
          <span class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-500">📧</span>
          <input id="email" type="email" v-model="email" placeholder="Enter your email" :disabled="loading" required
            autocomplete="email"
            class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors disabled:bg-gray-100" />
        </div>
      </div>

      <div class="flex flex-col gap-2">
        <label for="password" class="text-sm font-medium text-gray-700">Password</label>
        <div class="relative">
          <span class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-500">🔒</span>
          <input id="password" type="password" v-model="password" placeholder="Enter your password" :disabled="loading"
            required autocomplete="current-password"
            class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors disabled:bg-gray-100" />
        </div>
      </div>

      <button type="submit" :disabled="loading"
        class="w-full bg-blue-600 text-white py-3 px-6 rounded-lg font-medium hover:bg-blue-700 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all disabled:bg-blue-400 disabled:cursor-not-allowed">
        <span v-if="loading" class="animate-spin">⌛</span>
        <span v-else>Sign In</span>
      </button>
    </form>

    <div v-if="errorMessage" class="mt-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-center gap-3">
      <span class="text-red-500">⚠️</span>
      <p class="text-sm text-red-600">{{ errorMessage }}</p>
    </div>
  </div>
</template>

<script setup>

import { ref } from 'vue';
import { useAuthStore } from '../../store/adminAuth.js';

// Khởi tạo store xác thực admin
const authStore = useAuthStore();

// Khai báo các biến reactive để lưu trữ thông tin đăng nhập và trạng thái
const email = ref(''); 
const password = ref(''); 
const errorMessage = ref('');
const loading = ref(false);

// Hàm xử lý sự kiện khi người dùng submit form đăng nhập
const handleSignIn = async () => {
  loading.value = true;
  errorMessage.value = '';

  try {
    // Gọi hàm login từ authStore để xác thực với email và password
    const success = await authStore.login(email.value, password.value);

    if (success) {
      // Sử dụng window.location để đảm bảo tải lại trang hoàn toàn
      window.location.href = '/admin/dashboard';
    } else {
      errorMessage.value = 'Authentication failed. Please try again.';
    }
  } catch (error) {
    // Xử lý lỗi từ API, hiển thị thông báo lỗi từ server hoặc thông báo mặc định
    errorMessage.value = error.response?.data?.message || 'Invalid credentials. Please try again.';
  } finally {
    // Tắt trạng thái loading sau khi hoàn thành, dù thành công hay thất bại
    loading.value = false;
  }
};
</script>
