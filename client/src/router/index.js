import { createRouter, createWebHistory } from 'vue-router';
import { useAuth } from '../store/auth';
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

router.beforeEach((to, from, next) => {
  const { checkAuth } = useAuth();
  const { checkAuth: checkClubAuth } = useClubAuth();
  const isAdminAuthenticated = checkAuth();
  const isClubAuthenticated = checkClubAuth();
  const isPublicRoute = to.matched.some(record => record.meta.public);

  // Check if the route is in the admin section
  const isAdminRoute = to.path.startsWith('/admin');
  // Check if the route is in the club section
  const isClubRoute = to.path.startsWith('/club');

  if (!isPublicRoute) {
    if (isAdminRoute && !isAdminAuthenticated) {
      next('/admin/signIn');
    } else if (isClubRoute && !isClubAuthenticated) {
      next('/club/signIn');
    } else {
      next();
    }
  } else {
    next();
  }
});

export default router;
