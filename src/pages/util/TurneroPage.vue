<template>
  <q-page class="q-pa-xs">
    <div class="row q-col-gutter-sm">
      <ServerSideTableComponent
        ref="tableTURNERO"
        :titulo="dtTURNERO.titulo"
        :tabla="dtTURNERO.tabla"
        :columnas="dtTURNERO.columnas"
        :row_key="dtTURNERO.row_key"
        :columnas_visibles="dtTURNERO.columnas_visibles"
        :ordenarPor="dtTURNERO.ordenarPor"
        @fila="crudNOTI('Editar', $event)"
        :dense="true"
        :condicion_adicional="whereTURNERO"
        :columnas_filtro="dtTURNERO.columnas_filtro"
        :inner_join="dtTURNERO.inner_join"
        :left_join="dtTURNERO.left_join"
        :permiteExportar="false"
        :permisoColumnas="false"
        colorSelect="green-2"
        class="col-12"
        flat
        :rows_per_page_options="[5, 10, 25, 50, 100]"
        :rowsPerPage="10"
      >
      </ServerSideTableComponent>
    </div>
    <q-dialog
      v-model="notiDialog"
      class="q-pa-none"
      :maximized="dialogMaximixed"
      transition-show="slide-up"
      transition-hide="slide-down"
      :persistent="dialogMaximixed"
    >
      <q-card style="width: 90%; max-width: 90vw">
        <q-bar dark class="bg-secondary">
          <div class="col text-center text-weight-bold">
            {{ noti?.PROCESO }} Notificacion {{ noti?.ID }}
          </div>
          <q-btn dense flat round icon="close" v-close-popup />
        </q-bar>
        <q-form @submit="onTakeCompletedNOTI()">
          <q-card-section class="q-pa-none row">
            <!-- {{ noti.WHATSAPP }}
            {{ noti.SMS }}
            {{ noti.MAIL }} -->
            <q-input
              v-model="noti.FECHA_NOTIFICA"
              type="date"
              label="Fecha de notificacion"
              dense
              outlined
              :stack-label="true"
              class="col-4 q-pa-xs"
            />
            <q-input
              v-model="noti.HORA_NOTIFICA"
              type="time"
              label="Hora de notificacion"
              dense
              outlined
              :stack-label="true"
              class="col-2 q-pa-xs"
            />
            <!-- :rules="[(val) => val || 'Obligatorio']" -->
            <q-toggle
              v-model="noti.WHATSAPP"
              color="green-6"
              icon="send"
              class="col-1 q-pa-xs"
            >
              <q-tooltip
                class="bg-primary text-white text-body2"
                transition-show="flip-right"
                transition-hide="flip-left"
                :offset="[10, 10]"
              >
                Enviar por WhatsApp
              </q-tooltip></q-toggle
            >
            <q-toggle
              v-model="noti.SMS"
              color="pink"
              icon="textsms"
              class="col-1 q-pa-xs"
            >
              <q-tooltip
                class="bg-primary text-white text-body2"
                transition-show="flip-right"
                transition-hide="flip-left"
                :offset="[10, 10]"
              >
                Enviar por Mensajes de texto
              </q-tooltip></q-toggle
            >
            <q-toggle
              v-model="noti.CORREO"
              color="blue-5"
              icon="mail"
              class="col-1 q-pa-xs"
            >
              <q-tooltip
                class="bg-primary text-white text-body2"
                transition-show="flip-right"
                transition-hide="flip-left"
                :offset="[10, 10]"
              >
                Enviar por Correo
              </q-tooltip></q-toggle
            >
            <q-select
              v-model="noti.API_WHATSAPP"
              label="Enviar desde:"
              :options="opt.API_WHATSAPP"
              dense
              outlined
              class="col-3 q-pa-xs"
              :rules="[(val) => (val && val.value.length > 0) || 'Obligatorio']"
            />
            <q-input
              v-if="noti.WHATSAPP || noti.SMS"
              v-model="noti.CELULAR"
              type="number"
              label="Celular"
              dense
              outlined
              class="col-6 q-pa-xs"
            />
            <q-input
              v-if="noti.CORREO"
              v-model="noti.EMAIL"
              type="text"
              label="Correo"
              dense
              outlined
              class="col-6 q-pa-xs"
            />
            <q-input
              v-model="noti.NOTIFICACION"
              type="text"
              label="Notificacion"
              dense
              outlined
              class="col-12 q-pa-xs"
              :rules="[(val) => (val && val.length > 5) || 'Obligatorio']"
            />
            <q-input
              v-model="noti.AVISARDESDE"
              type="number"
              label="Avisar"
              dense
              outlined
              :disable="false"
              class="col-3 q-pa-xs"
              :rules="[(val) => (val && val > 0) || 'Obligatorio']"
            />
            <q-select
              v-model="noti.TIPOAVISO"
              label="Avisar clase"
              :options="opt.TIPOFRECUENCIA"
              dense
              outlined
              :disable="false"
              class="col-3 q-pa-xs"
              :rules="[(val) => (val && val.value.length > 0) || 'Obligatorio']"
            />
            <q-input
              v-model="noti.FRECUENCIA"
              type="number"
              label="Frecuencia"
              dense
              outlined
              :disable="true"
              class="col-3 q-pa-xs"
              :rules="[(val) => (val && val.length > 0) || 'Obligatorio']"
            />
            <q-select
              v-model="noti.TIPOFRECUENCIA"
              label="Tipo Frecuencia"
              :options="opt.TIPOFRECUENCIA"
              dense
              outlined
              :disable="true"
              class="col-3 q-pa-xs"
              :rules="[(val) => (val && val.value.length > 0) || 'Obligatorio']"
            />
          </q-card-section>
          <q-card-actions align="right" class="row q-gutter-xs">
            <q-btn label="Guardar" no-caps type="submit" color="primary" />
            <q-btn label="Cancelar" no-caps color="cyan-14" v-close-popup />
          </q-card-actions>
        </q-form>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup>
