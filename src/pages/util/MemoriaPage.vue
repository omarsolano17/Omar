<template>
  <q-page class="q-pa-xs">
    <div class="row q-col-gutter-sm q-pa-sm">
      <!-- AQUI PAGE

      <q-btn color="blue" @click="onBack" label="OMAR" /> -->

      <q-input
        v-model="filtro.FECHA_INICIAL"
        type="date"
        label="Fecha Ini"
        dense
        outlined
        :stack-label="true"
        class="col-4 q-pa-xs"
      />
      <q-input
        v-model="filtro.FECHA_FINAL"
        type="date"
        label="Fecha fin"
        dense
        outlined
        :stack-label="true"
        class="col-4 q-pa-xs"
      />
      <ServerSideTableComponent
        ref="tableMEMO"
        :titulo="dtMEMO.titulo"
        :tabla="dtMEMO.tabla"
        :columnas="dtMEMO.columnas"
        :row_key="dtMEMO.row_key"
        :columnas_visibles="dtMEMO.columnas_visibles"
        :ordenarPor="dtMEMO.ordenarPor"
        @fila="crudMEMO('Editar', $event)"
        :dense="true"
        :condicion_adicional="whereMEMO"
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
            @click="crudMEMO('Insertar', '')"
            size="sm"
          >
            <q-tooltip
              class="bg-primary text-body2"
              transition-show="flip-right"
              transition-hide="flip-left"
              :offset="[10, 10]"
            >
              Agregar evento
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
            {{ memo?.PROCESO }} evento {{ memo.ID }}
          </div>
          <q-btn dense flat round icon="close" v-close-popup />
        </q-bar>
        <q-form @submit="onTakeCompletedMEMO()">
          <q-card-section class="q-pa-none row">
            <q-input
              v-model="memo.FECHA_EVENTO"
              type="date"
              label="Fecha del Evento"
              dense
              outlined
              class="col-4 q-pa-xs"
            />
            <q-input
              v-model="memo.PERSONA"
              type="text"
              label="Persona"
              dense
              outlined
              class="col-8 q-pa-xs"
            />
            <q-input
              v-model="memo.EVENTO"
              type="text"
              label="Evento"
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
import { useFechas } from "boot/useFechas";
//end region

//region data
const router = useRouter();
const SeguridadStore = useSeguridadStore();
const appStore = useAppStore();
const grupoSel = ref(null);
const memoDialog = ref(false);
const $q = useQuasar();
const tableMEMO = ref(null);
const dialogMaximixed = ref(false);
const USUARIO = ref(null);
const {
  getFechaCorta,
  getFechaCortaGringa,
  getFechaLarga,
  getFechaLargaGringa,
  getHora,
  getDate,
} = useFechas();

const memo = ref({
  PROCESO: "Insertar",
  ID: null,
  FECHA_EVENTO: null,
  EVENTO: null,
  PERSONA: null,
});

const filtro = ref({
  FECHA_INICIAL: getFechaCortaGringa(date.formatDate(new Date(), "2001-01-01")),
  FECHA_FINAL: getFechaCortaGringa(date.formatDate(new Date(), "YYYY-MM-DD")),
});
const dtMEMO = ref({
  titulo: "Eventos",
  tabla: "MEMO",
  row_key: "ID",
  ordenarPor: "FECHA_EVENTO DESC",
  columnas_visibles: `ID, FECHA_EVENTO, EVENTO, PERSONA`,
  columnas: [
    {
      name: "FECHA_EVENTO",
      required: true,
      label: "Fecha Evento",
      align: "left",
      field: (row) => row.FECHA_EVENTO,
      format: (val) => `${getFechaCorta(val)}`,
      sortable: true,
    },
    {
      name: "PERSONA",
      required: true,
      label: "Persona",
      align: "left",
      field: (row) => row.PERSONA,
      format: (val) => val,
      sortable: true,
    },
    {
      name: "EVENTO",
      required: true,
      label: "Evento",
      align: "left",
      field: (row) => row.EVENTO,
      format: (val) => val,
      sortable: true,
    },
  ],
  columnas_filtro: "EVENTO, PERSONA",
});

const crudMEMO = (mode, fila) => {
  memo.value.PROCESO = mode;
  if (mode == "Insertar") {
    onReset();
    memoDialog.value = true;
  }
  if (mode == "Editar") {
    llenarMEMO(fila);
  }
};
const llenarMEMO = (fila) => {
  memo.value.ID = fila.ID;
  memo.value.FECHA_EVENTO = getFechaCortaGringa(fila.FECHA_EVENTO);
  memo.value.EVENTO = fila.EVENTO;
  memo.value.PERSONA = fila.PERSONA;
  memoDialog.value = true;
};
const onReset = () => {
  memo.value.ID = null;
  memo.value.FECHA_EVENTO = getDate("date");
  memo.value.EVENTO = null;
  memo.value.PERSONA = null;
};
//region methods
const onTakeCompletedMEMO = () => {
  appStore
    .json({
      MODELO: "MEMO",
      METODO: "CRUDMEMO",
      PARAMETROS: {
        PROCESO: memo.value.PROCESO,
        ID: memo.value.ID,
        FECHA_EVENTO: memo.value.FECHA_EVENTO,
        EVENTO: memo.value.EVENTO,
        PERSONA: memo.value.PERSONA,
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
        memoDialog.value = false;
        setTimeout(() => {
          tableMEMO.value.obligarRefrescar();
        }, 200);
      }
    });
};
//end region

//region Hooks
onMounted(() => {
  USUARIO.value = SeguridadStore.getUsuario.USUARIO;
});
//end region

//region Computed
const whereMEMO = computed(() => {
  let cond = ` 1 = 2 `;
  if (USUARIO.value) {
    cond = ` USUARIO_REGISTRO = '${USUARIO.value}'`;

    if (filtro.value.FECHA_INICIAL) {
      cond += ` AND FECHA_EVENTO>= '${getFechaCorta(
        filtro.value.FECHA_INICIAL
      )}'`;
    }
    if (filtro.value.FECHA_FINAL) {
      cond += ` AND FECHA_EVENTO<= '${getFechaCorta(
        filtro.value.FECHA_FINAL
      )}'`;
    }
  }
  return cond;
});
//end region
//region Watch

watch(whereMEMO, (newWhere, oldWhere) => {
  setTimeout(() => {
    tableMEMO.value?.obligarRefrescar();
  }, 100);
});
//end region
</script>
