export default {
  path: '/',
  component: () => import('../layouts/PublicLayout.vue'),
  children: [
    {
      path: '/',
      meta: { public: true },
      component: () => import('../pages/publics/Home.vue'),
    },
    {
      path: '/signUp',
      meta: { public: true },
      component: () => import('../pages/publics/SignUp.vue'),
    },
    {
      path: '/signIn',
      meta: { public: true },
      component: () => import('../pages/publics/SignIn.vue'),
    },
    {
      path: '/clubs',
      meta: { public: true },
      component: () => import('../pages/publics/Clubs.vue'),
    }
  ]
};
