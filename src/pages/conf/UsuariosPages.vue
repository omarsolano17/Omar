<template>
  <q-page class="q-pa-xs">
    <div class="row q-col-gutter-sm">
      <!-- AQUI PAGE
      <q-btn color="blue" @click="onBack" label="OMAR" /> -->
      <ServerSideTableComponent
        ref="tableUSUSUref"
        :titulo="dtUSUSU.titulo"
        :tabla="dtUSUSU.tabla"
        :columnas="dtUSUSU.columnas"
        :row_key="dtUSUSU.row_key"
        :columnas_visibles="dtUSUSU.columnas_visibles"
        :ordenarPor="dtUSUSU.ordenarPor"
        :dense="true"
        condicion_adicional=""
        :columnas_filtro="dtUSUSU.columnas_filtro"
        :inner_join="dtUSUSU.inner_join"
        :left_join="dtUSUSU.left_join"
        :permiteExportar="false"
        :permisoColumnas="false"
        colorSelect="green-2"
        class="col-12"
        flat
        :rows_per_page_options="[5, 10, 25, 50, 100]"
        :rowsPerPage="10"
        @evento_generico="onSelectUsusu($event)"
        @fila="onSelectUsusu($event)"
      >
        <!-- @fila="onSelectUsusu($event)" -->
        <!-- @fila="onSelect($event)" -->
        <template v-slot:seccion_superior_izquierda>
          <q-btn
            color="primary"
            icon="add"
            round
            size="sm"
            @click="onUSUSU('NUEVO')"
          >
            <q-tooltip
              class="bg-primary text-body2"
              transition-show="flip-right"
              transition-hide="flip-left"
              :offset="[10, 10]"
            >
              Agregar Usuario
            </q-tooltip>
          </q-btn>
        </template>
      </ServerSideTableComponent>
    </div>
    {{ optGrupo }}
    <q-dialog v-model="dgUsusu" persistent>
      <q-card style="width: 70%; max-width: 95%">
        <q-bar class="text-white bg-primary">
          <!-- <div>{{ usgru?.METODO }} grupo del sistema {{ usgru?.GRUPO }}</div> -->
          <q-space />
          <q-btn flat icon="close" v-close-popup />
        </q-bar>
        <q-card-section class="row items-center">
          <div class="row col-12">
            <q-input
              dense
              class="q-pa-xs bg-red-2 col-3"
              v-model="ususu.USUARIO"
              type="text"
              label="Usuario"
              :disable="ususu.METODO !== 'INSERTAR'"
            />
            <q-input
              dense
              class="q-pa-xs bg-yellow-2 col-9"
              v-model="ususu.NOMBRE"
              type="text"
              label="Nombre de usuario"
            />
            <q-input
              dense
              class="col-7 q-my-sm shadow-6"
              v-model="ususu.CLAVE"
              :type="typePass"
              label="Clave"
            >
              <template v-slot:append>
                <q-icon
                  :name="
                    typePass === 'password'
                      ? 'fa-regular fa-eye'
                      : 'fa-regular fa-eye-slash'
                  "
                  @click="
                    typePass = typePass === 'password' ? 'text' : 'password'
                  "
                  class="cursor-pointer"
                />
                <!-- class="bg-green text-black" -->
                <q-tooltip :offset="[10, 10]" transition-show="jump-up">
                  {{
                    typePass === "text"
                      ? "Ocultar Contraseña"
                      : "Mostrar Contraseña"
                  }}
                </q-tooltip>
              </template>
            </q-input>
            <q-select
              class="col-4 q-pa-xs"
              v-model="ususu.GRUPO"
              outlined
              dense
              emit-value
              map-options
              :options="optGrupo"
              clr
              label="Grupo"
            />
            <!-- ususu.grupo.value -->

            <!-- <q-select v-model="ususu.GRUPO" dense :options="optGrupo"> -->
            <!-- </q-select> -->
          </div>
          {{ ususu }}
          <!-- @todo Usuario arriba -->
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cancelar" color="secondary" v-close-popup />
          <q-btn
            flat
            :label="ususu?.METODO?.toLowerCase()"
            color="primary"
            @click="onUSUSU(ususu?.METODO)"
          />
        </q-card-actions>
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
import { useAppStore } from "stores/app";
import { useRouter } from "vue-router";
//end region

//region data
const router = useRouter();
const SeguridadStore = useSeguridadStore();
const appStore = useAppStore();
const usuarioSelected = ref(null);
const ususu = ref({});
const optGrupo = ref([]);
const dgUsusu = ref(false);
const typePass = ref(null);
const tableUSUSUref = ref(null);

