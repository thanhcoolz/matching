import { createRouter, createWebHistory } from "vue-router";

// Import các store quản lý xác thực cho admin, club, player
import { useAuthStore } from "../store/adminAuth";
import { useClubAuth } from "../store/clubAuth";
import { usePlayerAuthStore } from "../store/playerAuth";

// Import các nhóm route cho từng loại người dùng
import adminRoutes from "./adminRoutes";
import clubRoutes from "./clubRoutes";
import publicRoutes from "./publicRoutes";

// Gộp tất cả các route lại thành một mảng routes
const routes = [publicRoutes, adminRoutes, clubRoutes];

// Khởi tạo router với chế độ history và danh sách routes
const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Thiết lập middleware kiểm tra xác thực trước khi chuyển route
router.beforeEach(async (to, from, next) => {
  // Kiểm tra xem route hiện tại có phải là public không (không cần đăng nhập)
  const isPublicRoute = to.matched.some((record) => record.meta.public);

  if (!isPublicRoute) {
    // Xác định loại route (admin, club, player) dựa vào path
    const isAdminRoute = to.path.startsWith("/admin");
    const isClubRoute = to.path.startsWith("/club");
    const isPlayerRoute = to.path.startsWith("/player");

    if (isAdminRoute) {
      // Kiểm tra xác thực admin
      const authStore = useAuthStore();
      const isAdminAuthenticated = await authStore.checkAuth();

      // Nếu đã đăng nhập và vào trang đăng nhập thì chuyển hướng về trang chính admin
      if (to.path === "/admin/signIn" && isAdminAuthenticated) {
        return next("/admin/");
      }

      // Nếu chưa xác thực thì chuyển hướng về trang đăng nhập admin
      if (!isAdminAuthenticated) {
        return next("/admin/signIn");
      }
    } else if (isClubRoute) {
      // Kiểm tra xác thực club manager
      const { checkAuth: checkClubAuth } = useClubAuth();
      const isClubAuthenticated = await checkClubAuth();

      console.log(isClubAuthenticated);

      // Nếu đã đăng nhập và vào trang đăng nhập thì chuyển hướng về trang chính club
      if (to.path === "/club/signIn" && isClubAuthenticated) {
        return next("/club/");
      }

      // Nếu chưa xác thực thì chuyển hướng về trang đăng nhập club
      if (!isClubAuthenticated) {
        return next("/club/signIn");
      }
    } else if (isPlayerRoute) {
      // Kiểm tra xác thực player
      const playerAuthStore = usePlayerAuthStore();
      const isPlayerAuthenticated = await playerAuthStore.checkAuth();

      // Nếu đã đăng nhập và vào trang đăng nhập thì chuyển hướng về trang chính player
      if (to.path === "/signIn" && isPlayerAuthenticated) {
        return next("/player/");
      }

      // Nếu chưa xác thực thì chuyển hướng về trang đăng nhập player
      if (!isPlayerAuthenticated) {
        return next("/signIn");
      }
    }

    // Nếu đã xác thực hợp lệ thì cho phép chuyển route
    return next();
  } else {
    // Nếu là route public thì cho phép chuyển route
    return next();
  }
});

export default router;