<template>
  <q-table
    v-if="columns.length"
    :rows="rows"
    :columns="columns"
    :row-key="row_key"
    v-model:pagination="pagination"
    :loading="loading"
    :filter="filter"
    :dense="dense"
    @request="onRequest"
    binary-state-sort
    :rows-per-page-options="rows_per_page_options"
    :flat="flat"
  >
    <template v-slot:top-left>
      <div class="row">
        <div
          class="text-h5 q-mx-sm text-weight-light text-primary"
          v-if="titulo"
        >
          {{ titulo }}
        </div>
        <div v-if="!sinBuscador && !titulo">
          <q-input
            v-if="!sinBuscador"
            v-model="filter"
            :color="color ? color : 'primary'"
            :placeholder="$t('inputs.search_label')"
            debounce="300"
            clearable
            dense
            lazy
            outlined
            autofocus
          >
            <template v-slot:append>
              <q-icon
                @click="obligarRefrescar"
                name="search"
                style="cursor: pointer"
              />
            </template>
          </q-input>
        </div>
        <q-btn
          color="primary"
          icon="check"
          label="Elegir"
          @click="onSeleccionar()"
          v-if="selection && selected1.length > 0"
          rounded
          dense
          class="q-mt-xs"
        />
        <slot name="seccion_superior_izquierda"></slot>
      </div>
    </template>
    <template v-slot:top-right>
      <slot name="botones_superiores"></slot>
      <q-btn
        v-if="permiteExportarExcel"
        @click="exportarExcel()"
        color="green-10"
        icon="fa-solid fa-file-excel"
        round
      >
        <q-tooltip
          class="bg-green-10 text-body2"
          transition-show="flip-right"
          transition-hide="flip-left"
          :offset="[10, 10]"
        >
          <span>Exportar</span>
        </q-tooltip>
      </q-btn>
      &nbsp; &nbsp; &nbsp;
      <q-input
        v-if="!sinBuscador && titulo"
        borderless
        dense
        debounce="300"
        v-model="filter"
        outlined
        :placeholder="$t('inputs.search_label')"
        :color="color ? color : 'primary'"
        clearable
        autofocus
      >
        <template v-slot:append>
          <q-icon
            name="search"
            class="cursor-pointer"
            @click="obligarRefrescar(filter)"
          />
        </template>
      </q-input>
    </template>
    <template v-slot:body="props">
      <q-tr
        :props="props"
        :class="
          props.key == marcado ? `bg-${colorSelect || 'grey-4'}` : `bg-none`
        "
      >
        <q-td
          v-if="selection"
          auto-width
          align="center"
          @click="props.selected = true"
        >
          <q-checkbox v-model="props.selected" color="primary" dense />
        </q-td>
        <q-td
          v-for="col in props.cols"
          :key="col.name"
          :class="col.class"
          :props="props"
          auto-width
        >
          <q-icon
            v-if="col.icon && typeof col.icon === 'function'"
            :name="`${col.icon(props.row)}`"
            :color="`${
              col.color && typeof col.color === 'function'
                ? col.color(props.row)
                : 'primary'
            }`"
            style="font-size: 13px"
            class="cursor-pointer q-mr-xs"
            @click="select_row(this, props.row)"
          />
          <q-icon
            :name="col.tooltip.icon"
            class="cursor-pointer"
            :class="`text-${col.tooltip.color}`"
            v-if="
              col.tooltip &&
              props.row[col.name] &&
              props.row[col.name].length > 0
            "
          >
            <q-popup-proxy :ref="`tt_${props.key}_${col.name}`">
              <q-banner
                inline-actions
                rounded
                :class="`bg-${col.tooltip.bg_color} text-black`"
                transition-show="flip-up"
                transition-hide="flip-down"
              >
                <template v-slot:avatar>
                  <q-icon :name="col.tooltip.icon" :color="col.tooltip.color" />
                </template>
                <span v-html="props.row[col.name]"></span>
                <template v-slot:action>
                  <q-btn
                    :class="`text-${col.tooltip.color}`"
                    flat
                    icon="done"
                    round
                    @click="$refs[`tt_${props.key}_${col.name}`][0].hide()"
                  />
                </template>
              </q-banner>
            </q-popup-proxy>
          </q-icon>
          <q-icon
            v-if="col.icon && props.row.icon"
            :name="`${props.row.icon ? props.row.icon : col.icon}`"
            :class="`${col.color}`"
            style="font-size: 13px"
            class="cursor-pointer q-mr-xs"
            @click="select_row(this, props.row)"
          />

          <!-- {{col.icon}} -->
          <q-icon
            v-if="col.icon2 && props.row.icon2"
            :name="`${props.row.icon2 ? props.row.icon2 : col.icon2}`"
            :class="`${col.color}`"
            style="font-size: 13px"
            class="cursor-pointer q-mr-xs"
            @click="select_row(this, props.row)"
          />

          <q-btn
            :color="col.boton.color || 'primary'"
            :size="col.boton.size || 'xs'"
            :icon="col.boton.icon"
            dense
            :label="col.boton.label"
            @click="emitDynamic(col.boton.emit, props.row)"
            :round="!col.boton.label"
            :flat="col.boton.flat"
            v-if="col.boton"
            :disable="col.value ? (col.value === 'NO' ? true : false) : false"
          >
            <q-tooltip
              v-if="col.boton.tooltipText"
              :content-class="col.boton.tooltipClass || 'bg-blue-6'"
              :offset="[10, -30]"
              self="bottom middle"
            >
              {{ col.boton.tooltipText }}
            </q-tooltip>
          </q-btn>
          <!-- Sólo para edad y sexo, en las columnas debe ir de la siguiente manera:
                 format: val => `${val.SEXO.substring(0,1) || ''} ${val.EDAD}`, en el select COALESCE(AFI.SEXO,'')SEXO  -->
          <span v-if="col.genIcon">
            <q-icon
              :name="
                col.value.substring(0, 1) === 'F'
                  ? 'fas fa-venus'
                  : col.value.substring(0, 1) === 'M'
                  ? 'fas fa-mars'
                  : col.value === '1'
                  ? 'check'
                  : 'help_outline'
              "
              :color="
                col.value.substring(0, 1) === 'F'
                  ? 'purple-11'
                  : col.value.substring(0, 1) === 'M'
                  ? 'blue'
                  : 'green'
              "
            />
            {{ col.value.substring(0, 10) }}
          </span>
          <span
            v-else
            class="cursor-pointer"
            @click="select_row(this, props.row)"
            >{{ col.value }}</span
          >
        </q-td>
      </q-tr>
    </template>
  </q-table>
</template>

<script setup>
//#region IMPORTS
import { uid, useQuasar } from "quasar";
import { useAppStore } from "src/stores/app";
import { ref, onMounted, computed, useAttrs } from "vue";
// import * as XLSX from "xlsx";
//#endregion

//#region DATA
const rows = ref([]);
const dialog_formulario = ref(false);
const filter = ref("");
const loading = ref(false);
const pagination = ref({
  // sortBy: props.row_key,
  descending: false,
  page: 1,
  rowsPerPage: 3,
  rowsNumber: 10,
});
const selected1 = ref([]);
const selected = ref([]);
const marcado = ref(null);
const appStore = useAppStore();
const attrs = useAttrs();
const $q = useQuasar();
//#endregion

//#region COMPUTED
const columns = computed(() => {
  return props.columnas || [];
});
const model = computed({
  get() {
    return props.modelValue;
  },
  set(value) {
    emit("update:modelValue", value);
  },
});
//#endregion

//#region PROPS
const props = defineProps({
  titulo: {
    type: String,
  },
  tabla: {
    type: String,
    required: true,
  },
  row_key: {
    type: String,
    required: true,
  },
  columnas: {
    type: Array,
    required: true,
  },
  selection: {
    type: String,
  },
  ordenarPor: {
    type: String,
  },
  inner_join: {
    type: String,
  },
  left_join: {
    type: String,
  },
  columnas_visibles: {
    type: String,
  },
  condicion_adicional: {
    type: String,
  },
  columnas_filtro: {
    type: String,
  },
  rowsPerPage: {
    type: Number,
  },
  color: {
    type: String,
  },
  ordenarPor: {
    type: String,
  },
  colorSelect: {
    type: String,
  },
  dense: {
    type: Boolean,
    default: false,
  },
  sinBuscador: {
    type: Boolean,
  },
  permiteExportarExcel: {
    type: Boolean,
  },
  nombreExcel: {
    type: String,
    default: "",
  },
  rows_per_page_options: {
    type: Array,
    default: () => [3, 5, 7, 10, 15, 20, 25, 50, 100],
  },
  modelValue: {},
  flat: {
    type: Boolean,
    default: false,
  },
});
//#endregion

//#region EMITS
const emit = defineEmits([
  "seleccionar-multiple",
  "onRequestCompleted",
  "onConfirmForm",
  "onConfirmDelete",
  "fila",
  "evento_generico",
  "update:modelValue",
]);
//#endregion

//#region HOOKS
onMounted(() => {
  // get initial data from server (1st page)
  if (props.rowsPerPage) {
    pagination.value.rowsPerPage = props.rowsPerPage;
  }
  obligarRefrescar();
});
//#endregion

//#region METHODS
function onRequest(params) {
  const { page, rowsPerPage, sortBy, descending } = params.pagination;
  let filter = params?.filter;

  if (typeof filter === "object") filter = "";

  if (filter && filter.length > 0) {
    filter = filter.replace(/Ñ/g, "_").replace(/ñ/g, "_"); // Reemplaza Ñ por _
    filter = filter.replace(/ /g, "%"); // Reemplaza espacios por %
  }

  var ordenarPor = sortBy ? sortBy + (descending ? " DESC" : "") : undefined;
  if (!ordenarPor && props.ordenarPor) {
    ordenarPor = props.ordenarPor;
  }

  const parametros = {
    Tabla: props.tabla,
    NumPagina: page,
    TamPagina: rowsPerPage <= 0 ? 4 : rowsPerPage,
    StringABuscar: filter ? filter : undefined,
    OrdenarPor: ordenarPor,
    InnerJoin: props.inner_join,
    LeftJoin: props.left_join,
    ColumnasVisibles: props.columnas_visibles,
    CondicionAdicional: props.condicion_adicional,
    ColumnasFiltro: props.columnas_filtro,
  };
  // turn on loading indicator
  loading.value = true;
  appStore
    .read(parametros)
    .then((res) => {
      const filas = res.data.result.recordset;
      const output = res.data.result.output;

      // update rowsCount with appropriate value
      pagination.value.rowsNumber = output ? output.TotalRegistros : 0;

      // clear out existing data and add new
      rows.value = filas;
      // rows.value.splice(0, rows.value.length, filas);

      // don't forget to update local pagination object
      pagination.value.page = page;
      pagination.value.rowsPerPage = rowsPerPage;
      pagination.value.sortBy = sortBy;
      pagination.value.descending = descending;
    })
    .finally(() => {
      // ...and turn of loading indicator
      loading.value = false;

      if (attrs.onRequestCompleted) emit("onRequestCompleted");
    });
}
function onSeleccionar() {
  if (attrs["seleccionar-multiple"]) emit("seleccionar-multiple", selected1);
}
const obligarRefrescar = (filter) => {
  onRequest({
    pagination: pagination.value,
    filter,
  });
};
const refresh = () => {
  reload();
};
const reload = () => {
  onRequest({
    pagination: pagination.value,
  });
};
function onConfirmForm() {
  if (attrs.onConfirmForm) emit("onConfirmForm");
}
function onDelete() {
  if (attrs.onConfirmDelete) emit("onConfirmDelete");
}
function onReset() {
  selected.value = [];
  this.dialog_formulario = false;
}
function select_row(evt, row) {
  model.value = row;
  if (selected.value === row) {
    setTimeout(() => {
      selected.value = null;
      marcado.value = null;
      emit("fila", null);
    }, 100);
  } else {
    selected.value = row;
    emit("fila", row);
    var mar = row[`${props.row_key.trim()}`];
    if (mar) {
      marcado.value = mar.toString().trim();
    }
  }
}
function getUid() {
  return uid();
}
// function exportarExcel() {
// const { page, rowsPerPage, sortBy, descending } = pagination.value;
// const filter = undefined;

// var ordenarPor = sortBy ? sortBy + (descending ? " DESC" : "") : undefined;
// if (!ordenarPor && props.ordenarPor) {
//   ordenarPor = props.ordenarPor;
// }

// const parametros = {
//   Tabla: props.tabla,
//   NumPagina: page,
//   TamPagina: 214748364,
//   StringABuscar: filter ? filter.replace(/Ñ/g, "_").replace(/ñ/g, "_") : null,
//   OrdenarPor: ordenarPor,
//   InnerJoin: props.inner_join,
//   LeftJoin: props.left_join,
//   ColumnasVisibles: props.columnas_visibles,
//   CondicionAdicional: props.condicion_adicional,
//   ColumnasFiltro: props.columnas_filtro,
// };

// $q.loading.show();
// appStore
//   .read(parametros)
//   .then((res) => {
//     var filas = res.data.result.recordset;

//     const xlsx = XLSX;

//     var datos = filas;
//     let workbook = xlsx.utils.book_new();
//     xlsx.utils.book_append_sheet(
//       workbook,
//       xlsx.utils.json_to_sheet(datos),
//       "Datos"
//     );
//     xlsx.writeFile(
//       workbook,
//       props.nombreExcel === "" ? `Descarga.xlsx` : props.nombreExcel
//     );
//   })
//   .finally(() => {
//     $q.loading.hide();
//   });
// }

function emitDynamic(evento, data) {
  const eventoData = { evento };
  if (data) eventoData.data = data;
  emit("evento_generico", eventoData);
}
//#endregion
defineExpose({
  obligarRefrescar,
  filter,
  onReset,
  reload,
  refresh,
});
</script>
