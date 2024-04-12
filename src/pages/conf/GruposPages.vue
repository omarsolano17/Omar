<template>
  <q-page class="q-pa-xs">
    <div class="row q-col-gutter-sm">
      <!-- AQUI PAGE
      <q-btn color="blue" @click="onBack" label="OMAR" /> -->
      <ServerSideTableComponent
        ref="tableUSGRU"
        :titulo="dtUSGRU.titulo"
        :tabla="dtUSGRU.tabla"
        :columnas="dtUSGRU.columnas"
        :row_key="dtUSGRU.row_key"
        :columnas_visibles="dtUSGRU.columnas_visibles"
        :ordenarPor="dtUSGRU.ordenarPor"
        @fila="onSelect($event)"
        @evento_generico="onEventoGenerico($event)"
        :dense="true"
        :condicion_adicional="where"
        :columnas_filtro="dtUSGRU.columnas_filtro"
        :inner_join="dtUSGRU.inner_join"
        :left_join="dtUSGRU.left_join"
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
            size="sm"
            @click="onUSGRU('NUEVO')"
          >
            <q-tooltip
              class="bg-primary text-body2"
              transition-show="flip-right"
              transition-hide="flip-left"
              :offset="[10, 10]"
            >
              Agregar Grupo
            </q-tooltip>
          </q-btn>
        </template>
      </ServerSideTableComponent>
      <!-- <ServerSideTableComponent
        v-if="grupoSel"
        ref="tableUSGRUH"
        :titulo="titulo"
        :tabla="dtUSGRUH.tabla"
        :columnas="dtUSGRUH.columnas"
        :row_key="dtUSGRUH.row_key"
        :columnas_visibles="dtUSGRUH.columnas_visibles"
        :ordenarPor="dtUSGRUH.ordenarPor"
        :dense="true"
        :condicion_adicional="whereUSGRUH"
        :columnas_filtro="dtUSGRUH.columnas_filtro"
        :inner_join="dtUSGRUH.inner_join"
        :left_join="dtUSGRUH.left_join"
        :permiteExportar="false"
        :permisoColumnas="false"
        colorSelect="green-2"
        class="col-12"
        flat
        :rows_per_page_options="[5, 10, 25, 50, 100]"
        :rowsPerPage="10"
      ></ServerSideTableComponent> -->
    </div>
    {{ usgru }}
  </q-page>
  <q-dialog v-model="dgUSGRU" persistent>
    <q-card style="width: 70%; max-width: 95%">
      <q-bar class="text-white bg-primary">
        <div>{{ usgru?.METODO }} grupo del sistema {{ usgru?.GRUPO }}</div>
        <q-space />
        <q-btn flat icon="close" v-close-popup />
      </q-bar>
      <q-card-section class="row items-center">
        <div class="row col-12">
          <q-input
            dense
            class="q-pa-xs bg-red-2 col-3"
            v-model="usgru.GRUPO"
            type="text"
            label="Codigo Grupo"
            :disable="usgru.METODO !== 'INSERTAR'"
          />
          <q-input
            dense
            class="q-pa-xs bg-yellow-2 col-9"
            v-model="usgru.NOMBRE"
            type="text"
            label="Descripcion Grupo"
          />
        </div>
        {{ usgru }}
      </q-card-section>
      <q-card-actions align="right">
        <q-btn flat label="Cancelar" color="secondary" v-close-popup />
        <q-btn
          flat
          :label="usgru?.METODO.toLowerCase()"
          color="primary"
          @click="onUSGRU(usgru?.METODO)"
        />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup>
//region import
import { computed, onMounted, reactive, ref, watch } from "vue";
// import ServerSideTableComponent  from "src/components/ServerSideTableComponent.vue";
import ServerSideTableComponent from "src/components/ServerSideTableComponent.vue";
import { useSeguridadStore } from "stores/seguridad";
import { useAppStore } from "stores/app";
import { useRouter } from "vue-router";
//end region

//region data
const router = useRouter();
const SeguridadStore = useSeguridadStore();
const appStore = useAppStore();
const grupoSel = ref(null);
const usgru = ref({});
const dgUSGRU = ref(false);
const tableUSGRU = ref(null);
const tableUSGRUH = ref(null);

