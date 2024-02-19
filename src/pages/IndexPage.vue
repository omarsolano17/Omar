<template>
  <q-page>
    <div class="row q-col-gutter-xs">
      <div class="col-12">
        <!-- <q-card flat> -->
        <q-item v-if="false">
          <q-item-section avatar class="large-screen-only">
            <q-icon name="home"></q-icon>
          </q-item-section>
          <q-item-section side>
            <q-input
              filled
              v-model="filter"
              dense
              label="Buscar"
              ref="buscarRef"
            >
              <template v-slot:append>
                <q-icon
                  v-if="filter !== ''"
                  name="close"
                  @click="filter = ''"
                  class="cursor-pointer"
                />
                <q-icon name="search" />
              </template>
            </q-input>
          </q-item-section>
        </q-item>
        <q-separator />
        <!-- {{menus}} -->
        <q-card-section
          v-show="menus.length > 0"
          flat
          class="q-pa-none q-ma-none"
        >
          <q-item dense class="q-px-xs q-py-xs q-ma-none">
            <q-item-section v-if="true">
              <div class="row q-col-gutter-lg q-pa-none q-ma-none">
                <q-item
                  clickable
                  :to="{ name: item.to }"
                  class="col-lg-3 col-md-3 col-xs-6 col-sm-4 q-pa-none q-ma-none"
                  v-for="(item, i) in menus"
                  :key="i"
                >
                  <q-item-section avatar>
                    <q-avatar
                      rounded
                      color="blue-6"
                      text-color="white"
                      :icon="item.icon"
                    />
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>{{ item.title }}</q-item-label>
                    <q-item-label caption>
                      {{ item.caption }}
                    </q-item-label>
                  </q-item-section>
                </q-item>
              </div>
            </q-item-section>
          </q-item>
        </q-card-section>
        <!-- </q-card> -->
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { useAppStore } from "stores/app";

const appStore = useAppStore();
const filter = ref("");
const buscarRef = ref(null);
onMounted(() => {
  setTimeout(() => {
    buscarRef.value.focus();
  }, 300);
});
const menus = computed(() => {
  let menus = appStore.getMenu;
  if (!menus) return [];
  if (filter.value && filter.value !== "") {
    menus = menus.filter(
      (x) =>
        x.title.toLowerCase().indexOf(filter.value.toLowerCase()) !== -1 ||
        x.caption.toLowerCase().indexOf(filter.value.toLowerCase()) !== -1
    );
  }
  return menus;
});
</script>
