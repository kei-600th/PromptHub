<template>
  <div>
    <v-app-bar app :clipped-left="clippedLeft" dark>
      <slot name="navigation-toggle-button" />

      <v-toolbar-title>Prompthub</v-toolbar-title>

      <v-spacer />
      <div v-if="!isLoggedIn">
        <app-bar-signup-button />
        <app-bar-login-button />
      </div>
    </v-app-bar>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
export default {
  props: {
    clippedLeft: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    ...mapGetters(['isLoggedIn']),
  },
};
</script>
