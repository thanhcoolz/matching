import { createRouter, createWebHistory } from 'vue-router';
import { useAuth } from '../store/auth';

const routes = [
  {
    path: '/admin',
    children: [
      {
        path: 'signIn',
        component: () => import('../layouts/AdminGuestLayout.vue'),
        children: [
          {
            path: '',
            component: () => import('../pages/admins/SignIn.vue'),
            meta: { public: true }
          }
        ]
      },
      {
        path: '',
        component: () => import('../layouts/AdminAuthLayout.vue'),
        children: [
          {
            path: '',
            redirect: '/admin/dashboard'
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
          },
          {
            path: 'clubs/new',
            component: () => import('../pages/admins/CreateClub.vue')
          }
        ]
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
