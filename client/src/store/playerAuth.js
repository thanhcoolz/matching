import { defineStore } from "pinia";
import { ref } from "vue";
import apiClient from "../axios";

// Biến lưu trạng thái xác thực player, lấy từ localStorage nếu có
const isAuthenticated = ref(
  localStorage.getItem("playerIsAuthenticated") === "true"
);
// Biến lưu thông tin player hiện tại, lấy từ localStorage nếu có
const currentPlayer = ref(
  JSON.parse(localStorage.getItem("currentPlayer") || "null")
);

// Định nghĩa store quản lý xác thực player sử dụng Pinia
export const usePlayerAuthStore = defineStore("playerAuth", () => {
  // Biến loading để theo dõi trạng thái loading khi xác thực hoặc đăng ký
  const loading = ref(false);

  // Hàm thiết lập trạng thái xác thực và lưu thông tin player vào localStorage
  const setAuth = (playerData) => {
    currentPlayer.value = playerData;
    isAuthenticated.value = true;
    localStorage.setItem("playerIsAuthenticated", "true");
    localStorage.setItem("currentPlayer", JSON.stringify(playerData));
  };

  // Hàm xoá trạng thái xác thực và thông tin player khỏi localStorage
  const clearAuth = () => {
    currentPlayer.value = null;
    isAuthenticated.value = false;
    localStorage.setItem("playerIsAuthenticated", "false");
    localStorage.removeItem("currentPlayer");
  };

  // Hàm đăng nhập player, gọi API và lưu trạng thái xác thực nếu thành công
  async function login(phoneNumber, password) {
    try {
      const response = await apiClient.post("/api/player/player_sessions", {
        phone_number: phoneNumber,
        password,
      });

      if (response.data.status === "ok") {
        setAuth(response.data.player);
        return true;
      }
      return false;
    } catch (err) {
      console.log("login error", err);
      return false;
    }
  }

  // Hàm đăng xuất player, gọi API xoá session và xoá localStorage
  async function logout() {
    try {
      await apiClient.delete("/api/player/player_sessions");
      clearAuth();
      return true;
    } catch (err) {
      console.error("Logout error:", err);
      return false;
    }
  }

  // Hàm kiểm tra trạng thái xác thực hiện tại bằng cách gọi API verify_token
  async function checkAuth() {
    loading.value = true;
    try {
      const response = await apiClient.get("/api/player/verify_token");
      isAuthenticated.value = response.data.authenticated;
      if (response.data.authenticated) {
        currentPlayer.value = response.data.player;
        localStorage.setItem("playerIsAuthenticated", "true");
        localStorage.setItem(
          "currentPlayer",
          JSON.stringify(response.data.player)
        );
      } else {
        clearAuth();
      }
      return isAuthenticated.value;
    } catch (error) {
      clearAuth();
      return false;
    } finally {
      loading.value = false;
    }
  }

  // Hàm đăng ký player mới, gọi API và lưu trạng thái xác thực nếu thành công
  async function register(playerData) {
    try {
      loading.value = true;
      const response = await apiClient.post("/api/player/players", playerData);
      if (response.data.status === "ok") {
        setAuth(response.data.player);
        return { success: true };
      }
      return { success: false, error: response.data.message };
    } catch (err) {
      console.error("Registration error:", err);
      return {
        success: false,
        error: err.response?.data?.message || "Registration failed",
      };
    } finally {
      loading.value = false;
    }
  }

  // Trả về các biến và hàm quản lý xác thực để sử dụng trong các component khác
  return {
    currentPlayer,
    isAuthenticated,
    loading,
    login,
    setAuth,
    logout,
    checkAuth,
    register,
  };
});