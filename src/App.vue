<template>
  <router-view />
  <q-dialog v-model="haveErrors">
    <q-card class="">
      <q-bar dark class="bg-negative text-white">
        <q-icon name="warning" />
        <div class="col text-center text-weight-bold">Aviso Importante</div>
        <q-btn dense flat round icon="close" size="8.5px" color="white" />
      </q-bar>

      <q-card-section class="q-pa-xs">
        <q-list bordered>
          <template v-for="error in errores" :key="error">
            <q-item>
              <q-item-section class="text-bold text-negative">{{
                error.ERROR
              }}</q-item-section>
            </q-item>
            <q-separator />
          </template>
        </q-list>
      </q-card-section>

      <q-card-actions align="right">
        <q-btn
          glossy
          label="Entiendo"
          icon="check"
          color="negative"
          v-close-popup
        />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
import { mapState } from "pinia";
import { defineComponent } from "vue";
import { api } from "./boot/axios";
import { useSeguridadStore } from "./stores/seguridad";
import { useAppStore } from "./stores/app";
import io from "socket.io-client";
// import { useQuasar } from "quasar";

export default defineComponent({
  name: "App",
  data() {
    return {
      haveErrors: false,
      socketChat: null,
      // $q: useQuasar(),
    };
  },
  computed: {
    ...mapState(useSeguridadStore, ["jwt"]),
    ...mapState(useAppStore, ["errores"]),
  },
  methods: {
    onRefresh() {
      // this.$q.notify({
      //   position: "top",
      //   timeout: 0,
      //   message:
      //     "Actualización de plataforma web disponible. Por favor recargue la página para obtener la última versión.",
      //   color: "negative",
      //   multiLine: true,
      //   avatar: "https://cdn.quasar.dev/img/boy-avatar.png",
      //   // class: "bg-negative text-white",
      //   actions: [
      //     {
      //       label: "Recargar",
      //       color: "yellow",
      //       handler: () => {
      //         // window.location.reload();
      //       },
      //     },
      //     {
      //       label: "Postergar",
      //       color: "yellow",
      //       handler: () => {
      //         /* ... */
      //       },
      //     },
      //   ],
      // });
    },
  },
  watch: {
    jwt(val) {
      if (val) {
        api.defaults.headers.common["Authorization"] = "Bearer " + val;
      } else {
        const appStore = useAppStore();

        //#region REESTABLECER LOS ESTADOS
        if (appStore.menu.length > 0) {
          appStore.setMenu({ modulo: "" });
        }
        //#endregion

        api.defaults.headers.common["Authorization"] = undefined;
        this.$router.push({ name: "ingresar" });
      }
    },
    errores(newVal) {
      if (newVal.length > 0) {
        this.haveErrors = true;
      } else {
        this.haveErrors = false;
      }
    },
  },
  mounted() {},
});
</script>
