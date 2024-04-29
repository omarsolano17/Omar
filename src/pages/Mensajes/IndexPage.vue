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
            Opciones
            <q-menu fit >
              <q-list style="min-width: 100px" dense separator>
                <q-item clickable v-close-popup dense @click="vista2='Mensajes'" v-if="false">
                  <q-item-section avatar >
                    <q-item-label class="row flex flex-center">
                      <q-avatar color="green" text-color="white" icon="message" dense size="sm" class="q-mr-xs"/>
                      Mensajes
                    </q-item-label>
                  </q-item-section>
                </q-item>
                <q-item clickable v-close-popup dense @click="vista2='Contactos'" v-if="false">
                  <q-item-section avatar >
                    <q-item-label class="row flex flex-center">
                      <q-avatar color="green" text-color="white" icon="message" dense size="sm" class="q-mr-xs"/>
                      Contactos
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
                <q-item clickable v-close-popup dense @click="vista2='smsCampanas'">
                  <q-item-section avatar >
                    <q-item-label class="row flex flex-center">
                      <q-avatar color="green" text-color="black" icon="group" dense size="sm" class="q-mr-xs"/>
                      Campañas
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
          <div class="cursor-pointer non-selectable" v-if="false">
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
          <span class="col-12 text-bold text-body2 text-center"> Envio de mensajes de pruebas</span>
          <q-btn class="row col-12 q-ml-sm" round dense color="green-4" label="Enviar"  icon="send" @click="onSMS()" flat/>
          <q-select class="q-pa-xs col-3" v-model="data.IDAPI" outlined dense emit-value map-options :options="apis" clr label="Enviar Desde"
            option-value="ID" :option-label="'DESCRIPCION'"/>
          <q-input class="q-pa-xs col-2" v-model="data.NUMERO" outlined dense type="number" label="Enviar a:" :maxlength="10"
          :rules="[(val) => (+val?.length === 10 && val?.toString()?.substring(0, 1) == '3') || 'Numero de celular incorrecto',]"/>
          <q-input class="q-pa-xs col-7" v-model="data.MENSAJE" outlined dense type="textarea" autogrow label="Mensaje" />
        </div>
        <div class="row col-12 q-pa-xs" v-if="vista2==='smsCampanas'">
          <span class="col-12 text-bold text-body2 text-center"> Envio masivo de mensajes - Campañas</span>
          <q-select class="q-pa-xs col-3" v-model="data.IDAPI" outlined dense emit-value map-options clearable
            :options="apis" clr label="Enviar Desde:" option-value="ID" :option-label="'DESCRIPCION'"/>
          <q-input class="q-pa-xs col-7" v-model="data.MENSAJE" outlined dense type="textarea" autogrow label="Mensaje" />
          <q-btn class="col-2 q-pa-sm" round dense color="green-4" label="Enviar Campaña" no-caps icon="send" @click="onSMS('ENVIAR_MASIVO')" flat/>
          <q-separator class="q-mt-xs" spaced />
          <div class="col-6 q-pa-xs"  align="left" >
            <div class="row">
              <q-input class="q-pa-xs col-9" v-model="data.NUMERO" outlined dense type="number" label="Agregar Manual:" :maxlength="10"
              :rules="[(val) => (+val?.length === 10 && val?.toString()?.substring(0, 1) == '3') || 'Numero de celular incorrecto',]"/>
              <q-btn class="col-3 q-pa-xs" dense  label="Add Manual" no-caps icon-right="fa-solid fa-arrow-right" @click="onAdd()" flat/>
              
              <q-file class="col-9 q-pa-xs" outlined v-model="fileUpload" dense label="Seleccionar Archivo:" >
                <template v-slot:prepend>
                  <q-icon name="attach_file" />
                </template>
              </q-file>
              <q-btn class="col-3 q-pa-xs" dense  label="Subir TXT" no-caps icon-right="upload" @click="onSubirTXT()" flat/>
            </div>
          </div>
          <div class="row col-6 q-pa-xs"  align="left" >
            <q-markup-table dense separator="cell" class="col-12" v-if="data?.NUMEROS?.length>0" style="max-height: 30rem;">
              <thead>
                <tr class="bg-primary text-white">
                  <th class="text-center"></th>
                  <th class="text-center">Numero</th>
                  <th class="text-center">Referencia</th>
                </tr>
              </thead>
              <tbody>
                <template v-for="(num, i) in data?.NUMEROS" :key="i">
                  <tr @click="current_num = num" class="cursor-pointer q-pa-none" :class="current_num === num ? 'bg-secondary' : ''">
                    <td class="text-center">
                      <q-btn class="q-pa-xs" dense  no-caps icon-right="delete" color="red" @click="onRetirar(num)" flat>
                      </q-btn>
                    </td>
                    <td class="text-center">
                      {{num?.NUMERO}}
                    </td>
                    <td class="text-center">
                      {{num?.REFERENCIA}}
                    </td>
                  </tr>
                </template>
              </tbody>
            </q-markup-table>
          </div>
        </div>
        <div class="row col-12 flex q-pt-xs" v-if="vista2==='Historial'">
          <span class="col-12 text-bold text-body2 text-center"> Historial de envio de mensajes</span>
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
            row_key="ITEM"
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
              <th class="text-center"></th>
              <th class="text-center">Identificador</th>
              <th class="text-left">Numero</th>
              <th class="text-left">Sede</th>
              <!-- <th class="text-left">EndPoint</th> -->
              <th class="text-left">Descripcion</th>
            </tr>
          </thead>
          <tbody>
            <template v-for="(x,i) in apis" :key="i">
              <tr @click="apiSelected = x" class="cursor-pointer" :class="x==apiSelected ? 'bg-secondary':''" >
                <td class="text-left">
                  <q-btn size="sm" icon="login" color="teal" round dense @click="api.LOGIN = true"/>
                  &nbsp;
                  <q-btn size="sm" icon="sms" color="teal" round dense @click="data.IDAPI = x.ID, api.DGTESTSMS = true"/>
                  &nbsp;
                  <q-btn size="sm" icon="edit" color="teal" round dense @click="onAPIS('UPDATE',x)" />
                  &nbsp;
                  <q-btn size="sm" :icon="x?.ACTIVO ? 'check' : 'cancel'" :color="x?.ACTIVO ? 'green' : 'red'" round dense />
                  &nbsp;
                  <span>{{x?.ACTIVO ? 'Activo' : 'Inactivo'}}</span>
                </td>
                <td class="text-center">{{x?.ID}}</td>
                <td class="text-left">{{x?.NUMERO}}</td>
                <td class="text-left">{{x?.IDSEDE}} {{ x?.DESCRIPCION_SEDE }}</td>
                <!-- <td class="text-left">{{x?.ENDPOINT}}</td> -->
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
    <q-dialog v-model="api.DGTESTSMS" persistent>
      <q-card style="width: 70%; max-width: 95%">
        <q-bar class="text-white bg-primary">
          <span>Prueba de Envio desde {{apis?.find(x => x?.ID===data?.IDAPI)?.DESCRIPCION}}</span>
          <q-space/>
          <q-btn flat icon="close" v-close-popup />
        </q-bar>
        <!-- <q-card-section class="row items-center"> -->
          <div class="row col-12">
            <q-select class="q-pa-xs col-3" v-model="data.IDAPI" outlined dense emit-value map-options :options="apis" clr label="Enviar Desde"
              option-value="ID" :option-label="'DESCRIPCION'" disable/>
            <q-input class="q-pa-xs col-2" v-model="data.NUMERO" outlined dense type="number" label="Enviar a:" :maxlength="10"
              :rules="[(val) => (+val?.length === 10 && val?.toString()?.substring(0, 1) == '3') || 'Numero de celular incorrecto',]"/>
            <q-input class="q-pa-xs col-7" v-model="data.MENSAJE" outlined dense type="textarea" autogrow label="Mensaje" />
          </div>
        <!-- </q-card-section> -->
        <q-card-actions align="right">
          <q-btn flat dense color="green-4" label="Enviar"  icon="send" @click="onSMS()" />
          <q-btn flat dense color="red-4" label="Salir" icon="close" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-dialog v-model="api.LOGIN" persistent>
      <q-card style="width: 70%; max-width: 95%">
        <q-bar class="text-white bg-primary">
          <!-- <span>Prueba de Envio desde {{apis?.find(x => x?.ID===data?.IDAPI)?.DESCRIPCION}}</span> -->
          <q-space/>
          <q-btn flat icon="close" v-close-popup />
        </q-bar>
        <q-card-section class="row items-center">
          <!-- <div class="row col-12"> -->
            <q-img
            spinner-color="primary"
            spinner-size="82px"
            src="/qr/qr.svg"
            width="50%"
            height="50%"
            />
          <!-- </div> -->
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat dense color="red-4" label="Salir" icon="close" v-close-popup />
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
import { useFechas } from "src/boot/useFechas";
import ServerSideTableComponent from "src/components/ServerSideTableComponent.vue";
// import { useFechas } from "stores/seguridad";
//#region DATA
const $q = useQuasar();
const appStore = useAppStore();
const authStore = useSeguridadStore();
const filtro = ref({});
const filter = ref("");
const vista = ref("sms");
const vista2 = ref("Pruebas");
const api = ref({});
const apiSelected = ref({});
const apis = ref([]);
const apiFrom = ref(null);
const rutaimg = ref(null);
const current_num = ref(null);
const tableSMSLref = ref(null);
const data = ref({NUMEROS:[]});
const fileUpload = ref(null);
const { getFechaCorta, getHora, getFechaCortaGringa } = useFechas();
const dtSMSL = ref({
  columnas: [
    {name: "VIA", required: true, label: "Medio", align: "left", field: (row) => row.VIA, format: (val) => val, sortable: true},
    {name: "CONTACTO", required: true, label: "Numero", align: "left", field: (row) => row.CONTACTO, format: (val) => val, sortable: true},
    {name: "FECHA", required: true, label: "Fecha", align: "left", field: (row) => row.FECHA, format: (val) => `${getFechaCorta(val)} - ${getHora(val)}`, sortable: true},
    {name: "MENSAJE", required: true, label: "Mensaje", align: "left", field: (row) => row.MENSAJE, format: (val)=> val, sortable: true},
  ],
  columnas_visibles: "ITEM, VIA, CONTACTO, MENSAJE, FECHA",
  columnas_filtro: "CONTACTO, MENSAJE"
})


