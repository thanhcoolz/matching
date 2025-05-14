<template>
  <div class="layout" style="font-family: 'Poppins', sans-serif">
    <header class="header">
      <div class="header-content">
        <h1 class="logo">Billiard Matching</h1>
        <nav class="nav">
          <router-link to="/" class="nav-link">Home</router-link>
          <router-link to="/reservations" class="nav-link"
            >Reservations</router-link
          >
          <router-link to="/clubs" class="nav-link"
            >Our Partner Clubs</router-link
          >

          <div v-if="isAuthenticated" class="relative">
            <button
              @click="toggleDropdown"
              class="flex items-center space-x-2 nav-link"
            >
              <template v-if="currentPlayer">
                <span>{{ currentPlayer.username }}</span>
                <img
                  :src="currentPlayer.avatar_url"
                  alt="User"
                  class="w-8 h-8 rounded-full"
                />
              </template>
            </button>

            <div
              v-if="showDropdown"
              class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 z-50"
            >
              <button
                @click="handleSignOut"
                class="w-full text-left px-4 py-2 hover:bg-gray-100"
              >
                Sign Out
              </button>
            </div>
          </div>

          <template v-else>
            <router-link to="/signIn" class="nav-link">Sign In</router-link>
            <router-link to="/signUp" class="nav-link">Sign Up</router-link>
          </template>
        </nav>
      </div>
    </header>

    <main class="main">
      <router-view></router-view>
    </main>

    <footer class="footer">
      <div class="footer-content">
        <p>&copy; 2025 Tan Thanh. All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from "vue";
import { useRouter } from "vue-router";
import { usePlayerAuthStore } from "../store/playerAuth.js";

// Khởi tạo router và lấy các biến, hàm xác thực từ store player
const router = useRouter();
const { isAuthenticated, currentPlayer, logout } = usePlayerAuthStore();
// Biến kiểm soát trạng thái hiển thị dropdown user
const showDropdown = ref(false);

// Hàm bật/tắt dropdown user khi click vào avatar hoặc tên user
const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value;
};

// Hàm xử lý đăng xuất: gọi logout, sau đó reload lại trang
const handleSignOut = async () => {
  await logout();
  window.location.reload();
};

// Hàm xử lý khi click ra ngoài dropdown thì sẽ đóng dropdown lại
const handleClickOutside = (event) => {
  const dropdown = document.querySelector(".relative");
  if (dropdown && !dropdown.contains(event.target)) {
    showDropdown.value = false;
  }
};

// Khi component được mount, thêm event listener để bắt sự kiện click ngoài dropdown
onMounted(() => {
  document.addEventListener("click", handleClickOutside);
});

// Khi component bị unmount, xoá event listener để tránh memory leak
onUnmounted(() => {
  document.removeEventListener("click", handleClickOutside);
});
</script>

<style scoped>
.layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  background-color: #ffffff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  position: fixed;
  width: 100%;
  top: 0;
  z-index: 1000;
}

.header-content {
  width: 100%;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo {
  font-size: 1.5rem;
  font-weight: bold;
  margin: 0;
}

.nav {
  display: flex;
  gap: 2rem;
  align-items: center;
}

.nav-link {
  text-decoration: none;
  color: #333;
  font-weight: 500;
  transition: color 0.3s;
}

.nav-link:hover {
  color: #007bff;
}

.main {
  flex: 1;
  margin-top: 4rem;
  width: 100%;
}

.footer {
  background-color: #f8f9fa;
  padding: 1.5rem 0;
  margin-top: auto;
  width: 100%;
}

.footer-content {
  width: 100%;
  padding: 0 2rem;
  text-align: center;
  color: #666;
}

.relative {
  position: relative;
}

.absolute {
  position: absolute;
}

.w-8 {
  width: 2rem;
}

.h-8 {
  height: 2rem;
}

.w-48 {
  width: 12rem;
}

.rounded-full {
  border-radius: 9999px;
}

.rounded-lg {
  border-radius: 0.5rem;
}

.space-x-2 > * + * {
  margin-left: 0.5rem;
}

.items-center {
  align-items: center;
}

.flex {
  display: flex;
}

.mt-2 {
  margin-top: 0.5rem;
}

.px-4 {
  padding-left: 1rem;
  padding-right: 1rem;
}

.py-2 {
  padding-top: 0.5rem;
  padding-bottom: 0.5rem;
}

.text-left {
  text-align: left;
}

.hover\:bg-gray-100:hover {
  background-color: #f3f4f6;
}

.z-50 {
  z-index: 50;
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 1rem;
    padding: 1rem;
  }

  .nav {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }

  .main {
    margin-top: 7rem;
  }

  .footer-content {
    padding: 0 1rem;
  }

  .absolute {
    position: static;
    margin-top: 0.5rem;
  }

  .w-48 {
    width: 100%;
  }
}
</style>
