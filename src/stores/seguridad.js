import { defineStore } from "pinia";
import { api } from "boot/axios";

export const useSeguridadStore = defineStore("seguridad", {
  state: () => ({
    companias: [],
    companiaFavorita: null,
    jwt: null,
    usuario: null,
    jwtDate: null,
  }),
  getters: {
    // doubleCount: (state) => state.counter * 2,
    idMedico() {
      if (!this.usuario) {
        return null;
      }
      return this.usuario.IDMEDICO;
    },
    codUsuario() {
      if (!this.usuario) {
        return null;
      }
      return this.usuario.USUARIO;
    },
    getUsuario: (state) => state.usuario,
  },
  actions: {
    fetchCompanias() {
      return new Promise((resolve) => {
        api.get("/cia/").then((res) => {
          this.companias = res.data.result.recordset;
          resolve(true);
        });
      });
    },
    setCompaniaFavorita(value) {
      this.companiaFavorita = value;
    },
    setUsuario(value) {
      this.usuario = value;
    },
    verificar(compania, usuario) {
      return api.get(`ususu/verificar/${compania}/${usuario}`);
    },
    verificar2(compania, usuario, clave) {
      return api.get(`ususu/verificar2/${compania}/${usuario}/${clave}`);
    },
    ingresar(compania, usuario, clave) {
      const data = {
        COMPANIA: compania,
        USUARIO: usuario,
        CLAVE: clave,
      };
      return api.post("ususu/ingresar", data);
    },
    setJWT(value) {
      if (this.jwtDate) {
        if (this.jwt && value) {
          let msDifference = new Date() - this.jwtDate;
          let minutes = Math.floor(msDifference / 1000 / 60);
          if (minutes < 5) {
            return;
          }
        }
      }
      this.jwt = value;
      this.jwtDate = value ? new Date() : null;
    },
    configurar(data) {
      return api.post("ususu/configurar", data);
    },
  },
  persist: {
    enabled: true,
    strategies: [
      { storage: sessionStorage, paths: ["jwt", "usuario"] },
      { storage: localStorage, paths: ["companiaFavorita"] },
    ],
  },
});
