import { createRouter, createWebHistory } from 'vue-router';
import { useAuth } from '../store/auth';

const routes = [
  {
    path: '/admin',
    component: () => import('../components/AdminLayout.vue'),
    children: [
      {
        path: '',
        redirect: '/admin/dashboard'
      },
      {
        path: 'signIn',
        component: () => import('../components/AdminSignIn.vue'),
        meta: { public: true }
      },
      {
        path: 'dashboard',
        component: () => import('../components/AdminDashboard.vue'),
      },
      {
        path: 'players',
        component: () => import('../components/AdminDashboard.vue'), // Placeholder for future implementation
      },
      {
        path: 'clubs',
        component: () => import('../components/AdminDashboard.vue'), // Placeholder for future implementation
      },
      {
        path: 'parties',
        component: () => import('../components/AdminDashboard.vue'), // Placeholder for future implementation
      },
      {
        path: 'managers',
        component: () => import('../components/AdminDashboard.vue'), // Placeholder for future implementation
      }
    ],
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const { checkAuth } = useAuth();
  const isAuthenticated = checkAuth();
  const isPublicRoute = to.matched.some(record => record.meta.public);

  if (!isPublicRoute && !isAuthenticated && to.path !== '/admin/signIn') {
    next('/admin/signIn');
  } else {
    next();
  }
});

export default router;