//region import
import { computed, onMounted, reactive, ref, watch } from "vue";
// import ServerSideTableComponent  from "src/components/ServerSideTableComponent.vue";
import ServerSideTableComponent from "src/components/ServerSideTableComponent.vue";
import { useSeguridadStore } from "stores/seguridad";
import { useRouter } from "vue-router";
import { useAppStore } from "src/stores/app";
import { useUtilidadesStore } from "src/stores/utilidades";
import { useQuasar, uid } from "quasar";
import { useFechas } from "boot/useFechas";

//end region

//region data
const router = useRouter();
const SeguridadStore = useSeguridadStore();
const UtilidadStore = useUtilidadesStore();
const appStore = useAppStore();
const grupoSel = ref(null);
const notiDialog = ref(false);
const $q = useQuasar();
const tableNOTI = ref(null);
const dialogMaximixed = ref(false);
const {
  getFechaCorta,
  getFechaCortaGringa,
  getFechaLarga,
  getFechaLargaGringa,
  getHora,
  getDate,
} = useFechas();

const opt = ref({
  TIPOFRECUENCIA: [
    { value: "Dias", label: "Dias" },
    { value: "Horas", label: "Horas" },
  ],
  API_WHATSAPP: [
    { value: "http://localhost:3002/lead", label: "3185171659" },
    { value: "http://localhost:3003/lead", label: "3205825363" },
  ],
});

const noti = ref({
  ID: null,
  PROCESO: "Insertar",
  FECHA_NOTIFICA: null,
  HORA_NOTIFICA: null,
  NOTIFICACION: null,
  CORREO: false,
  WHATSAPP: true,
  SMS: true,
  CELULAR: "",
  EMAIL: "",
  AVISARDESDE: 1,
  TIPOAVISO: opt.value.TIPOFRECUENCIA.find((el) => el.value == "Dias"),
  FRECUENCIA: 1,
  TIPOFRECUENCIA: "Horas",
  API_WHATSAPP: "",
});

const dtTURNERO = ref({
  titulo: "Notificaciones",
  tabla: "TURNERO",
  row_key: "ID",
  ordenarPor: "FECHA_LLAMA DESC",
  columnas_visibles: `ID, FECHA_LLAMA, AFI.NOMBREAFI
                      `,
  columnas: [
    {
      name: "ID",
      required: true,
      label: "Id",
      align: "left",
      field: (row) => row.ID,
      format: (val) => val,
      sortable: true,
    },
    {
      name: "FECHA_LLAMA",
      required: true,
      label: "Fecha llamado",
      align: "left",
      field: (row) => row.FECHA_LLAMA,
      format: (val) => `${getFechaCorta(val)} ${getHora(val)}`,
      sortable: true,
    },
    {
      name: "FECHA_NOTIFICA",
      required: true,
      label: "Paciente",
      align: "left",
      field: (row) => row.NOMBREAFI,
      format: (val) => val,
      sortable: true,
    },
  ],
  columnas_filtro: "NOMBREAFI",
  inner_join: ` CIT ON CIT.CONSECUTIVO=TURNERO.CONSECUTIVOCIT
                LEFT JOIN AFI ON AFI.IDAFILIADO=CIT.IDAFILIADO`,
});
//region methods
const onSelect = (fila) => {
  // console.log("omar:")
};
const llenarNOTI = (fila) => {
  noti.value.ID = fila.ID;
  noti.value.FECHA_NOTIFICA = getFechaCortaGringa(fila.FECHA_NOTIFICA);
  noti.value.HORA_NOTIFICA = getHora(fila.FECHA_NOTIFICA);
  noti.value.NOTIFICACION = fila.NOTIFICACION;
  noti.value.AVISARDESDE = fila.AVISARDESDE;
  noti.value.FRECUENCIA = 1;
  noti.value.TIPOFRECUENCIA = "Horas";
  noti.value.CELULAR = fila.NUMERO;
  noti.value.EMAIL = fila.EMAIL;
  noti.value.SMS = fila.SMS;
  noti.value.WHATSAPP = fila.WHATSAPP;
  noti.value.CORREO = fila.CORREO;
  noti.value.API_WHATSAPP = opt.value.API_WHATSAPP.find(
    (el) => el.value == fila.API_WHATSAPP
  );
  noti.value.TIPOAVISO = opt.value.TIPOFRECUENCIA.find(
    (el) => el.value == fila.TIPOAVISO
  );
  notiDialog.value = true;
};

const onStore = () => {
  noti.value.WHATSAPP = UtilidadStore.getNotificacion?.WHATSAPP || false;
  noti.value.SMS = UtilidadStore.getNotificacion?.SMS || false;
  noti.value.CORREO = UtilidadStore.getNotificacion?.CORREO || false;
  noti.value.API_WHATSAPP = opt.value.API_WHATSAPP.find(
    (el) => el.label == UtilidadStore.getNotificacion?.ENVIARDESDE || null
  );
  noti.value.EMAIL = SeguridadStore.getUsuario?.EMAIL;
  noti.value.CELULAR = SeguridadStore.getUsuario?.CELULAR;
};
//end region

//region Computed
const whereTURNERO = computed(() => {
  let cond = " TURNERO.ESTADO=0";
  return cond;
});
//end region

//region Watch
// watch(whereUSGRUH, (newWhere, oldWhere) => {
//   setTimeout(() => {
//     tableUSGRUH.value?.obligarRefrescar();
//   }, 100);
// });
//end region

//region Hooks
onMounted(() => {
  // onStore();
});
//end region
</script>
