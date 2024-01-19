<template>
  <q-page class="bg-blue-3">
    <div class="q-pa-md flex flex-center" style="height: 80vh">
      <div
        class="row shadow-5 rounded-borders bg-yellow-1"
        style="height: 80%, width: 80%"
      >
        <div class="col-12 col-md-6 col-sm-6 shadow-1 bg-red-1">
          <div class="col-12 col-md-6 col-sm-6 bg-green text-center">
            <span class="text-bold text-h5">Inicio de sesion</span>
            <div v-if="false">
              <div class="col-12">
                <label> Usuario </label>
                <input type="text" />
              </div>
              <div class="col-12">
                <label> Contraseña </label>
                <input type="password" />
              </div>
              <div>
                <button>Enviar</button>
              </div>
            </div>

            <!-- q
            m-p
            t r l b a
            xs sm md lg xl -->
            <div class="row col-12 bg-yellow-2 q-pa-xs flex-center">
              <q-input
                class="col-7 bg-red-2 q-my-xs"
                outlined
                label="Usuario"
                v-model="user"
                dense
              />
              <q-input
                class="col-7 bg-red-2 q-my-sm"
                outlined
                label="Clave"
                type="password"
                v-model="pass"
                autofocus
                dense
              />
              <div class="col-12">
                <q-btn
                  label="Ingresar"
                  no-caps
                  size="md"
                  color="green-5"
                  rounded
                  text-color="black"
                  @click="onLoginUsuario()"
                />
              </div>
            </div>
            {{ user }} {{ pass }}
          </div>
        </div>
        <div
          class="col-12 col-md-6 col-sm-6 flex flex-center large-screen-only bg-blue"
        >
          <div class="row col-12 text-center">
            <span class="col-12 text-bold text-italic q-mb-lg"
              >Bienvenido a nuestra Empresa</span
            >
            <span class="col-12 text-red text-bold q-mb-lg"
              >Siguenos en nuestras Redes Sociales</span
            >
            <div class="col-12 text-center">
              <q-btn
                href="https://api.whatsapp.com/send/?phone=573205825363&text&type=phone_number&app_absent=0"
                target="_blank"
                size="lg"
                icon="fa-brands fa-whatsapp"
                round
                color="white"
                text-color="green"
                class="q-pa-none q-ma-none"
              >
                <q-tooltip
                  class="bg-green text-black"
                  :offset="[10, 10]"
                  transition-show="jump-down"
                >
                  Ir a WhatsApp
                </q-tooltip>
              </q-btn>
              <q-btn
                @click="onRedSocial('INSTAGRAM')"
                size="lg"
                icon="fa-brands fa-instagram"
                round
                color="white"
                text-color="pink-5"
                class="q-pa-none q-ml-md"
              >
                <q-tooltip
                  class="bg-pink-5 text-black"
                  :offset="[10, 10]"
                  transition-show="jump-down"
                >
                  Ir a Instagram
                </q-tooltip>
              </q-btn>
              <q-btn
                @click="onRedSocial('FACEBOOK')"
                size="lg"
                icon="fa-brands fa-facebook"
                round
                color="white"
                text-color="indigo"
                class="q-pa-none q-ml-md"
              >
                <q-tooltip
                  class="bg-indigo-4 text-black"
                  :offset="[10, 10]"
                  transition-show="jump-down"
                >
                  Ir a Facebook
                </q-tooltip>
              </q-btn>
            </div>
          </div>
        </div>
      </div>
    </div>
  </q-page>
</template>

