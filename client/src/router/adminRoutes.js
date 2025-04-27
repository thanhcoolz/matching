export default {
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
          component: () => import('../pages/admins/players/PlayersList.vue'),
        },
        {
          path: 'clubs',
          component: () => import('../pages/admins/clubs/ClubsList.vue'),
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
          component: () => import('../pages/admins/clubs/CreateClub.vue')
        },
        {
          path: 'clubs/:id/edit',
          component: () => import('../pages/admins/clubs/EditClub.vue')
        },
        {
          path: 'clubs/:id/managers',
          component: () => import('../pages/admins/clubManagers/ClubManagers.vue')
        },
        {
          path: 'clubs/:id/managers/new',
          component: () => import('../pages/admins/clubManagers/CreateClubManager.vue')
        },
        {
          path: 'clubs/:id/managers/:managerId/edit',
          component: () => import('../pages/admins/clubManagers/EditClubManager.vue')
        }
      ]
    }
  ]
}
