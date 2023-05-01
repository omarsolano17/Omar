import { defineStore } from "pinia";
import { api } from "boot/axios";

export const useUtilidadesStore = defineStore("utilidades", {
  state: () => ({
    notificacion: {},
  }),
  getters: {
    getNotificacion() {
      if (!this.notificacion) {
        return null;
      }
      return this.notificacion;
    },
  },
  actions: {
    setWhatsapp(value) {
      this.notificacion.WHATSAPP = value;
    },
    setSms(value) {
      this.notificacion.SMS = value;
    },
    setCorreo(value) {
      this.notificacion.CORREO = value;
    },
    setEnviarDesde(value) {
      this.notificacion.ENVIARDESDE = value;
    },
  },
  persist: {
    enabled: true,
    strategies: [{ storage: localStorage }],
    // strategies: [{ storage: localStorage, paths: ["notificacion"] }],
  },
  // persist: {
  //   enabled: true,
  //   strategies: [
  //     { storage: sessionStorage, paths: ["jwt", "usuario"] },
  //     { storage: localStorage, paths: ["companiaFavorita"] },
  //   ],
  // },

  // strategies: [
  //   { storage: sessionStorage, paths: ["jwt", "usuario"] },
  //   { storage: localStorage, paths: ["companiaFavorita"] },
  // ],

  // strategies: [{ storage: sessionStorage }],
});
