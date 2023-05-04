<template>
  <q-page class="q-pa-xs">
    <div class="row q-col-gutter-sm">
      <!-- AQUI PAGE
      <q-btn color="blue" @click="onBack" label="OMAR" /> -->
      <ServerSideTableComponent
        ref="tableNOTI"
        :titulo="dtNOTI.titulo"
        :tabla="dtNOTI.tabla"
        :columnas="dtNOTI.columnas"
        :row_key="dtNOTI.row_key"
        :columnas_visibles="dtNOTI.columnas_visibles"
        :ordenarPor="dtNOTI.ordenarPor"
        @fila="onSelect($event)"
        :dense="true"
        :condicion_adicional="whereNOTI"
        :columnas_filtro="dtNOTI.columnas_filtro"
        :inner_join="dtNOTI.inner_join"
        :left_join="dtNOTI.left_join"
        :permiteExportar="false"
        :permisoColumnas="false"
        colorSelect="green-2"
        class="col-12"
        flat
        :rows_per_page_options="[5, 10, 25, 50, 100]"
        :rowsPerPage="10"
      >
        <template v-slot:seccion_superior_izquierda>
          <q-btn
            color="primary"
            icon="add"
            round
            @click="crudNOTI('Insertar', '')"
            size="sm"
          >
            <q-tooltip
              class="bg-primary text-body2"
              transition-show="flip-right"
              transition-hide="flip-left"
              :offset="[10, 10]"
            >
              Agregar Notificacion
            </q-tooltip>
          </q-btn>
        </template>
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
            {{ noti?.PROCESO }} Notificacion
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
              :rules="[(val) => (val && val.length > 0) || 'Obligatorio']"
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

const dtNOTI = ref({
  titulo: "Notificaciones",
  tabla: "NOTI",
  row_key: "ID",
  ordenarPor: "ID DESC",
  columnas_visibles: `ID, FECHA_REGISTRO, USUARIO_REGISTRO, FECHA_NOTIFICA, NOTIFICACION, SMS, WHATSAPP, CORREO`,
  columnas: [
    {
      name: "FECHA_REGISTRO",
      required: true,
      label: "Fecha Ingresa",
      align: "left",
      field: (row) => row.FECHA_REGISTRO,
      format: (val) => val,
      sortable: true,
    },
    {
      name: "NOTIFICACION",
      required: true,
      label: "Notificacion",
      align: "left",
      field: (row) => row.NOTIFICACION,
      format: (val) => val,
      sortable: true,
    },
    {
      name: "FECHA_NOTIFICA",
      required: true,
      label: "Fecha de Notificacion",
      align: "left",
      field: (row) => row.FECHA_NOTIFICA,
      format: (val) => val,
      sortable: true,
    },
  ],
  columnas_filtro: "NOTIFICACION",
});
//region methods
const onSelect = (fila) => {
  // console.log("omar:")
};
const crudNOTI = (mode, fila) => {
  if (mode == "Insertar") {
    noti.value.PROCESO = mode;
    onReset();
    notiDialog.value = true;
  }
};
const onReset = () => {
  noti.value.FECHA_NOTIFICA = getDate("date");
  noti.value.HORA_NOTIFICA = getDate("time");
  noti.value.NOTIFICACION = null;
  noti.value.AVISARDESDE = 1;
  noti.value.TIPOAVISO = opt.value.TIPOFRECUENCIA.find(
    (el) => el.value == "Dias"
  );
  noti.value.FRECUENCIA = 1;
  noti.value.TIPOFRECUENCIA = "Horas";
};

const onTakeCompletedNOTI = () => {
  if (onValida()) {
    appStore
      .json({
        MODELO: "NOTI",
        METODO: "CRUDNOTI",
        PARAMETROS: {
          PROCESO: noti.value.PROCESO,
          FECHA_NOTIFICA: noti.value.FECHA_NOTIFICA,
          HORA_NOTIFICA: noti.value.HORA_NOTIFICA,
          NOTIFICACION: noti.value.NOTIFICACION,
          WHATSAPP: noti.value.WHATSAPP,
          SMS: noti.value.SMS,
          EMAIL: noti.value.EMAIL,
          CELULAR: noti.value.CELULAR,
          CORREO: noti.value.CORREO,
          API_WHATSAPP: noti.value.API_WHATSAPP.value,
          AVISARDESDE: noti.value.AVISARDESDE,
          TIPOAVISO: noti.value.TIPOAVISO.value,
        },
      })
      .then((res) => {
        if (res.data.result.recordset[0].OK === "OK") {
          $q.notify({
            color: "positive",
            message:
              noti.value.PROCESO == "Insertar"
                ? "Registro Insertado correctamente"
                : "Registro Actualizado correctamente",
            position: "top",
            timeout: 200,
          });
          notiDialog.value = false;
          UtilidadStore.setWhatsapp(noti.value.WHATSAPP);
          UtilidadStore.setSms(noti.value.SMS);
          UtilidadStore.setCorreo(noti.value.CORREO);
          UtilidadStore.setEnviarDesde(noti.value.API_WHATSAPP.label);
          setTimeout(() => {
            tableNOTI.value.obligarRefrescar();
          }, 200);
        }
      });
  }
};
const onValida = () => {
  if (
    noti.value?.WHATSAPP == false &&
    noti.value?.SMS == false &&
    noti.value?.CORREO == false
  ) {
    $q.notify({
      color: "negative",
      message: "Debe seleccionar un metodo de notificacion",
      position: "top",
      timeout: 2000,
    });
    return false;
  }
  if (noti.value?.WHATSAPP || noti.value?.SMS) {
    if (!noti.value.CELULAR || noti.value.CELULAR.length != 10) {
      $q.notify({
        color: "negative",
        message: "Debe ingresar un numero de contacto valido",
        position: "top",
        timeout: 2000,
      });
      return false;
    }
  }
  if (
    noti.value?.CORREO &&
    (noti.value?.EMAIL == "" ||
      !noti.value?.EMAIL.includes("@") ||
      !noti.value?.EMAIL.includes("."))
  ) {
    $q.notify({
      color: "negative",
      message: "Debe ingresar un correo valido",
      position: "top",
      timeout: 2000,
    });
    return false;
  }
  return true;
};
//end region

//region Computed
const whereNOTI = computed(() => {
  let cond = " 1 = 1";
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
  noti.value.WHATSAPP = UtilidadStore.getNotificacion?.WHATSAPP || false;
  noti.value.SMS = UtilidadStore.getNotificacion?.SMS || false;
  noti.value.CORREO = UtilidadStore.getNotificacion?.CORREO || false;
  noti.value.API_WHATSAPP = opt.value.API_WHATSAPP.find(
    (el) => el.label == UtilidadStore.getNotificacion?.ENVIARDESDE || null
  );
  noti.value.EMAIL = SeguridadStore.getUsuario?.EMAIL;
  noti.value.CELULAR = SeguridadStore.getUsuario?.CELULAR;
});
//end region
</script>