const dtUSGRU = ref({
  titulo: "Grupos del sistema",
  tabla: "USGRU",
  row_key: "GRUPO",
  ordenarPor: "GRUPO",
  columnas_visibles: ["USGRU.GRUPO", "USGRU.NOMBRE"].join(","),
  columnas: [
    {
      name: "BtnEditar",
      boton: {
        icon: "edit",
        emit: "UPDATE",
        color: "green",
        flat: false,
        tooltipText: "Editar Grupo",
        tooltipClass: "info",
      },
    },
    {
      name: "BtnEliminar",
      boton: {
        icon: "delete",
        emit: "DELETE",
        color: "red",
        flat: false,
        tooltipText: "Editar Grupo",
        tooltipClass: "info",
      },
    },

    {
      name: "GRUPO",
      required: true,
      label: "Grupo",
      align: "left",
      field: (row) => row.GRUPO,
      format: (val) => val,
      sortable: true,
    },
    {
      name: "NOMBRE",
      required: true,
      label: "Nombre del grupo",
      align: "left",
      field: (row) => row.NOMBRE,
      format: (val) => val,
      sortable: true,
    },
  ],
  columnas_filtro: ["GRUPO", "NOMBRE"].join(","),
});

const dtUSGRUH = ref({
  titulo: "",
  tabla: "USGRUH",
  row_key: "ID",
  ordenarPor: "GRUPO, IDPROCEDIMIENTO, IDCONTROL",
  columnas_visibles: [
    "ROW_NUMBER() OVER ( ORDER BY GRUPO, IDPROCEDIMIENTO, IDCONTROL) AS ID",
    "USGRUH.GRUPO",
    "USGRUH.IDPROCEDIMIENTO",
    "USGRUH.IDCONTROL",
    "USGRUH.PERMISO",
  ].join(","),
  columnas: [
    {
      name: "GRUPO",
      required: true,
      label: "Grupo",
      align: "left",
      field: (row) => row.GRUPO,
      format: (val) => val,
      sortable: true,
    },
    {
      name: "IDPROCEDIMIENTO",
      required: true,
      label: "Procedimiento",
      align: "left",
      field: (row) => row.IDPROCEDIMIENTO,
      format: (val) => val,
      sortable: true,
    },
    {
      name: "IDCONTROL",
      required: true,
      label: "Control",
      align: "left",
      field: (row) => row.IDCONTROL,
      format: (val) => val,
      sortable: true,
    },
    {
      name: "PERMISO",
      required: true,
      label: "Permiso",
      align: "left",
      field: (row) => row.PERMISO,
      format: (val) => val,
      sortable: true,
    },
  ],
  columnas_filtro: ["GRUPO", "IDPROCEDIMIENTO", "IDCONTROL"].join(","),
});
//end

//region methods
const onBack = () => {
  console.log("se va a salir");
  SeguridadStore.setJWT(null);
  // router.push({ name: "conf" });
};
const onSelect = (fila) => {
  console.log(fila);
  grupoSel.value = fila.GRUPO;
  console.log(grupoSel.value);
};
const onEventoGenerico = (fila) => {
  let e = { ...fila };
  switch (e.evento) {
    case "UPDATE":
      onUSGRU(e.evento, e.data);
      break;
    case "DELETE":
      onUSGRU(e.evento, e.data);
      break;
  }
};
const onUSGRU = (metodo, fila) => {
  console.log(metodo);
  console.log(fila);
  if (metodo === "NUEVO") {
    usgru.value = {};
    usgru.value.METODO = "INSERTAR";
    dgUSGRU.value = true;
  } else if (metodo === "UPDATE" || metodo === "DELETE") {
    usgru.value.METODO = metodo === "UPDATE" ? "EDITAR" : "ELIMINAR";
    usgru.value.GRUPO = fila.GRUPO;
    usgru.value.NOMBRE = fila.NOMBRE;
    dgUSGRU.value = true;
  } else if (
    metodo === "INSERTAR" ||
    metodo === "EDITAR" ||
    metodo === "ELIMINAR"
  ) {
    const parametros = {
      MODELO: "USGRU",
      METODO: metodo,
      PARAMETROS: {
        GRUPO: usgru.value.GRUPO,
        DESCRIPCION: usgru.value.NOMBRE,
      },
    };
    appStore.json(parametros).then((res) => {
      console.log(res);
      if (res?.data?.result?.recordsets[0][0]?.OK === "OK") {
        dgUSGRU.value = false;
        tableUSGRU.value.obligarRefrescar();
      }
    });
  }
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

watch(whereUSGRUH, (newWhere, oldWhere) => {
  setTimeout(() => {
    tableUSGRUH.value?.obligarRefrescar();
  }, 100);
});
//end region
</script>
