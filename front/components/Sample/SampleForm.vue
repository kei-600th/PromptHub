<template>
  <div>
    <v-card-title class="text-h4">
      <v-text-field v-model="localTitle" label="タイトルを入力"></v-text-field>
    </v-card-title>
    <v-card-subtitle class="ma-1 text-h6">
      <v-textarea
        v-model="localDescription"
        rows="2"
        label="説明文を入力"
      ></v-textarea>
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
  },
  data() {
    return {
      localTitle: this.title,
      localDescription: this.description,
    };
  },
  watch: {
    localTitle: function (newTitle) {
      this.$emit('updateTitle', newTitle);
    },
    localDescription: function (newDescription) {
      this.$emit('updateDescription', newDescription);
    },
  },
};
</script>