<script>
import { mapActions, mapState } from "pinia";
import { useSeguridadStore } from "stores/seguridad";
import { useAppStore } from "stores/app";
import { api } from "src/boot/axios";
export default {
  name: "IngresarPage",
  data() {
    return {
      image: "./background.jpg",
      usuario: null,
      clave: null,
      identificado: 0,
      compania: null,
      cargando: false,
      claveKrystalos: null,
      claveWeb: null,
      claveWeb2: null,
      isPwd: true,
      nombre: null,
      cargandoCompanias: false,
      user: null,
      pass: null,
      isHover: false,
    };
  },
  mounted() {
    if (process.env.NODE_ENV !== "production") {
      // this.usuario = "OSOLANO";
      // this.claveWeb = "OMAR2020";
      this.usuario = process.env.USER_TEST;
      this.claveWeb = process.env.PASS_TEST;
    }
    // this.onReloadCompanias();
    setTimeout(() => {
      if (this.jwt) {
        this.$router.push({ name: "home" });
      }
    }, 200);
  },
  computed: {
    ...mapState(useSeguridadStore, ["companias", "companiaFavorita", "jwt"]),
  },
  methods: {
    ...mapActions(useSeguridadStore, [
      "fetchCompanias",
      "setCompaniaFavorita",
      "verificar",
      "verificar2",
      "ingresar",
      "configurar",
      "setJWT",
      "setUsuario",
    ]),
    ...mapActions(useAppStore, [
      "json",
      "setDPR",
      "setLogo",
      "setLogoSecundario",
    ]),
    onReloadCompanias() {
      this.$q.loading.show();
      this.fetchCompanias()
        .then((res) => {
          if (this.companiaFavorita) {
            this.compania = this.companias.filter(
              (x) => x.COMPANIA === this.companiaFavorita.COMPANIA
            )[0];
          }
          this.$q.loading.hide();
        })
        .finally(() => {
          this.$q.loading.hide();
        });
    },
    onReset() {
      this.usuario = null;
      this.compania = this.companiaFavorita;
    },
    onRedSocial(red) {
      let url = "";
      switch (red) {
        case "WHATSAPP":
          url =
            "https://api.whatsapp.com/send/?phone=573205825363&text&type=phone_number&app_absent=0";
          break;
        case "INSTAGRAM":
          url = "https://www.instagram.com/solanoomar82/";
          break;
        case "FACEBOOK":
          url = "https://www.facebook.com/SOLANOOMAR82/";
          break;
        default:
          url = "https://www.google.com/?hl=es";
          break;
      }
      if (url !== "") {
        window.open(url);
      }
    },
    onSubmit() {
      this.cargando = true;
      this.verificar2(this.compania.COMPANIA, this.usuario, this.claveWeb)
        .then((res) => {
          if (res.data.res !== "ok") {
            this.$q.notify({
              color: "negative",
              textColor: "white",
              icon: "error",
              message: res.data.message,
              actions: [{ icon: "close", color: "white" }],
            });
          } else {
            var data = res.data.result.recordset;
            if (data.length <= 0) {
              this.$q.notify({
                color: "negative",
                textColor: "white",
                icon: "error",
                message: this.$t("form.login.usuario_no_encontrado"),
                actions: [{ icon: "close", color: "white" }],
              });
              this.$refs.usuario.select();
            } else {
              var usuario = null;
              if (data.length > 0) {
                usuario = data[0];
              }
              if (usuario) {
                this.nombre = usuario.NOMBRE;
                if (usuario.REGISTRADO === 1) {
                  this.onLogin();
                } else {
                  this.claveKrystalos = this.claveWeb;
                  this.claveWeb = null;
                  this.identificado = 1;
                }
              } else {
                this.$q.notify({
                  color: "negative",
                  textColor: "white",
                  icon: "error",
                  message: this.$t("form.login.usuario_no_encontrado"),
                  actions: [{ icon: "close", color: "white" }],
                });
                this.$refs.usuario.select();
              }
            }
          }
        })
        .catch((err) => {
          console.error(err);
        })
        .finally(() => {
          this.cargando = false;
        });
    },
    onLogin() {
      this.cargando = true;
      this.$q.loading.show({
        message: this.$t("form.login.cargando"),
      });
      this.ingresar(this.compania.COMPANIA, this.usuario, this.claveWeb)
        .then((res) => {
          if (res.data.res === "ok") {
            var usuario = res.data.result;
            var jwt = res.data.jwt;
            if (!usuario) {
              this.cargando = false;
              this.$q.notify({
                color: "negative",
                textColor: "white",
                icon: "block",
                message: this.$t("form.login.error_login"),
                actions: [{ icon: "close", color: "white" }],
              });
              this.$refs.claveWeb.select();
            } else {
              this.$q.loading.show({
                message: "Cargando datos del usuario",
              });
              this.setJWT(jwt);
              api.defaults.headers.common["Authorization"] = "Bearer " + jwt;
              this.setLogo(null);
              this.setLogoSecundario(null);
              this.setUsuario(usuario);
              this.$router.push({ name: "home" });
              this.cargando = false;
              // this.json({ MODELO: "MED_COL", METODO: "ESPECIALIDADES" })
              //   .then((res) => {
              //     if (res.data.res === "ok") {
              //       usuario.MEDS = res.data.result.recordset;
              //     }
              //   })
              //   .then(() => {
              //     this.$q.loading.show({
              //       message: "Consultando los datos de propiedad...",
              //     });
              //     api.get("/ususu/dpr").then((res) => {
              //       if (
              //         res.data.res !== "ok" ||
              //         res.data.result.data.recordset.length <= 0
              //       ) {
              //         this.cargando = false;
              //         this.$q.notify({
              //           color: "negative",
              //           textColor: "white",
              //           icon: "error",
              //           message:
              //             "No se ha podido encontrar los datos del propietario en la base de datos",
              //           progress: true,
              //           actions: [{ icon: "close", color: "white" }],
              //         });
              //       } else {
              //         let dpr = res.data.result.data.recordset[0];
              //         let apikey_openai = dpr.APIKEY_OPENAI;
              //         if (apikey_openai) {
              //           apikey_openai = JSON.parse(apikey_openai);
              //           if (apikey_openai.length > 0)
              //             dpr.APIKEY_OPENAI = apikey_openai[0];
              //         }
              //         this.setDPR(res.data.result.data.recordset[0]);
              //       }
              //     });
              //   })
              //   .catch((err) => {
              //     console.error(err);
              //   });
            }
          } else {
            this.$q.notify({
              color: "info",
              textColor: "black",
              icon: "info",
              message: this.$t("form.login.reintentar"),
              actions: [{ icon: "close", color: "black" }],
            });
            this.cargando = false;
            return this.$refs.claveWeb.select();
          }
        })
        .catch((err) => {
          console.error(err);
          this.cargando = false;
        });
      // .finally(() => {
      //   this.cargando = false
      // })
    },
    onConfigurar() {
      this.cargando = true;
      this.configurar(
        {
          COMPANIA: this.compania.COMPANIA,
          USUARIO: this.usuario,
          CLAVE: this.claveKrystalos,
          CLAVE_NUEVA: this.claveWeb,
        },
        { root: true }
      )
        .then((res) => {
          var data = res.data.result.recordset;
          if (data.length <= 0) {
            this.$q.notify({
              color: "info",
              textColor: "black",
              icon: "info",
              message: this.$t("form.login.reintentar"),
              actions: [{ icon: "close", color: "black" }],
            });
          } else {
            if (data[0].CONFIGURADO <= 0) {
              this.$q.notify({
                color: "negative",
                textColor: "white",
                icon: "block",
                message: this.$t("form.login.error_login"),
                actions: [{ icon: "close", color: "white" }],
              });
              this.$refs.claveKrystalos.select();
            } else {
              this.$q.notify({
                color: "positive",
                textColor: "white",
                icon: "check",
                message: this.$t("form.login.success"),
                actions: [{ icon: "close", color: "white" }],
              });
              this.onLogin();
            }
          }
        })
        .catch((err) => {
          console.error(err);
        })
        .finally(() => {
          this.cargando = false;
        });
    },
    regresarAInicio() {
      this.claveKrystalos = this.claveWeb = this.claveWeb2 = null;
      this.identificado = 0;
    },
  },
  watch: {
    compania(val) {
      this.setCompaniaFavorita(val);
    },
    cargando(val) {
      if (!val) {
        this.$q.loading.hide();
      }
    },
  },
};
</script>

