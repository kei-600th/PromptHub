<template>
  <div>
    <v-card-title class="text-h4">
      <v-text-field
        v-model="title"
        label="タイトルを入力"
      ></v-text-field>
    </v-card-title>
    <v-card-subtitle class="ma-1 text-h6">
      <v-textarea
        v-model="description"
        rows="2"
        label="説明文を入力"
      ></v-textarea>
    </v-card-subtitle>
  </div>
</template>

<script>
export default {
  props: ['title', 'description'],
  data() {
    return {
    };
  },
  watch: {
    title: {
      handler(val) {
        this.$emit('updateTitle', val);
      },
      immediate: true,
    },
    description: {
      handler(val) {
        this.$emit('updateDescription', val);
      },
      immediate: true,
    },
  },
};
</script>
