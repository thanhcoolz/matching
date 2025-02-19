import { createRouter, createWebHistory } from 'vue-router';

const routes = [
  {
    path: '/admin',
    component: () => import('../components/AdminLayout.vue'),
    children: [
      {
        path: 'signIn',
        component: () => import('../components/AdminSignIn.vue'),
      },
    ],
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
