export default {
  path: "/",
  component: () => import("../layouts/PublicLayout.vue"),
  children: [
    {
      path: "/",
      meta: { public: true },
      component: () => import("../pages/publics/Home.vue"),
    },
    {
      path: "/signUp",
      meta: { public: true },
      component: () => import("../pages/publics/SignUp.vue"),
    },
    {
      path: "/signIn",
      meta: { public: true },
      component: () => import("../pages/publics/SignIn.vue"),
    },
    {
      path: "/clubs",
      meta: { public: true },
      component: () => import("../pages/publics/Clubs.vue"),
    },
    {
      path: "/clubs/:id",
      meta: { public: true },
      component: () => import("../pages/publics/ClubDetail.vue"),
    },
    {
      path: "/clubs/register",
      meta: { public: true },
      component: () => import("../pages/publics/ClubRegister.vue"),
    },
    {
      path: "/reservations",
      meta: { public: false },
      component: () => import("../pages/publics/Reservations.vue"),
    },
    {
      path: "/payment/:id",
      meta: { public: false },
      component: () => import("../pages/publics/payment.vue"),
    },
    {
      path: "/matches",
      meta: { public: false },
      component: () => import("../pages/publics/PublicMatches.vue"),
    },
  ],
};
