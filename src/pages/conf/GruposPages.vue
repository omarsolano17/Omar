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
      ></ServerSideTableComponent>
      <ServerSideTableComponent
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
      ></ServerSideTableComponent>
      <q-select
        filled
        bottom-slots
        v-model="model"
        :options="options"
        label="Label"
        counter
        maxlength="12"
        :dense="dense"
        :options-dense="denseOpts"
      >
        <template v-slot:before>
          <q-avatar>
            <img src="https://cdn.quasar.dev/img/avatar5.jpg" />
          </q-avatar>
        </template>

        <template v-slot:append>
          <q-icon
            v-if="model !== ''"
            name="close"
            @click.stop.prevent="model = ''"
            class="cursor-pointer"
          />
          <q-icon name="schedule" @click.stop.prevent />
        </template>

        <template v-slot:hint> Field hint </template>

        <template v-slot:after>
          <q-btn round dense flat icon="send" />
        </template>
      </q-select>
      <!-- @fila="onSelect($event)" -->
      <!-- v-show="vista === ''" -->
    </div>
  </q-page>
</template>

<script setup>
//region import
import { computed, onMounted, reactive, ref, watch } from "vue";
// import ServerSideTableComponent  from "src/components/ServerSideTableComponent.vue";
import ServerSideTableComponent from "src/components/ServerSideTableComponent.vue";
import { useSeguridadStore } from "stores/seguridad";
import { useRouter } from "vue-router";
//end region

//region data
const router = useRouter();
const SeguridadStore = useSeguridadStore();
const grupoSel = ref(null);
const tableUSGRUH = ref(null);

const dtUSGRU = ref({
  titulo: "Grupos del sistema",
  tabla: "USGRU",
  row_key: "GRUPO",
  ordenarPor: "GRUPO",
  columnas_visibles: ["USGRU.GRUPO", "USGRU.NOMBRE"].join(","),
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
  console.log("omar:", fila?.GRUPO);
  grupoSel.value = fila?.GRUPO;
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
