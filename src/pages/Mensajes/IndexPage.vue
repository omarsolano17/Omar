<template>
  <q-page class="q-pa-none q-ma-none">
    <div class="row q-pa-none q-ma-none">
      <div class="col-12 q-mt-sm" align="center">
        <q-btn round dense :color="vista === 'sms' ? 'green-4' : ''" icon="fa-brands fa-whatsapp" @click="vista = 'sms'" 
          :flat="vista === 'sms' ? false : true">
          <q-tooltip class="bg-primary text-body2" transition-show="flip-right" transition-hide="flip-left" :offset="[10, 10]" >
            Procesos
          </q-tooltip>
        </q-btn>
        <q-btn class="q-ml-sm" round dense :color="vista === 'settigns' ? 'grey-7' : ''" icon="settings" @click="vista = 'settigns'"
          :flat="vista === 'settigns' ? false : true">
          <q-tooltip class="bg-primary text-body2" transition-show="flip-right" transition-hide="flip-left" :offset="[10, 10]" >
            Configuraciones
          </q-tooltip>
        </q-btn>
      </div>
    </div>

    <div class="row q-col-12 q-pt-xs">
      <div class="col-12" v-if="vista==='sms'">
        <q-bar style="min-width: 250px;" class="bg-teal text-white rounded-borders">
          <div class="cursor-pointer non-selectable">
            File
            <q-menu fit >
              <q-list style="min-width: 100px" dense separator>
                <q-item clickable v-close-popup dense @click="vista2='Mensajes'">
                  <q-item-section avatar >
                    <q-item-label class="row flex flex-center">
                      <q-avatar color="green" text-color="white" icon="message" dense size="sm" class="q-mr-xs"/>
                      Mensajes
                    </q-item-label>
                  </q-item-section>
                </q-item>
                <q-item clickable v-close-popup dense>
                  <q-item-section avatar >
                    <q-item-label class="row flex flex-center">
                      <q-avatar color="green" text-color="black" icon="group" dense size="sm" class="q-mr-xs"/>
                      Campañas
                    </q-item-label>
                  </q-item-section>
                </q-item>
                <q-item clickable v-close-popup dense @click="vista2='Pruebas'">
                  <q-item-section avatar >
                    <q-item-label class="row flex flex-center">
                      <q-avatar color="green" text-color="white" icon="message" dense size="sm" class="q-mr-xs"/>
                      Pruebas
                    </q-item-label>
                  </q-item-section>
                </q-item>
              </q-list>
            </q-menu>
          </div>
          <div class="cursor-pointer non-selectable">
            Folder
            <q-menu>
              <q-list style="min-width: 100px">
                <q-item clickable v-close-popup>
                  <q-item-section>New tab</q-item-section>
                </q-item>
                <q-separator />
                <q-item clickable v-close-popup>
                  <q-item-section>New incognito tab</q-item-section>
                </q-item>
              </q-list>
            </q-menu>
          </div>
        </q-bar>
        <div class="row col-12 flex q-pt-xs" v-if="vista2==='Pruebas'">
          <q-btn class="row col-12 q-ml-sm" round dense color="green-4" label="Enviar"  icon="send" @click="onSMS()" flat/>
          <q-input class="q-pa-xs col-3" v-model="data.NUMERO" outlined dense type="number" label="Celular" :maxlength="10"
          :rules="[(val) => (+val?.length === 10 && val?.toString()?.substring(0, 1) == '3') || 'Numero de celular incorrecto',]"/>
          <q-input class="q-pa-xs col-9" v-model="data.MENSAJE" outlined dense type="textarea" autogrow label="Mensaje" />
        </div>
      </div>
      <div class="col-12" v-else>
        settigns
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { useQuasar } from "quasar";
import { ref, onMounted, computed } from "vue";
import { useAppStore } from "stores/app";
import { useSeguridadStore } from "stores/seguridad";
//#region DATA
const $q = useQuasar();
const appStore = useAppStore();
const authStore = useSeguridadStore();
const filter = ref("");
const vista = ref("sms");
const vista2 = ref("Pruebas");
const data = ref({});
const buscarRef = ref(null);
//#endregion

//#region METHODS
const onSMS = () => {
  appStore
  .json({
    MODELO: "SMS",
    METODO: "ENVIAR",
    PARAMETROS: { NUMERO:  data?.value?.NUMERO, MENSAJE: data?.value?.MENSAJE,},
  })
  .then((res) => {
    if (res?.data?.result?.recordsets[0][0]?.OK === "OK") {
      $q.notify({message: `Mensaje de prueba enviado a ${data?.value?.NUMERO} Correctamente`,  color: 'positive', position: 'top', timeout: 2000 })
      data.value = {}
    }
  });
};
//#endregion

//#region COMPUTED
// const menus = computed(() => {
//   let menus = appStore.getMenuConfiguracion;
//   if (!menus) return [];
//   if (filter.value && filter.value !== "") {
//     menus = menus.filter(
//       (x) =>
//         x.title.toLowerCase().indexOf(filter.value.toLowerCase()) !== -1 ||
//         x.caption.toLowerCase().indexOf(filter.value.toLowerCase()) !== -1
//     );
//   }
//   return menus;
// });
//#endregion
onMounted(() => {
  data.value.NUMERO = authStore?.getUsuario?.CELULAR
  
});
</script>
