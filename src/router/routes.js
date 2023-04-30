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
  {
    path: "/util",
    component: () => import("src/layouts/UtilidadesLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("pages/util/IndexPage.vue"),
        name: "util",
      },
      {
        path: "notificaciones",
        component: () => import("pages/util/NotificacionesPage.vue"),
        name: "util.notificaciones",
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
