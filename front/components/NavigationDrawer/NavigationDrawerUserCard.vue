<template>
  <div class="fixed-bottom">
    <v-divider></v-divider>
    <v-list-item>
      <v-list-item-content>
        <v-list-item-title class="text-h5">
          {{ $auth.user.name }}
        </v-list-item-title>
      </v-list-item-content>
      <v-list-item-icon>
        <v-icon>mdi-cog-outline</v-icon>
      </v-list-item-icon>
    </v-list-item>
  </div>
</template>

<style scoped>

.fixed-bottom {
  position: absolute;
  bottom: 0;
  margin-bottom: 20px;
  width: 100%;
}
</style>

<script>
export default {
}
</script>
