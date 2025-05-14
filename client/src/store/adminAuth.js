import { ref } from "vue";
import apiClient from "../axios";

//Người dùng đăng nhập → nhận JWT qua cookie.
//Gọi API cần xác thực → JWT tự động gửi kèm cookie.
//Server xác thực JWT → trả về dữ liệu nếu hợp lệ.
//Khi chuyển route hoặc cần kiểm tra đăng nhập → gọi API verify_token.
//Đăng xuất → xóa JWT khỏi cookie.


// Biến lưu trạng thái xác thực admin, lấy từ localStorage nếu có
const isAuthenticated = ref(
  localStorage.getItem("adminIsAuthenticated") === "true"
);
// Biến lưu thông tin admin hiện tại, lấy từ localStorage nếu có
const currentAdmin = ref(
  JSON.parse(localStorage.getItem("currentAdmin") || "null")
);

// Store quản lý xác thực admin
export const useAuthStore = () => {
  // Hàm thiết lập trạng thái xác thực và lưu thông tin admin vào localStorage
  const setAuth = (adminData) => {
    isAuthenticated.value = true;
    currentAdmin.value = adminData;

    localStorage.setItem("adminIsAuthenticated", "true");
    localStorage.setItem("currentAdmin", JSON.stringify(adminData));
  };

  // Hàm đăng xuất admin, gọi API xoá session, xoá localStorage và chuyển hướng về trang đăng nhập
  const logout = async () => {
    try {
      await apiClient.delete("/api/admin/admin_sessions");
    } catch (error) {
      console.error("Logout error:", error);
    } finally {
      isAuthenticated.value = false;
      currentAdmin.value = null;

      localStorage.setItem("adminIsAuthenticated", "false");
      localStorage.removeItem("currentAdmin");

      window.location.href = "/admin/signIn";
    }
  };

  // Hàm kiểm tra trạng thái xác thực hiện tại bằng cách gọi API verify_token
  const checkAuth = async () => {
    if (!isAuthenticated.value) {
      return true;
    }
    try {
      const response = await apiClient.get("/api/admin/verify_token");
      isAuthenticated.value = response.status === 200;
      return isAuthenticated.value;
    } catch (error) {
      console.error("Auth check failed:", error);
      isAuthenticated.value = false;
      return false;
    }
  };

  // Hàm đăng nhập admin, gọi API và lưu trạng thái xác thực nếu thành công
  const login = async (email, password) => {
    try {
      const response = await apiClient.post("/api/admin/admin_sessions", {
        email,
        password,
      });

      if (response.data.status === "ok") {
        setAuth(response.data.admin);
        return true;
      }
      return false;
    } catch (error) {
      console.error("Login error:", error);
      return false;
    }
  };

  // Khởi tạo lại trạng thái xác thực từ localStorage khi store được tạo
  const storedAuth = localStorage.getItem("adminIsAuthenticated");
  if (storedAuth !== null) {
    isAuthenticated.value = storedAuth === "true";
    currentAdmin.value = JSON.parse(
      localStorage.getItem("currentAdmin") || "null"
    );
  }

  // Trả về các biến và hàm quản lý xác thực để sử dụng trong các component khác
  return {
    isAuthenticated,
    currentAdmin,
    login,
    logout,
    setAuth,
    checkAuth,
  };
};

// Đảm bảo tương thích với các cách import cũ
export const useAuth = useAuthStore;