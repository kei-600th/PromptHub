<template>
  <div>
    <v-app-bar
      app
      :clipped-left="clippedLeft"
      dark
    >
      <slot name="navigation-toggle-button" />

      <v-toolbar-title>Prompthub</v-toolbar-title>

      <v-spacer></v-spacer>

      <app-bar-signup-button />
      <app-bar-login-button />
    </v-app-bar>
  </div>
</template>

<script>
export default {
  props: {
    clippedLeft: {
      type: Boolean,
      default: false
    }
  },
}
</script>