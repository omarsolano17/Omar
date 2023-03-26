<template>
  <q-layout>
    <!-- Be sure to play with the Layout demo on docs -->
    <q-page-container>
      <!-- This is where pages get injected -->
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { setCssVar } from "quasar";
export default {
  name: "SeguridadLayout",
  created() {
    setCssVar("primary", "#1976D2");
    setCssVar("secondary", "#26A69A");
  },
};
</script>
