const routes = [
  {
    path: "/",
    component: () => import("layouts/MainLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("pages/IndexPage.vue"),
        meta: { requiresAuth: true },
        name: "home",
      },
      {
        path: "chat",
        component: () => import("pages/app/ChatPage.vue"),
        meta: { requiresAuth: true },
        name: "chat",
      },
    ],
  },

  {
    path: "/autenticarse",
    component: () => import("src/layouts/SeguridadLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("pages/seguridad/IngresarPage.vue"),
        name: "ingresar",
      },
    ],
  },
  {
    path: "/conf",
    component: () => import("src/layouts/ConfiguracionLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("pages/conf/IndexPage.vue"),
        name: "conf",
      },
      {
        path: "grupos",
        component: () => import("pages/conf/GruposPages.vue"),
        name: "conf.grupos",
      },
    ],
  },
  // Always leave this as last one,
  // but you can also remove it
  {
    path: "/:catchAll(.*)*",
    component: () => import("pages/ErrorNotFound.vue"),
  },
];

export default routes;
