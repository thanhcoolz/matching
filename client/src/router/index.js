import { createRouter, createWebHistory } from "vue-router";
import { useAuthStore } from "../store/adminAuth";
import { useClubAuth } from "../store/clubAuth";
import { usePlayerAuthStore } from "../store/playerAuth";
import adminRoutes from "./adminRoutes";
import clubRoutes from "./clubRoutes";
import publicRoutes from "./publicRoutes";

const routes = [publicRoutes, adminRoutes, clubRoutes];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach(async (to, from, next) => {
  const isPublicRoute = to.matched.some((record) => record.meta.public);

  if (!isPublicRoute) {
    const isAdminRoute = to.path.startsWith("/admin");
    const isClubRoute = to.path.startsWith("/club");
    const isPlayerRoute = to.path.startsWith("/player");

    if (isAdminRoute) {
      const authStore = useAuthStore();
      const isAdminAuthenticated = await authStore.checkAuth();

      if (to.path === "/admin/signIn" && isAdminAuthenticated) {
        return next("/admin/");
      }

      if (!isAdminAuthenticated) {
        return next("/admin/signIn");
      }
    } else if (isClubRoute) {
      const { checkAuth: checkClubAuth } = useClubAuth();
      const isClubAuthenticated = await checkClubAuth();

      console.log(isClubAuthenticated);

      if (to.path === "/club/signIn" && isClubAuthenticated) {
        return next("/club/");
      }

      if (!isClubAuthenticated) {
        return next("/club/signIn");
      }
    } else if (isPlayerRoute) {
      const playerAuthStore = usePlayerAuthStore();
      const isPlayerAuthenticated = await playerAuthStore.checkAuth();

      if (to.path === "/signIn" && isPlayerAuthenticated) {
        return next("/player/");
      }

      if (!isPlayerAuthenticated) {
        return next("/signIn");
      }
    }

    return next();
  } else {
    return next();
  }
});

export default router;
