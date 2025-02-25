export default {
  path: '/',
  component: () => import('../layouts/PublicLayout.vue'),
  children: [
    {
      path: '/',
      meta: { public: true },
      component: () => import('../pages/publics/Home.vue'),
    }
  ]
};
