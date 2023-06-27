<template>
  <div>
    <v-app-bar
      color="rgb(52,53,65)"
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
