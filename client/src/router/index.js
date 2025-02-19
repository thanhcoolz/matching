import { createRouter, createWebHistory } from 'vue-router';
import { useAuth } from '../store/auth';

const routes = [
  {
    path: '/admin',
    component: () => import('../layouts/AdminLayout.vue'),
    children: [
      {
        path: '',
        redirect: '/admin/dashboard'
      },
      {
        path: 'signIn',
        component: () => import('../pages/admins/SignIn.vue'),
        meta: { public: true }
      },
      {
        path: 'dashboard',
        component: () => import('../pages/admins/DashBoard.vue'),
      },
      {
        path: 'players',
        component: () => import('../pages/admins/DashBoard.vue'), // Placeholder for future implementation
      },
      {
        path: 'clubs',
        component: () => import('../pages/admins/DashBoard.vue'), // Placeholder for future implementation
      },
      {
        path: 'parties',
        component: () => import('../pages/admins/DashBoard.vue'), // Placeholder for future implementation
      },
      {
        path: 'managers',
        component: () => import('../pages/admins/DashBoard.vue'), // Placeholder for future implementation
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
