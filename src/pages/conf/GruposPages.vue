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
//end

//region methods
const onBack = () => {
  console.log("se va a salir");
  SeguridadStore.setJWT(null);
  // router.push({ name: "conf" });
};
const onSelect = (fila) => {
  console.log("omar:", fila?.GRUPO);
};
//end region
</script>
