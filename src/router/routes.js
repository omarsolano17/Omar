const routes = [
  {
    path: "/",
    component: () => import("layouts/MainLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("pages/IndexPage.vue"),
        name: "home",
        meta: { requiresAuth: true },
      },
    ],
  },

  {
    path: "/autenticarse",
    component: () => import("src/layouts/SeguridadLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("pages/Seguridad/IngresarPage.vue"),
        name: "ingresar",
        // meta: { requiresAuth: true },
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
        meta: { requiresAuth: true },
      },
      {
        path: "grupos",
        component: () => import("pages/conf/GruposPages.vue"),
        name: "conf.grupos",
        meta: { requiresAuth: true },
      },
      {
        path: "usuarios",
        component: () => import("pages/conf/UsuariosPages.vue"),
        name: "conf.usuarios",
        meta: { requiresAuth: true },
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
        meta: { requiresAuth: true },
      },
      {
        path: "notificaciones",
        component: () => import("pages/util/NotificacionesPage.vue"),
        name: "util.notificaciones",
        meta: { requiresAuth: true },
      },
      {
        path: "memoria",
        component: () => import("pages/util/MemoriaPage.vue"),
        name: "util.memoria",
        meta: { requiresAuth: true },
      },
      {
        path: "turnero",
        component: () => import("pages/util/TurneroPage.vue"),
        name: "util.turnero",
        meta: { requiresAuth: true },
      },
    ],
  },
  
  {
    path: "/sms",
    component: () => import("src/layouts/MensajesLayout.vue"),
    children: [
      {
        path: "",
        component: () => import("pages/Mensajes/IndexPage.vue"),
        name: "sms",
        meta: { requiresAuth: true },
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
