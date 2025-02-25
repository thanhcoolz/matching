export default {
  path: '/club',
  children: [
    {
      path: 'signIn',
      component: () => import('../layouts/ClubGuestLayout.vue'),
      children: [
        {
          path: '',
          component: () => import('../pages/clubs/SignIn.vue'),
          meta: { public: true }
        }
      ]
    },
    {
      path: '',
      component: () => import('../layouts/ClubAuthLayout.vue'),
      children: [
        {
          path: '',
          redirect: '/club/dashboard'
        },
        {
          path: 'dashboard',
          component: () => import('../pages/clubs/DashBoard.vue'),
        }
      ]
    }
  ]
}
