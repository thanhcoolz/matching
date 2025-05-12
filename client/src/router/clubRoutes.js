export default {
  path: "/club",
  children: [
    {
      path: "signIn",
      component: () => import("../layouts/ClubGuestLayout.vue"),
      children: [
        {
          path: "",
          component: () => import("../pages/clubs/SignIn.vue"),
          meta: { public: true },
        },
      ],
    },
    {
      path: "",
      component: () => import("../layouts/ClubAuthLayout.vue"),
      children: [
        {
          path: "",
          redirect: "/club/dashboard",
        },
        {
          path: "dashboard",
          component: () => import("../pages/clubs/DashBoard.vue"),
        },
        {
          path: "settings",
          component: () => import("../pages/clubs/Settings.vue"),
        },
        {
          path: "managers",
          children: [
            {
              path: "",
              component: () => import("../pages/clubs/Managers.vue"),
            },
            {
              path: "create",
              component: () => import("../pages/clubs/managers/Create.vue"),
            },
            {
              path: ":id/edit",
              component: () => import("../pages/clubs/managers/Edit.vue"),
            },
          ],
        },
        {
          path: "reservations",
          children: [
            {
              path: "",
              component: () => import("../pages/clubs/Reservations.vue"),
            },
          ],
        },
      ],
    },
  ],
};
