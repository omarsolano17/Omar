<template>
  <q-layout view="hHh Lpr fFf">
    <q-header elevated :style="bgLinear">
      <q-toolbar>
        <q-btn
          flat
          dense
          round
          :icon="
            !leftDrawerOpen
              ? 'double_arrow'
              : lockMiniState
              ? 'menu_open'
              : 'menu'
          "
          aria-label="Menu"
          @click="toggleLeftDrawer"
        />
        <q-toolbar-title> {{$t('nombre_sistema')}} </q-toolbar-title>
        <!-- <div>(Quasar v{{ $q.version }})&nbsp;</div> -->
        <!-- <CambioDatosUsuario :usuario="usuario" /> -->
        <q-separator spaced inset vertical dark />
        <div class="q-pr-md">
          {{ usuario.NOMBRE || "" }} - {{ usuario.DB_NAME || "" }}
        </div>
        <q-btn color="primary" icon="logout" round @click="onLogout">
          <q-tooltip
            content-class="bg-primary"
            content-style="font-size: 12px"
            :offset="[10, 10]"
            >Cerrar Sesión</q-tooltip
          >
        </q-btn>
      </q-toolbar>
    </q-header>
    <q-drawer
      v-model="leftDrawerOpen"
      show-if-above
      bordered
      :mini="miniState"
      content-class="bg-grey-1"
      @mouseover="onMouse('over')"
      @mouseout="onMouse('out')"
    >
      <q-list>
        <EssentialLink
          v-for="link in appStore.menuConfiguracion"
          :key="link.title"
          v-bind="link"
        />
        <EssentialLink
          title="Cerrar Sesión"
          caption="Salir del sistema"
          icon="logout"
          @click="onLogout"
          :separator_prev="true"
        />
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
//#region Imports
import { ref, watch, onMounted, onUnmounted, computed } from "vue";
import EssentialLink from "components/EssentialLink.vue";
import { mapActions, mapState } from "pinia";
import { useSeguridadStore } from "stores/seguridad";
import { useAppStore } from "stores/app";
import { useQuasar } from "quasar";
// import CambioDatosUsuario from "components/seguridad/CambioDatosUsuario.vue";
// import { useDataBase } from "src/composables/useDataBase";
import { useI18n } from "vue-i18n";
//#endregion

//#region Data
// const db = useDataBase();
const authStore = useSeguridadStore();
const linksList = [];
const leftDrawerOpen = ref(false);
const lockMiniState = ref(false);
const miniState = ref(false);
const menu = ref([]);
const appStore = useAppStore();
const guardarPreferencias = ref(false);
const $q = useQuasar();
// const { locale } = useI18n({ useScope: "global" });
//#endregion

//#region Hooks
onMounted(() => {
  menu.value = appStore.getMenu;
  guardarPreferencias.value = false;
  leftDrawerOpen.value = appStore.getLeftDrawerOpen;
  lockMiniState.value = appStore.getLockMiniState;
  miniState.value = appStore.getMiniState;

  // setTimeout(() => {
  //   appStore.setColor("primary", "#F77E4F");
  //   appStore.setColor("secondary", "#0f60b5");
  // }, 200);

  setTimeout(() => {
    const menu = appStore.menuConfiguracion;
    if (
      menu.length <= 0 ||
      (menu.agrupados?.length <= 0 &&
        menu.submenus?.length <= 0 &&
        menu.individuales?.length <= 0)
    ) {
      const essentialLinks = [];
      $q.loading.show({
        message: "Cargando menú...",
      });
      appStore
        .json({ MODELO: "MENUQ_COL", METODO: "CONFIGURACION" })
        .then((res) => {
          if (res.data.res === "ok") {
            res.data.result.recordsets[3].forEach((el) => {
              essentialLinks.push({
                title: el.LABEL,
                caption: el.SUBLABEL,
                to: el.RUTA,
                icon: el.ICONO || "code",
              });
            });

            appStore.setMenu({
              modulo: "configuracion",
              menu: essentialLinks,
            });
          }
        })
        .catch((err) => {
          console.error(err);
        })
        .finally(() => {
          $q.loading.hide();
        });
    }
  }, 200);

  let items = ["COUNTRY"];
  // db.inicializarDB(items);

  $q.loading.hide();

  let dpr = appStore.getDpr;
  // console.log("onMounted",locale);
  if (dpr?.IXCOUNTRY) {
    switch (dpr.IXCOUNTRY) {
      case "PERU":
        break;
      case "NO":
      case "COLOMBIA":
        break;
      default:
        break;
    }
  }
});

onUnmounted(() => {
  if (guardarPreferencias.value) {
    setTimeout(() => {
      appStore.setLeftDrawerOpen(leftDrawerOpen.value);
      appStore.setLockMiniState(lockMiniState.value);
      appStore.setMiniState(miniState.value);
    }, 500);
  }
});
//#endregion

//#region Computed
const usuario = computed(() => {
  return authStore.getUsuario;
});
const bgLinear = computed(() => {
  return appStore.bgLinear;
});
//#endregion

//#region METHODS
const toggleLeftDrawer = () => {
  guardarPreferencias.value = true;
  if (!leftDrawerOpen.value) {
    miniState.value = false;
    leftDrawerOpen.value = true;
    lockMiniState.value = false;
  } else {
    if (lockMiniState.value) {
      miniState.value = true;
      leftDrawerOpen.value = false;
    } else {
      lockMiniState.value = true;
      miniState.value = true;
    }
  }
};
const onMouse = (on) => {
  if (!lockMiniState.value) return;
  if (on === "over") {
    miniState.value = false;
  } else {
    miniState.value = true;
  }
};
const onLogout = () => {
  $q.loading.show({
    message: "Cerrando sesión...",
  });
  authStore.setJWT(null);
  
  $q.loading.hide();
};
//#endregion
</script>
