<template>
  <q-page class="bg-main">
    <div class="q-pa-md flex flex-center" style="height: 100vh">
      <div class="row shadow-5 rounded-borders bg-yellow-1" style="height: 60%">
        <div class="col-12 col-md-6 col-sm-6 flex flex-center large-screen-only bg-form">
          <div class="text-center text-white">
            <span class="text-bold text-h5 col-12">Inicio de sesion</span>
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
            <div class="row col-12 q-pa-xs flex flex-center q-mb-sm q-mt-sm">
              <q-input class="col-7 q-my-xs shadow-6" outlined label="Usuario" v-model="user" dense shadow-text color="white" input-class="text-white"/>
              <q-input class="col-7 q-my-sm shadow-6" outlined label="Clave" :type="typePass" v-model="pass" color="white" input-class="text-white" dense>
                <template v-slot:append>
                  <q-icon class="cursor-pointer" :name="typePass === 'text' ? 'fa-regular fa-eye-slash' : 'fa-regular fa-eye'"
                    @click="typePass = typePass === 'password' ? 'text' : 'password'"/>
                  <q-tooltip :offset="[10, 10]" transition-show="jump-up">
                    {{typePass === "text" ? "Ocultar Contraseña" : "Mostrar Contraseña"}}
                  </q-tooltip>
                </template>
              </q-input>
              <div class="col-12">
                <q-btn class="shadow-6 bg-main" label="Ingresar" no-caps size="md" color="green-5" rounded text-color="black" @click="onIngresar()"/>
              </div>
            </div>
          </div>
        </div>
        <div class="col-12 col-md-6 col-sm-6 flex flex-center large-screen-only bg-blue-4" >
          <div>
            <div class="col-12 text-center">
              <span class="row col-12 text-bold text-italic q-ma-none q-mb-lg text-h5">Bienvenido a {{$t('nombre_sistema')}}</span>
              <span class="col-12 text-black text-bold">Siguenos en nuestras Redes Sociales</span>
              <div class="col-12 text-center q-mt-md" v-if="false">
                <q-btn :href="`https://api.whatsapp.com/send/?phone=${whatsapp}&text&type=phone_number&app_absent=0`" target="_blank" size="lg"
                  icon="fa-brands fa-whatsapp" round color="white" text-color="green" class="q-pa-none q-ma-none bg-btn">
                  <q-tooltip class="bg-green text-black" :offset="[10, 10]" transition-show="jump-down">
                    Ir a WhatsApp
                  </q-tooltip>
                </q-btn>
                <q-btn :href="`https://www.instagram.com/${instagram}/`" target="_blank" size="lg" 
                  icon="fa-brands fa-instagram" round color="white" text-color="pink-5" class="q-pa-none q-ml-md bg-btn">
                  <q-tooltip class="bg-pink-5 text-black" :offset="[10, 10]" transition-show="jump-down">
                    Ir a Instagram
                  </q-tooltip>
                </q-btn>
                <q-btn :href="`https://www.facebook.com/${facebook}/`" target="_blank" size="lg"
                  icon="fa-brands fa-facebook" round color="white" text-color="indigo" class="q-pa-none q-ml-md bg-btn">
                  <q-tooltip class="bg-indigo-4 text-black" :offset="[10, 10]" transition-show="jump-down">
                    Ir a Facebook
                  </q-tooltip>
                </q-btn>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </q-page>
</template>

<script setup>
//#region IMPORTS
import { useSeguridadStore } from "src/stores/seguridad";
import { computed, onMounted, reactive, ref, watch } from "vue";
import { useAppStore } from "src/stores/app";
import { useQuasar, date, uid, QSpinnerGears, getCssVar } from "quasar";
import { useRouter } from "vue-router";
//#endregion
//#region DATA
const seguridadStore = useSeguridadStore();
const $q = useQuasar();
const user = ref(null);
const pass = ref(null);
const cia = ref('32');
const userCompleto = ref(null);
const whatsapp = ref('573205825363');
const instagram = ref('solanoomar82');
const facebook = ref('solano.omar');
const typePass = ref("password");
const router = useRouter();
//#endregion
//#region METHODS
const onIngresar = () => {
  seguridadStore
    .ingresar(cia.value, user.value, pass.value)
    .then((res) => {
      if (res.data.res == "ok") {
        userCompleto.value = res.data.result;
        let jwt = res.data.jwt;
        seguridadStore.setJWT(jwt);
        seguridadStore.setUsuario(userCompleto.value);
        if (process.env.IS_SMS || process.env.IS_SMS==='true') router.push({ name: "sms" });
        else router.push({ name: "home" });
      } else {
        $q.notify({
          color: "red",
          textColor: "white",
          icon: "cancel",
          message: "Usuario o clave Invalidos",
          actions: [{ icon: "close", color: "black" }],
        });
      }
    })
    .catch((e) => {});
};
//#endregion
//#region COMPUTED
//const cia = computed(() => {
  //return  ;
//});

//#endregion
//#region WATCH
// watch(nombrecompelto, (newWhere, oldWhere) => {
// });
//#endregion
//#region HOOKS
onMounted(() => {
  if (process.env.DEV) {
      user.value = JSON.parse(process?.env?.USER_TEST || null) ;
      pass.value = JSON.parse(process?.env?.PASS_TEST || null) ;
  }
});
//#endregion
</script>


<style>
.login-box {
  overflow: auto;
  min-width: 25em;
  max-width: 25em;
}
.bg-main {
  /* background-color: rgb(7, 87, 91); */
  background: linear-gradient(
    -50deg,
    rgb(33, 196, 237) 0%,
    rgb(210, 59, 100) 80%
  ) !important;
}
.bg-btn {
  /* background-color: rgb(7, 87, 91); */
  background: linear-gradient(
    -40deg,
    rgba(37, 171, 164, 0.6) 0%,
    rgba(228, 189, 71, 0.6) 60%,
    rgba(97, 236, 102, 0.6) 90%
  ) !important;
}
.bg-form {
  /* background-color: #F5F5F5; */
  background: linear-gradient(
    300deg,
    rgba(31, 53, 55, 0.8) 10%,
    rgb(74, 74, 116) 80%
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
}
</style>
