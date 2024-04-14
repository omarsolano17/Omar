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
            Menu
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
                <q-item clickable v-close-popup dense @click="vista2='Contactos'">
                  <q-item-section avatar >
                    <q-item-label class="row flex flex-center">
                      <q-avatar color="green" text-color="white" icon="message" dense size="sm" class="q-mr-xs"/>
                      Contactos
                    </q-item-label>
                  </q-item-section>
                </q-item>
                <q-item clickable v-close-popup dense @click="vista2='Historial'">
                  <q-item-section avatar >
                    <q-item-label class="row flex flex-center">
                      <q-avatar color="green" text-color="white" icon="message" dense size="sm" class="q-mr-xs"/>
                      Historial
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
          <q-select class="q-pa-xs col-3" v-model="data.IDAPI" outlined dense emit-value map-options :options="apis" clr label="Enviar Desde"
            option-value="ID" :option-label="'DESCRIPCION'"/>
          <q-input class="q-pa-xs col-2" v-model="data.NUMERO" outlined dense type="number" label="Enviar a:" :maxlength="10"
          :rules="[(val) => (+val?.length === 10 && val?.toString()?.substring(0, 1) == '3') || 'Numero de celular incorrecto',]"/>
          <q-input class="q-pa-xs col-7" v-model="data.MENSAJE" outlined dense type="textarea" autogrow label="Mensaje" />
        </div>
        <div class="row col-12 flex q-pt-xs" v-if="vista2==='Historial'">
          <q-select class="q-pa-xs col-3" v-model="filtro.MEDIO" outlined dense emit-value map-options clearable
            :options="[{value: 'SMS', label:'Texto'},{value: 'WHATSAPP', label:'Whatsapp'},]"  label="Medio"/>
          <q-select v-if="filtro.MEDIO==='WHATSAPP'" class="q-pa-xs col-3" v-model="filtro.IDAPI" outlined dense emit-value map-options clearable 
            :options="apis" clr label="Enviados Desde:" option-value="ID" :option-label="'DESCRIPCION'"/>
            <!-- {{ whereSMSL }} -->
          <ServerSideTableComponent
            ref="tableSMSLref"
            titulo="Mensajes enviados"
            tabla="SMSL"
            :columnas_visibles="dtSMSL.columnas_visibles"
            :columnas="dtSMSL.columnas"
            :columnas_filtro="dtSMSL.columnas_filtro"
            row_key=" ITEM "
            ordenarPor="ITEM DESC"
            :dense="true"
            colorSelect="green-2"
            class="col-12"
            flat
            :rows_per_page_options="[5, 10, 25, 50, 100]"
            :rowsPerPage="10"
            :condicion_adicional="whereSMSL"
            />
            <!-- :left_join="dtUSUSU.left_join" -->
            <!-- :permiteExportar="false" -->
            <!-- :permisoColumnas="false" -->
            <!-- :inner_join="dtUSUSU.inner_join" -->
            <!-- :columnas_visibles="dtUSUSU.columnas_visibles" -->
            <!-- @fila="onSelectUsusu($event)" -->
            <!-- @evento_generico="onEventoGenerico($event)" -->
        </div>
        <div class="row col-12 flex q-pt-xs" v-if="vista2==='Contactos'">
          <q-select class="q-pa-xs col-3" v-model="filtro.IDAPI" outlined dense emit-value map-options clearable 
            :options="apis" clr label="Cargar desde:" option-value="ID" :option-label="'DESCRIPCION'"/>
          <!-- <ServerSideTableComponent
            ref="tableSMSLref"
            titulo="Mensajes enviados"
            tabla="SMSL"
            :columnas_visibles="dtSMSL.columnas_visibles"
            :columnas="dtSMSL.columnas"
            :columnas_filtro="dtSMSL.columnas_filtro"
            row_key=" ITEM "
            ordenarPor="ITEM DESC"
            :dense="true"
            colorSelect="green-2"
            class="col-12"
            flat
            :rows_per_page_options="[5, 10, 25, 50, 100]"
            :rowsPerPage="10"
            :condicion_adicional="whereSMSL"
            /> -->
        </div>
      </div>
      <div class="col-12" v-else>        
        <q-btn class="row col-12 q-ml-sm" round dense color="green-4" label="Agregar"  icon="add" @click="onAPIS('NUEVO')" flat v-if="usuario?.USUARIO==='OSOLANO'"/>
        <q-markup-table class="tabla2"  dense v-if="apis?.length>0">
          <thead>
            <tr>
              <th class="text-center">Identificador</th>
              <th class="text-left">Sede</th>
              <th class="text-left">EndPoint</th>
              <th class="text-left">Numero</th>
              <th class="text-left">Descripcion</th>
            </tr>
          </thead>
          <tbody>
            <template v-for="(x,i) in apis" :key="i">
              <tr @click="apiSelected = x, onAPIS('UPDATE',x)" class="cursor-pointer" :class="x==apiSelected ? 'bg-secondary':''" >
                <td class="text-center">{{x?.ID}}</td>
                <td class="text-left">{{x?.IDSEDE}} {{ x?.DESCRIPCION_SEDE }}</td>
                <td class="text-left">{{x?.ENDPOINT}}</td>
                <td class="text-left">{{x?.NUMERO}}</td>
                <td class="text-left">{{x?.DESCRIPCION}}</td>
              </tr>
            </template>
          </tbody>
        </q-markup-table>
        <div class="row col-12 flex q-pt-xs" v-if="false">
          <q-input class="q-pa-xs col-3" v-model="data.NUMERO" outlined dense type="number" label="Celular" :maxlength="10"
          :rules="[(val) => (+val?.length === 10 && val?.toString()?.substring(0, 1) == '3') || 'Numero de celular incorrecto',]"/>
          <q-input class="q-pa-xs col-9" v-model="data.MENSAJE" outlined dense type="textarea" autogrow label="Mensaje" />
        </div>
      </div>
    </div>
    
    <q-dialog v-model="api.DGAPI" persistent>
      <q-card style="width: 70%; max-width: 95%">
        <q-bar class="text-white bg-primary">
          <!-- <span>{{ ususu?.METODO.charAt(0).toUpperCase() + ususu?.METODO.slice(1).toLowerCase() }} Usuario: {{ ususu?.USUARIO }} - {{ ususu?.NOMBRE }}</span> -->
          <q-space />

          <q-btn flat icon="close" v-close-popup />
        </q-bar>
        <q-card-section class="row items-center">
          <div class="row col-12">
            <!-- IDSEDE, [ENDPOINT], NUMERO, DESCRIPCION, ACTIVO -->
            <q-input  class="q-pa-xs col-1" v-model="api.ID" type="text" outlined dense label="Id" disable/>
            <q-input  class="q-pa-xs col-5" v-model="api.ENDPOINT" type="text" outlined dense label="EndPoint" v-show="api.METODO === 'INSERTAR'"/>
            <q-select class="q-pa-xs col-6" v-model="api.IDSEDE" outlined dense emit-value map-options options="opt.sede" clr label="Sede"/>
            <q-input  class="q-pa-xs col-3" v-model="api.NUMERO" outlined dense type="number" label="Celular / Numero" :maxlength="10"
            :rules="[(val) => (+val?.length === 10 && val?.toString()?.substring(0, 1) == '3') || 'Numero de celular incorrecto',]"/>
            <q-input  class="q-pa-xs col-7" v-model="api.DESCRIPCION" type="text" outlined dense label="Denominacion / Descripcion"/>
            <q-toggle v-model="api.ACTIVO" color="red" label="Activo?"/>
          </div>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cancelar" color="secondary" v-close-popup />
          <q-btn flat :label="api?.METODO?.toLowerCase()" color="primary" @click="onAPIS(api?.METODO)"/>
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup>
import { useQuasar } from "quasar";
import { ref, onMounted, computed, watch } from "vue";
import { useAppStore } from "stores/app";
import { useSeguridadStore } from "stores/seguridad";
import ServerSideTableComponent from "src/components/ServerSideTableComponent.vue";

