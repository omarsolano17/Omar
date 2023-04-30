import { defineStore } from "pinia";
import { api } from "boot/axios";
import { getCssVar, setCssVar } from "quasar";

export const useAppStore = defineStore("app", {
  state: () => ({
    tipodocs: [],
    dpr: null,
    logo: null,
    logoSecundario: null,
    leftDrawerOpen: false,
    lockMiniState: false,
    miniState: false,
    menu: {
      agrupados: [],
      submenus: [],
      individuales: [],
    },
    menuConfiguracion: {
      agrupados: [],
      submenus: [],
      individuales: [],
    },
    menuUtilidades: {
      agrupados: [],
      submenus: [],
      individuales: [],
    },
    prefijosTera: "",
    errores: [],
    bgLinear: null,
    filtroFirma: "",
  }),
  getters: {
    getErrores: (state) => state.errores,
    getLogo: (state) => state.logo,
    getLogoSecundario: (state) => state.logoSecundario,
    getDpr: (state) => state.dpr,
    getMenu: (state) => state.menu,
    getMenuConfiguracion: (state) => state.menuConfiguracion,
    getMenuUtilidades: (state) => state.menuUtilidades,
    getLeftDrawerOpen: (state) => state.leftDrawerOpen,
    getLockMiniState: (state) => state.lockMiniState,
    getMiniState: (state) => state.miniState,
    getBgLinear: (state) => state.bgLinear,
    getFiltroFirma: (state) => state.filtroFirma,
  },
  actions: {
    json(data) {
      if (process.env.DEV) {
        console.log(JSON.stringify(data));
      }
      return api.post("json", data);
    },
    read(data) {
      return api.post("read", data);
    },
    upload(
      archivo,
      proceso = "",
      cns1 = null,
      fechadocumento = null,
      cns2 = null
    ) {
      const formData = new FormData();
      formData.append("file", archivo);
      formData.append("PROCESO", proceso);
      if (cns1) formData.append("CONSECUTIVO", cns1);
      if (cns2) formData.append("CONSECUTIVO2", cns2);
      if (fechadocumento) formData.append("FECHADOCUMENTO", fechadocumento);
      return api.post("upload", formData);
    },
    sendMail(data) {
      return api.post("mailer", data);
    },
    setDPR(value) {
      this.dpr = value;
    },
    setLogo(logo) {
      this.logo = logo;
    },
    setLogoSecundario(logo) {
      this.logoSecundario = logo;
    },
    setMenu(payload) {
      if (payload.modulo === "") {
        this.menu = {
          agrupados: [],
          submenus: [],
          individuales: [],
        };
        this.menuAsistencial = {
          agrupados: [],
          submenus: [],
          individuales: [],
        };
        this.menuConsultaExterna = {
          agrupados: [],
          submenus: [],
          individuales: [],
        };
        this.menuInventario = {
          agrupados: [],
          submenus: [],
          individuales: [],
        };
        this.menuConfiguracion = {
          agrupados: [],
          submenus: [],
          individuales: [],
        };
        this.menuAutorizacion = {
          agrupados: [],
          submenus: [],
          individuales: [],
        };
        this.menuAdministrativo = {
          agrupados: [],
          submenus: [],
          individuales: [],
        };
        this.menuReportes = {
          agrupados: [],
          submenus: [],
          individuales: [],
        };
        this.menuDocumental = {
          agrupados: [],
          submenus: [],
          individuales: [],
        };
        return;
      }
      switch (payload.modulo) {
        case "central":
          this.menu = payload.menu;
          break;
        case "configuracion":
          this.menuConfiguracion = payload.menu;
          break;
        case "utilidades":
          this.menuUtilidades = payload.menu;
          break;
      }
    },
    setTipodocs(value) {
      this.tipodocs = value;
    },
    setPrefijosTera(value) {
      this.prefijosTera = value;
    },
    setLeftDrawerOpen(val) {
      this.leftDrawerOpen = val;
    },
    setLockMiniState(val) {
      this.lockMiniState = val;
    },
    setMiniState(val) {
      this.miniState = val;
    },
    setErrores(errores = []) {
      this.errores = errores;
    },
    setColor(variable = "primary", color) {
      setCssVar(variable, color);
      this.bgLinear = `background: linear-gradient(60deg, ${getCssVar(
        "primary"
      )} 0%, ${getCssVar("secondary")} 94%);`;
    },
    setFiltroFirma(value) {
      this.filtroFirma = value;
    },
  },
  persist: {
    enabled: true,
    strategies: [{ storage: sessionStorage }],
  },
});
