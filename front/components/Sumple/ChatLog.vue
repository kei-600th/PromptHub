<template>
  <div>
    <v-divider class="mx-4"></v-divider>
    <v-card-title>
      <v-icon
        large
        left
      >
        mdi-account
      </v-icon>
      <span class="text-h6 font-weight-light">You</span>
    </v-card-title>

    <v-card-text class="text-h5">
      {{ requestText }}
    </v-card-text>
    <v-divider class="mx-4"></v-divider>
    <v-card-title>
      <v-icon
        large
        left
      >
        mdi-robot
      </v-icon>
      <span class="text-h6 font-weight-light">ChatGPT</span>
    </v-card-title>

    <v-card-text class="text-h5">
      {{ responseText }}
    </v-card-text>
    <v-divider class="mx-4"></v-divider>
  </div>
</template>

<script>
export default {
  props: ['requestText', 'responseText']
}
</script>
