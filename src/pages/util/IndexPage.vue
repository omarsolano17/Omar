<template>
  <q-page class="q-pt-xs">
    <div class="row q-col-gutter-sm">
      <div class="col-12">
        <q-card flat>
          <q-item>
            <q-item-section avatar class="large-screen-only">
              <q-avatar>
                <q-icon name="home"></q-icon>
              </q-avatar>
            </q-item-section>
            <q-item-section class="large-screen-only">
              <q-item-label>Central utilidades</q-item-label>
              <q-item-label caption>
                Acceso al modulo de utilidades
              </q-item-label>
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
          <q-card-section v-show="menus.length > 0">
            <q-item dense>
              <q-item-section>
                <div class="row q-col-gutter-lg">
                  <div
                    class="col-lg-3 col-md-3 col-xs-6 col-sm-4"
                    v-for="(item, i) in menus"
                    :key="i"
                  >
                    <q-item clickable :to="{ name: item.to }">
                      <q-item-section avatar>
                        <q-avatar
                          rounded
                          color="blue-grey"
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
                </div>
              </q-item-section>
            </q-item>
          </q-card-section>
        </q-card>
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
  let menus = appStore.getMenuUtilidades;
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