//#region DATA
const $q = useQuasar();
const appStore = useAppStore();
const authStore = useSeguridadStore();
const filtro = ref({});
const filter = ref("");
const vista = ref("sms");
const vista2 = ref("Contactos");

const api = ref({});
const apiSelected = ref({});
const apis = ref([]);
const apiFrom = ref(null);
const tableSMSLref = ref(null);
const data = ref({});
const dtSMSL = ref({
  columnas: [
    {name: "VIA", required: true, label: "Medio", align: "left", field: (row) => row.VIA, format: (val) => val, sortable: true},
    {name: "CONTACTO", required: true, label: "Numero", align: "left", field: (row) => row.CONTACTO, format: (val) => val, sortable: true},
    {name: "MENSAJE", required: true, label: "Mensaje", align: "left", field: (row) => row.MENSAJE, format: (val) => val, sortable: true},
  ],
  columnas_visibles: "ITEM, VIA, CONTACTO, MENSAJE",
  columnas_filtro: "CONTACTO, MENSAJE"
})


//#endregion

//#region METHODS
const onSMS = () => {
  appStore
  .json({
    MODELO: "SMS",
    METODO: "ENVIAR",
    PARAMETROS: { NUMERO:  data?.value?.NUMERO, MENSAJE: data?.value?.MENSAJE, IDAPI: data?.value?.IDAPI},
  })
  .then((res) => {
    if (res?.data?.result?.recordsets[0][0]?.OK === "OK") {
      apiFrom.value = data?.value?.IDAPI
      $q.notify({message: `Mensaje de prueba enviado a ${data?.value?.NUMERO} Correctamente`,  color: 'positive', position: 'top', timeout: 2000 })
      data.value = {}
      data.value.IDAPI = apiFrom.value
    }
  });
};
const onAPIS = (metodo, fila) => {
  if (metodo === "NUEVO") {
    api.value = {};
    api.value.METODO = "INSERTAR";
    api.value.IDSEDE = usuario?.value?.IDSEDE;
    api.value.ENDPOINT = 'http://';
    api.value.ACTIVO = true;
    api.value.DGAPI = true;
  } else if (metodo === "UPDATE") {
    api.value = { ...fila };
    api.value.METODO = "EDITAR";
    api.value.DGAPI = true;
  } else if (metodo === "INSERTAR" || metodo === "EDITAR" || metodo==='CONSULTAR') {
    appStore
      .json({
        MODELO: "APIS",
        METODO: metodo,
        PARAMETROS: {
          ID:         api?.value?.ID,
          IDSEDE:     api?.value?.IDSEDE,
          ENDPOINT:   api?.value?.ENDPOINT,
          ACTIVO:     api?.value?.ACTIVO,
          IDSEDE:     api?.value?.IDSEDE,
          NUMERO:     api?.value?.NUMERO,
          DESCRIPCION:api?.value?.DESCRIPCION
        }
      })
      .then((res) => {
        if (res?.data?.result?.recordsets[0][0]?.OK === "OK") {
          apis.value = res?.data?.result?.recordsets[1]
          if (!data?.value?.IDAPI) apiFrom.value = apis?.value[0]?.ID
          if (metodo==='CONSULTAR') return

          $q.notify({message: `Api Procesado de manera correcta`,  color: 'positive', position: 'top', timeout: 2000 })
          api.value = {};
          api.value.DGAPI = false;
        }
      });
  }
};
//#endregion

//#region COMPUTED
const usuario = computed(() => {
  return authStore?.getUsuario;
});
const whereSMSL = computed(() => {
  let r = ''
  if (filtro?.value?.MEDIO){
    r = ` VIA='${filtro?.value?.MEDIO}'`
    if (filtro?.value?.MEDIO==='WHATSAPP' && filtro?.value?.IDAPI){
      r += ` AND EXISTS(SELECT 1 FROM APIS A WHERE A.ID='${filtro?.value?.IDAPI}' AND A.[ENDPOINT]=VARIABLE_API)`
    }
  }
  return r
});
//#endregion

//#region Watch
watch(whereSMSL, (newWhere, oldWhere) => {
  if (vista2?.value==='Historial'){
    tableSMSLref.value.filter=null
    setTimeout(() => {
      tableSMSLref.value.obligarRefrescar()
    }, 100);
  }
});
//#endregion
onMounted(() => {
  onAPIS('CONSULTAR')
  data.value.NUMERO = usuario?.value?.CELULAR
});
</script>
