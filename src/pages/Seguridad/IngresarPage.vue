<template>
  <!-- <q-page
    padding
    v-bind:style="{ backgroundImage: 'url(' + image + ')' }"
    style="background-size: cover; background-repeat: no-repeat"
  > -->
  <q-page class="bg-main">
    omar
    <div class="q-pa-md" style="height: 98vh">
      <div class="row shadow-10" style="height: 102%">
        <div
          class="col-12 col-md-6 col-sm-6 flex flex-center bg-light large-screen-only"
        >
          <img alt="Qrystalos logo" src="img/logo.png" />
        </div>
        <div class="col-12 col-md-6 col-sm-6 bg-form shadow-1">
          <div
            class="text-h2 text-black text-center bg-primary"
            @keydown.esc="regresarAInicio"
          >
            <div class="q-pa-xl q-mb-xl text-bold btn-main text-white">
              Ingresar a Qrystalos
            </div>
          </div>
          <div class="flex flex-center q-pt-xl" v-if="true">
            <div
              class="q-pa-md bg-light-blue-1 bg-transparent shadow-2 rounded-borders login-box"
              v-if="identificado === 0"
            >
              <transition
                appear
                enter-active-class="animated bounceInLeft"
                leave-active-class="animated bounceOutRight"
              >
                <q-form @submit="onSubmit" @reset="onReset" class="q-gutter-xs">
                  <q-select
                    id="compania"
                    ref="compania"
                    filled
                    v-model="compania"
                    :options="companias"
                    :label="$t('form.login.compania_label')"
                    :loading="cargandoCompanias"
                    option-label="RAZONSOCIAL"
                    option-value="COMPANIA"
                    :rules="[
                      (val) =>
                        (val && val.value != '') ||
                        this.$t('form.required_option'),
                    ]"
                  >
                    <template v-slot:no-option>
                      <q-item>
                        <q-item-section class="text-italic text-grey">{{
                          $t("form.no_option")
                        }}</q-item-section>
                      </q-item>
                    </template>
                    <template v-slot:append>
                      <q-icon
                        class="cursor-pointer"
                        name="refresh"
                        @click="onReloadCompanias"
                      />
                    </template>
                  </q-select>
                  <!-- {{compania}} -->
                  <q-input
                    id="usuario"
                    ref="usuario"
                    filled
                    v-model="usuario"
                    :label="$t('form.login.usuario_label')"
                    :hint="$t('form.login.usuario_hint')"
                    lazy-rules
                    :rules="[
                      (val) =>
                        (val && val.length > 0) ||
                        this.$t('form.required_text'),
                    ]"
                    :loading="cargando"
                  />
                  <!-- termina usuario -->
                  <!-- empieza clave -->
                  <q-input
                    v-model="claveWeb"
                    filled
                    :type="isPwd ? 'password' : 'text'"
                    :label="$t('form.login.clave_label')"
                    :hint="$t('form.login.clave_hint')"
                    ref="claveWeb"
                    lazy-rules
                  >
                    <template v-slot:append>
                      <q-icon
                        :name="isPwd ? 'visibility_off' : 'visibility'"
                        class="cursor-pointer"
                        @click="isPwd = !isPwd"
                      />
                    </template>
                  </q-input>
                  <q-btn
                    :label="$t('button.ingresar')"
                    type="submit"
                    color="primary"
                    icon="lock_open"
                    :loading="cargando"
                    class="btn-main"
                  />
                  <!-- termina clave -->
                  <div>
                    <span class="text-bold text-orange-8"
                      >v{{ $q.version }}</span
                    >
                  </div>
                </q-form>
              </transition>
            </div>
            <div
              class="q-pa-md bg-light-blue-1 bg-transparent shadow-2 rounded-borders login-box"
              v-else-if="identificado === 1"
            >
              <transition
                appear
                enter-active-class="animated bounceInLeft"
                leave-active-class="animated bounceOutRight"
              >
                <div @keydown.esc="regresarAInicio">
                  <div class="text-h4 text-italic text-indigo" v-if="nombre">
                    {{ nombre }}
                  </div>
                  <q-form @submit="onConfigurar" class="q-gutter-md">
                    <!-- <q-input
                      type="password"
                      autocomplete="new-password"
                      id="claveKrystalos"
                      ref="claveKrystalos"
                      filled
                      v-model="claveKrystalos"
                      :label="$t('form.login.clave_krystalos_label')"
                      :hint="$t('form.login.clave_krystalos_hint')"
                      lazy-rules
                      :rules="[
                        (val) =>
                          (val && val.length > 0) ||
                          this.$t('form.required_text'),
                      ]"
                    /> -->
                    <q-input
                      type="password"
                      autocomplete="new-password"
                      id="claveWeb"
                      ref="claveWeb"
                      filled
                      v-model="claveWeb"
                      :label="$t('form.login.nueva_clave_label')"
                      :hint="$t('form.login.nueva_clave_hint')"
                      lazy-rules
                      :rules="[
                        (val) =>
                          (val && val.length > 0) ||
                          this.$t('form.required_text'),
                      ]"
                    />
                    <q-input
                      type="password"
                      autocomplete="new-password"
                      id="claveWeb2"
                      ref="claveWeb2"
                      filled
                      v-model="claveWeb2"
                      :label="$t('form.login.nueva_calve2_label')"
                      :hint="$t('form.login.nueva_calve2_hint')"
                      lazy-rules
                      :rules="[
                        (val) =>
                          (val && val.length > 0) ||
                          this.$t('form.required_text'),
                        (val) =>
                          (val && val == this.claveWeb) ||
                          'La Clave debe Coincidir',
                      ]"
                    />
                    <div>
                      <q-btn
                        :label="$t('button.cancelar')"
                        color="negative"
                        icon="subdirectory_arrow_left"
                        @click="
                          claveKrystalos = claveWeb = claveWeb2 = null;
                          identificado = 0;
                        "
                        :disable="cargando"
                        class="btn-cancel"
                      />&nbsp;
                      <q-btn
                        :label="$t('button.registrar')"
                        type="submit"
                        color="primary"
                        icon="send"
                        :loading="cargando"
                        class="btn-main"
                      />
                    </div>
                  </q-form>
                </div>
              </transition>
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
    };
  },
  mounted() {
    if (process.env.NODE_ENV !== "production") {
      // this.usuario = "OSOLANO";
      // this.claveWeb = "OMAR2020";
      this.usuario = process.env.USER_TEST;
      this.claveWeb = process.env.PASS_TEST;
    }
    this.onReloadCompanias();
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
