<template>
  <div>
    <v-card-title class="text-h4">
      {{ sample.title }}
    </v-card-title>
    <v-row>
      <v-chip class="ma-2" color="primary">
        {{ sample.prompts[0].gpt_model }}
      </v-chip>
      <v-chip class="ma-2" color="primary">
        {{ sample.category.name }}
      </v-chip>
      <v-spacer></v-spacer>
      <div class="ma-2">
        <v-icon>mdi-heart</v-icon>
      </div>
    </v-row>
    <v-card-subtitle class="text-h6 my-2">
      {{ sample.description }}
    </v-card-subtitle>
  </div>
</template>

<script>
export default {
  props: {
    sample: {
      type: Object,
      required: true,
    },
  },
};
</script>