const dtUSUSU = ref({
  titulo: "Usuarios del sistema",
  tabla: "USUSU",
  row_key: "USUARIO",
  ordenarPor: "USUARIO",
  columnas_visibles: `USUSU.USUARIO, USUSU.NOMBRE, dbo.FNK_DESCIFRAR(USUSU.GRUPO) AS GRUPO, USGRU.NOMBRE NOMBRE_GRUPO, USUSU.ESTADO, USUSU.SYS_ComputerName,
                    USUSU.IDSEDE, USUSU.CELULAR, USUSU.CARGO, USUSU.EMAIL`,
  inner_join: " USGRU ON dbo.FNK_DESCIFRAR(USUSU.GRUPO) = USGRU.GRUPO",
  columnas: [
    {
      name: "BtnEditar",
      boton: {
        icon: "edit",
        emit: "UPDATE",
        color: "green",
        flat: false,
        tooltipText: "Editar usuario",
        tooltipClass: "info",
      },
    },

    {
      name: "USUARIO",
      required: true,
      label: "Usuario",
      align: "left",
      field: (row) => row.USUARIO,
      format: (val) => val,
      sortable: true,
    },
    {
      name: "NOMBRE",
      required: true,
      label: "Nombre usuario",
      align: "left",
      field: (row) => row.NOMBRE,
      format: (val) => val,
      sortable: true,
    },
    {
      name: "NOMBRE_GRUPO",
      required: true,
      label: "Grupo",
      align: "left",
      field: (row) => row.NOMBRE_GRUPO,
      format: (val) => val,
      sortable: true,
    },
  ],
  columnas_filtro: ["USUSU.USUARIO", "USUSU.NOMBRE"].join(","),
});

//end

// //region methods
const onSelectUsusu = (fila) => {
  console.log("esta es la fila", fila);
};

const onUSUSU = (metodo, fila) => {
  if (metodo === "NUEVO") {
    ususu.value = {};
    ususu.value.METODO = "INSERTAR";
    dgUsusu.value = true;
  }
};

// const onSelect = (fila) => {
//   console.log(fila);
//   grupoSel.value = fila.GRUPO;
//   console.log(grupoSel.value);
// };
// const onEventoGenerico = (fila) => {
//   let e = { ...fila };
//   switch (e.evento) {
//     case "UPDATE":
//       onUSGRU(e.evento, e.data);
//       break;
//     case "DELETE":
//       onUSGRU(e.evento, e.data);
//       break;
//   }
// };
// const onUSGRU = (metodo, fila) => {
//   console.log(metodo);
//   console.log(fila);
//   if (metodo === "NUEVO") {
//     usgru.value = {};
//     usgru.value.METODO = "INSERTAR";
//     dgUSGRU.value = true;
//   } else if (metodo === "UPDATE" || metodo === "DELETE") {
//     usgru.value.METODO = metodo === "UPDATE" ? "EDITAR" : "ELIMINAR";
//     usgru.value.GRUPO = fila.GRUPO;
//     usgru.value.NOMBRE = fila.NOMBRE;
//     dgUSGRU.value = true;
//   } else if (
//     metodo === "INSERTAR" ||
//     metodo === "EDITAR" ||
//     metodo === "ELIMINAR"
//   ) {
//     const parametros = {
//       MODELO: "USGRU",
//       METODO: metodo,
//       PARAMETROS: {
//         GRUPO: usgru.value.GRUPO,
//         DESCRIPCION: usgru.value.NOMBRE,
//       },
//     };
//     appStore.json(parametros).then((res) => {
//       console.log(res);
//       if (res?.data?.result?.recordsets[0][0]?.OK === "OK") {
//         dgUSGRU.value = false;
//         tableUSGRU.value.obligarRefrescar();
//       }
//     });
//   }
// };
// //end region

// //region Computed
// const whereUSGRUH = computed(() => {
//   let cond = null;
//   if (!grupoSel.value) {
//     cond = ` 1 = 2 `;
//   } else {
//     cond = ` USGRUH.GRUPO = '${grupoSel.value}'`;
//   }
//   return cond;
// });
// const titulo = computed(() => {
//   let cond = null;
//   if (!grupoSel.value) {
//     cond = ``;
//   } else {
//     cond = ` Permisos del grupo ${grupoSel.value}`;
//   }
//   return cond;
// });
//end region
//region Watch

// watch(whereUSGRUH, (newWhere, oldWhere) => {
//   setTimeout(() => {
//     tableUSGRUH.value?.obligarRefrescar();
//   }, 100);
// });
//end region
// {
//   nombre: "omar",
//   apellido: "solano",
// }
//#region Hooks
onMounted(() => {
  appStore
    .json({
      MODELO: "SEL",
      METODO: "USGRU",
      PARAMETROS: { WHERE: "" },
    })
    .then((res) => {
      if (res.data.result.recordsets[0][0].OK === "OK")
        optGrupo.value = res.data.result.recordsets[1];
    });
});
//#endregion
</script>
