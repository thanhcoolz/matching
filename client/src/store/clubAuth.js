import { ref } from "vue";
import apiClient from "../axios";

// Biến lưu trạng thái xác thực club, lấy từ localStorage nếu có
const isAuthenticated = ref(
  localStorage.getItem("clubIsAuthenticated") === "true"
);
// Biến lưu thông tin club hiện tại, lấy từ localStorage nếu có
const currentClub = ref(
  JSON.parse(localStorage.getItem("currentClub") || "null")
);
// Biến lưu thông tin club manager hiện tại, lấy từ localStorage nếu có
const currentClubManager = ref(
  JSON.parse(localStorage.getItem("currentClubManager") || "null")
);

// Store quản lý xác thực club và club manager
export const useClubAuth = () => {
  // Biến loading để theo dõi trạng thái loading khi xác thực
  const loading = ref(false);

  // Hàm thiết lập trạng thái xác thực và lưu thông tin club, club manager vào localStorage
  const setAuth = (clubData, clubManagerData) => {
    isAuthenticated.value = true;
    currentClub.value = clubData;
    currentClubManager.value = clubManagerData;
    localStorage.setItem("clubIsAuthenticated", "true");
    localStorage.setItem("currentClub", JSON.stringify(clubData));
    localStorage.setItem("currentClubManager", JSON.stringify(clubManagerData));
  };

  // Hàm xoá trạng thái xác thực và thông tin club, club manager khỏi localStorage
  const clearAuth = () => {
    isAuthenticated.value = false;
    currentClub.value = null;
    currentClubManager.value = null;
    localStorage.setItem("clubIsAuthenticated", "false");
    localStorage.removeItem("currentClub");
    localStorage.removeItem("currentClubManager");
  };

  // Hàm kiểm tra trạng thái xác thực hiện tại bằng cách gọi API verify_token
  const checkAuth = async () => {
    try {
      if (!isAuthenticated.value) {
        return false;
      }
      const response = await apiClient.get("/api/club/verify_token");
      if (response.data.authenticated) {
        setAuth(response.data.current_club, response.data.club_manager);
        return true;
      }
      clearAuth();
      return false;
    } catch (error) {
      clearAuth();
      return false;
    }
  };

  // Trả về các biến và hàm quản lý xác thực để sử dụng trong các component khác
  return {
    isAuthenticated,
    currentClub,
    currentClubManager,
    loading,
    setAuth,
    clearAuth,
    checkAuth,
  };
};