<style>
.login-box {
  overflow: auto;
  min-width: 25em;
  max-width: 25em;
}
.bg-main {
  /* background-color: rgb(7, 87, 91); */
  background-color: rgb(18, 107, 175);
}
.bg-form {
  /* background-color: #F5F5F5; */
  background: linear-gradient(
    300deg,
    rgb(178, 235, 242) 0%,
    rgb(245, 245, 255) 98%
  ) !important;
}
.bg-light {
  background: linear-gradient(
    60deg,
    rgb(178, 235, 242) 0%,
    rgb(245, 245, 255) 94%
  ) !important;
}
.btn-main {
  background: linear-gradient(
    90deg,
    rgb(18, 107, 175) 0%,
    rgb(231, 120, 19) 100%
  ) !important;
}
.btn-cancel {
  background: linear-gradient(
    300deg,
    rgb(200, 36, 54) 40%,
    rgb(0, 173, 225) 100%
  ) !important;
}
.text-main {
  font-size: 62px;
  font-weight: 800;
  /* background: -webkit-linear-gradient(45deg, #09009f, #00ff95 80%); */
  background: -webkit-linear-gradient(
    45deg,
    rgb(18, 107, 175),
    rgb(231, 120, 19) 80%
  );
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin: 0;
}
</style>
