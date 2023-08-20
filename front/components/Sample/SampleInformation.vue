<template>
  <div>
    <v-card-title class="text-h4">
      {{ title }}
    </v-card-title>
    <v-chip class="ma-2" color="primary">
      {{ categoryName }}
    </v-chip>
    <v-card-subtitle class="text-h6 my-2">
      {{ description }}
    </v-card-subtitle>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    categoryName: {
      type: String,
      required: true,
    },
  },
};
</script>
