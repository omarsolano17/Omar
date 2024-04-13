<template>
  <q-page class="q-pa-xs">
    <div class="row q-col-gutter-sm">
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
        @evento_generico="onEventoGenerico($event)"
        @fila="onSelectUsusu($event)"
      >
        <template v-slot:seccion_superior_izquierda>
          <q-btn color="primary" icon="add" round size="sm" @click="onUSUSU('NUEVO')">
            <q-tooltip class="bg-primary text-body2" transition-show="flip-right" transition-hide="flip-left" :offset="[10, 10]">
              Agregar Usuario
            </q-tooltip>
          </q-btn>
        </template>
      </ServerSideTableComponent>
    </div>
    <q-dialog v-model="dgUsusu" persistent>
      <q-card style="width: 70%; max-width: 95%">
        <q-bar class="text-white bg-primary">
          <span>{{ ususu?.METODO.charAt(0).toUpperCase() + ususu?.METODO.slice(1).toLowerCase() }} Usuario: {{ ususu?.USUARIO }} - {{ ususu?.NOMBRE }}</span>
          <q-space />

          <q-btn flat icon="close" v-close-popup />
        </q-bar>
        <q-card-section class="row items-center">
          <div class="row col-12">
            <q-input dense class="q-pa-xs col-3" v-model="ususu.USUARIO" type="text" outlined label="Usuario" :disable="ususu.METODO !== 'INSERTAR'"/>
            <q-input dense class="q-pa-xs col-6" v-model="ususu.NOMBRE" type="text" outlined label="Nombre de usuario"/>
            <q-input dense class="col-3 q-pa-xs" v-model="ususu.CLAVE" :type="typePass" outlined label="Clave">
              <template v-slot:append>
                <q-icon class="cursor-pointer" :name=" typePass === 'password' ? 'fa-regular fa-eye' : 'fa-regular fa-eye-slash'"
                  @click="typePass = typePass === 'password' ? 'text' : 'password'" />
                <q-tooltip :offset="[10, 10]" transition-show="jump-up">
                  {{ typePass === "text" ? "Ocultar Contraseña" : "Mostrar Contraseña"}}
                </q-tooltip>
              </template>
            </q-input>
            <q-select class="col-4 q-pa-xs" v-model="ususu.GRUPO" outlined dense emit-value map-options :options="opt.grupo" clr label="Grupo"/>
            <q-select class="col-4 q-pa-xs" v-model="ususu.IDSEDE" outlined dense emit-value map-options :options="opt.sede" clr label="Sede"/>
            <q-select class="col-4 q-pa-xs" v-model="ususu.SYS_ComputerName" outlined dense emit-value map-options :options="opt.computername" clr label="ComputerName"/>
            <q-select class="col-2 q-pa-xs" v-model="ususu.ESTADO" outlined dense emit-value map-options :options="opt.estado" clr label="Estado"/>
            <q-input  class="q-pa-xs col-3" v-model="ususu.CARGO" outlined dense type="text" label="Cargo"/>
            <q-input  class="q-pa-xs col-2" v-model="ususu.CELULAR" outlined dense type="number" label="Celular" :maxlength="10"
              :rules="[(val) => (+val?.length === 10 && val?.toString()?.substring(0, 1) == '3') || 'Numero de celular incorrecto',]"/>
            <q-input  class="q-pa-xs col-5" v-model="ususu.EMAIL" outlined dense type="email" label="Correo" :lazy-rules="true" :reactive-rules="true"/>
          </div>
          {{ ususu }}
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cancelar" color="secondary" v-close-popup />
          <q-btn flat :label="ususu?.METODO?.toLowerCase()" color="primary" @click="onUSUSU(ususu?.METODO)"/>
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
const opt = ref({
  estado: [
    { value: "Activo", label: "Activo" },
    { value: "Inactivo", label: "Inactivo" },
  ],
  grupo: [],
  sede: [],
  computername: [],
});
const dgUsusu = ref(false);
const typePass = ref('password');
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
    {name: "BtnEditar", boton: {icon: "edit", emit: "UPDATE",color: "green",flat: false,tooltipText: "Editar usuario",tooltipClass: "info"}},
    {name: "USUARIO", required: true, label: "Usuario", align: "left", field: (row) => row.USUARIO, format: (val) => val, sortable: true},
    {name: "NOMBRE", required: true, label: "Nombre usuario", align: "left", field: (row) => row.NOMBRE, format: (val) => val, sortable: true},
    {name: "NOMBRE_GRUPO", required: true,label: "Grupo",align: "left",field: (row) => row.NOMBRE_GRUPO, format: (val) => val, sortable: true},
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
    ususu.value.ESTADO = "Activo";
    dgUsusu.value = true;
  } else if (metodo === "UPDATE") {
    ususu.value = { ...fila };
    ususu.value.METODO = "EDITAR";
    dgUsusu.value = true;
  } else if (metodo === "INSERTAR" || metodo === "EDITAR") {
    appStore
      .json({
        MODELO: "USUSU",
        METODO: metodo,
        PARAMETROS: { USUSU: ususu.value },
      })
      .then((res) => {
        if (res.data.result.recordsets[0][0].OK === "OK") {
          ususu.value = null;
          dgUsusu.value = false;
          tableUSUSUref.value.obligarRefrescar();
        }
      });
  }
};

const onEventoGenerico = (fila) => {
  let e = { ...fila };
  switch (e.evento) {
    case "UPDATE":
      onUSUSU(e.evento, e.data);
      break;
    case "DELETE":
      onUSUSU(e.evento, e.data);
      break;
  }
};
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
      opt.value.grupo = res.data.result.recordsets[0];
    });
  appStore
    .json({
      MODELO: "SEL",
      METODO: "SED",
      PARAMETROS: { WHERE: "" },
    })
    .then((res) => {
      opt.value.sede = res.data.result.recordsets[0];
    });
  appStore
    .json({
      MODELO: "SEL",
      METODO: "UBEQ",
      PARAMETROS: { WHERE: "" },
    })
    .then((res) => {
      opt.value.computername = res.data.result.recordsets[0];
    });
});
//#endregion
</script>
