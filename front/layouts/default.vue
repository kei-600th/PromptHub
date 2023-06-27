<template>
  <v-app>
    <app-bar
    >
      <template
        v-slot:navigation-toggle-button
      >
        <v-app-bar-nav-icon @click="drawer = !drawer" />
      </template>
    </app-bar>
    <navigation-drawer 
      :drawer.sync="drawer"
    />
    <v-main>
      <nuxt />
    </v-main>
  </v-app>
</template>

<script>
export default {
  data () {
    return {
      drawer: null
    }
  }
}
</script>
