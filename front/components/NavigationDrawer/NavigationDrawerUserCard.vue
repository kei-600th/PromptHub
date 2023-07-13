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
        <v-menu offset-y>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
            dark
            icon
            v-bind="attrs"
            v-on="on"
            >
              <v-icon>mdi-cog-outline</v-icon>
            </v-btn>
          </template>
          <v-list>
            <v-list-item
              v-for="(item, index) in items"
              :key="index"
            >
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
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
  data: () => ({
    items: [
      { title: 'Click Me' },
      { title: 'Click Me' },
      { title: 'Click Me' },
      { title: 'Click Me 2' }
    ]
  })
}
</script>