//#endregion

//#region METHODS
const onSMS = async (metodo) => {
  let continua = true
  if (metodo==='ENVIAR_MASIVO'){
    let cant = data?.value?.NUMEROS?.length
    if (cant<=0){
      $q.notify({message: `Debe seleccionar al menos un numero`,  color: 'negative', position: 'top', timeout: 2000 })
      return
    }
    if (!data?.value?.MENSAJE || data?.value?.MENSAJE?.length<=5){
      $q.notify({message: `Debe escribir un mensaje correcto`,  color: 'negative', position: 'top', timeout: 2000 })
      return
    }
    if (!data?.value?.IDAPI){
      $q.notify({message: `Debe seleccionar el origen de envio`,  color: 'negative', position: 'top', timeout: 2000 })
      return
    }
    continua = await new Promise((resolve, reject) => {
      $q.dialog({
        title: "Campaña",
        message: `¿Está seguro de enviar esta campaña a estos ${cant} numeros?`,
        cancel: {
          label: "No",
          color: "negative",
        },
        ok: {
          label: "Si",
          color: "positive",
        },
      })
      .onOk(() => {
        resolve(true);
      })
      .onCancel(() => {
        resolve(false);
      });
    });
  }
  if (!continua) return
  appStore
  .json({
    MODELO: "SMS",
    METODO: metodo || "ENVIAR",
    PARAMETROS: { 
      NUMERO:  data?.value?.NUMERO, 
      MENSAJE: data?.value?.MENSAJE, 
      IDAPI: data?.value?.IDAPI,
      NUMEROS:  data?.value?.NUMEROS,
    },
  })
  .then((res) => {
    if (res?.data?.result?.recordsets[0][0]?.OK === "OK") {
      apiFrom.value = data?.value?.IDAPI
      $q.notify({message: `Mensaje enviado de manera Correcta`,  color: 'positive', position: 'top', timeout: 2000 })
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
          if (apis?.value?.length===1) {
            data.value.IDAPI = apis.value[0].ID
            filtro.value.IDAPI = apis.value[0].ID
          }
          if (!data?.value?.IDAPI) apiFrom.value = apis?.value[0]?.ID
          if (metodo==='CONSULTAR') return

          $q.notify({message: `Api Procesado de manera correcta`,  color: 'positive', position: 'top', timeout: 2000 })
          api.value = {};
          api.value.DGAPI = false;
        }
      });
  }
};
const onSubirTXT = async () => {
  if (fileUpload.value) {
    // data.value.NUMEROS = []
    const reader = new FileReader();
    reader.onload = (event) => {
      const content = event.target.result;
      content.split(/\r?\n/).forEach((line) => {
        const linea = line.split(',')
        if (data?.value?.NUMEROS?.filter(x => x?.NUMERO==linea[0])?.length<=0)
          data.value.NUMEROS.push({NUMERO: linea[0], REFERENCIA: linea[1]})
      })      
    };
    reader.readAsText(fileUpload.value);
  }
  // fileUpload.value = null
};
const onAdd = async () => {
  if (data?.value?.NUMEROS?.filter(x => x?.NUMERO==data?.value?.NUMERO)?.length<=0 && data?.value?.NUMERO!==null && data?.value?.NUMERO !==''){
    data.value.NUMEROS.push({NUMERO: data?.value?.NUMERO, REFERENCIA: ''})
    data.value.NUMERO = null
  }else{
    $q.notify({message: `Numero ya se encuentra en la lista o no es valido`,  color: 'negative', position: 'top', timeout: 2000 })
  }
};
const onRetirar = async (fila) => {
  data.value.NUMEROS = data?.value?.NUMEROS?.filter(x => x?.NUMERO!==fila.NUMERO)
}
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
  // console.log('aca path=',process.cwd())
  // console.log('aca path=',path.resolve('../'))
  // console.log('aca path=',path.resolve('aca','aca'))

  onAPIS('CONSULTAR')
  data.value.NUMERO = usuario?.value?.CELULAR
});
</script>
