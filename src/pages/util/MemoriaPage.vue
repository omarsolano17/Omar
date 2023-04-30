<template>
  <q-page class="q-pa-xs">
    <div class="row q-col-gutter-sm">
      <!-- AQUI PAGE
      <q-btn color="blue" @click="onBack" label="OMAR" /> -->
      <ServerSideTableComponent
        ref="tableMEMO"
        :titulo="dtMEMO.titulo"
        :tabla="dtMEMO.tabla"
        :columnas="dtMEMO.columnas"
        :row_key="dtMEMO.row_key"
        :columnas_visibles="dtMEMO.columnas_visibles"
        :ordenarPor="dtMEMO.ordenarPor"
        @fila="onSelect($event)"
        :dense="true"
        :condicion_adicional="where"
        :columnas_filtro="dtMEMO.columnas_filtro"
        :inner_join="dtMEMO.inner_join"
        :left_join="dtMEMO.left_join"
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
            @click="memoDialog = true"
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
      v-model="memoDialog"
      class="q-pa-none"
      :maximized="dialogMaximixed"
      transition-show="slide-up"
      transition-hide="slide-down"
      :persistent="dialogMaximixed"
    >
      <q-card style="width: 100%; max-width: 100vw">
        <q-bar dark class="bg-secondary">
          <div class="col text-center text-weight-bold">
            {{ memo?.PROCESO }} Notificacion
          </div>
          <q-btn dense flat round icon="close" v-close-popup />
        </q-bar>
        <q-form @submit="onTakeCompletedMEMO()">
          <q-card-section class="q-pa-none row">
            <q-input
              v-model="memo.FECHA_NOTIFICA"
              type="date"
              label="Fecha de notificacion"
              dense
              outlined
              class="col-6 q-pa-xs"
            />
            <q-toggle
              v-model="memo.WHATSAPP"
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
              v-model="memo.SMS"
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
              v-model="memo.CORREO"
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
            <q-input
              v-if="memo.WHATSAPP || memo.SMS"
              v-model="memo.CELULAR"
              type="text"
              label="Celular"
              dense
              outlined
              class="col-6 q-pa-xs"
            />
            <q-input
              v-if="memo.CORREO"
              v-model="memo.EMAIL"
              type="text"
              label="Correo"
              dense
              outlined
              class="col-6 q-pa-xs"
            />
            <q-input
              v-model="memo.NOTIFICACION"
              type="text"
              label="Notificacion"
              dense
              outlined
              class="col-12 q-pa-xs"
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
import { date, useQuasar, uid } from "quasar";
//end region

//region data
const router = useRouter();
const SeguridadStore = useSeguridadStore();
const appStore = useAppStore();
const grupoSel = ref(null);
const notiDialog = ref(false);
const $q = useQuasar();
const tableMEMO = ref(null);
const dialogMaximixed = ref(false);

const memo = ref({
  PROCESO: "Insertar",
  FECHA_NOTIFICA: null,
  NOTIFICACION: null,
  CORREO: false,
  WHATSAPP: true,
  SMS: true,
  CELULAR: "",
  EMAIL: "",
});

const dtMEMO = ref({
  titulo: "Notificaciones",
  tabla: "NOTI",
  row_key: "ID",
  ordenarPor: "ID",
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
const onBack = () => {
  SeguridadStore.setJWT(null);
  // router.push({ name: "conf" });
};
const onSelect = (fila) => {
  console.log("omar:", fila?.GRUPO);
  grupoSel.value = fila?.GRUPO;
};
const onTakeCompletedMEMO = () => {
  appStore
    .json({
      MODELO: "NOTI",
      METODO: "CRUDNOTI",
      PARAMETROS: {
        PROCESO: memo.value.PROCESO,
        FECHA_NOTIFICA: memo.value.FECHA_NOTIFICA,
        NOTIFICACION: memo.value.NOTIFICACION,
        WHATSAPP: memo.value.WHATSAPP,
        SMS: memo.value.SMS,
        EMAIL: memo.value.EMAIL,
        CELULAR: memo.value.CELULAR,
        CORREO: memo.value.CORREO,
      },
    })
    .then((res) => {
      if (res.data.result.recordset[0].OK === "OK") {
        $q.notify({
          color: "positive",
          message:
            memo.value.PROCESO == "Insertar"
              ? "Registro Insertado correctamente"
              : "Registro Actualizado correctamente",
          position: "top",
          timeout: 2000,
        });
        notiDialog.value = false;
        setTimeout(() => {
          tablememo.value.obligarRefrescar();
        }, 200);
      }
    });
};
//end region

//region Computed
const whereUSGRUH = computed(() => {
  let cond = null;
  if (!grupoSel.value) {
    cond = ` 1 = 2 `;
  } else {
    cond = ` USGRUH.GRUPO = '${grupoSel.value}'`;
  }
  return cond;
});
const titulo = computed(() => {
  let cond = null;
  if (!grupoSel.value) {
    cond = ``;
  } else {
    cond = ` Permisos del grupo ${grupoSel.value}`;
  }
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
  memo.value.EMAIL = SeguridadStore.getUsuario.EMAIL;
  memo.value.CELULAR = SeguridadStore.getUsuario.CELULAR;
});
//end region
</script>
