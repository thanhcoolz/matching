import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../store/auth';
import { useClubAuth } from '../store/clubAuth';
import adminRoutes from './adminRoutes';
import clubRoutes from './clubRoutes';
import publicRoutes from './publicRoutes';

const routes = [
  publicRoutes,
  adminRoutes,
  clubRoutes,
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach(async (to, from, next) => {
  const isPublicRoute = to.matched.some(record => record.meta.public);

  if (!isPublicRoute) {
     // Use Pinia store for admin auth
  const authStore = useAuthStore();
  const { checkAuth: checkClubAuth } = useClubAuth();

  // Make auth checks asynchronous
  const isAdminAuthenticated = await authStore.checkAuth();
  const isClubAuthenticated = checkClubAuth();

  // Check if the route is in the admin section
  const isAdminRoute = to.path.startsWith('/admin');
  // Check if the route is in the club section
  const isClubRoute = to.path.startsWith('/club');

  // Redirect authenticated users away from sign-in pages
  if (to.path === '/admin/signIn' && isAdminAuthenticated) {
    return next('/admin/');
  }

  if (to.path === '/club/signIn' && isClubAuthenticated) {
    return next('/club/');
  }

    if (isAdminRoute && !isAdminAuthenticated) {
      // Redirect to sign in page
      return next('/admin/signIn');
    } else if (isClubRoute && !isClubAuthenticated) {
      return next('/club/signIn');
    } else {
      return next();
    }
  } else {
    return next();
  }
});

export default router;
