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
    <v-card-subtitle class="ma-1">
      <v-select
        v-model="localCategoryId"
        :items="options"
        item-text="name"
        item-value="id"
        label="カテゴリを選択"
        style="max-width: 200px;"
      ></v-select>
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
    categoryId: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      localTitle: this.title,
      localDescription: this.description,
      localCategoryId: this.categoryId,
      options: [
        {id:1, name:"PC・プログラミング"},
        {id:2, name:"語学"},
        {id:3, name:"ビジネス"},
        {id:4, name:"メンタルケア"},
        {id:5, name:"学術"},
        {id:6, name:"暮らし・生活"},
        {id:7, name:"作品・エンタメ"},
        {id:8, name:"デザイン・Web制作"}
      ]
    };
  },
  watch: {
    localTitle: function (newTitle) {
      this.$emit('updateTitle', newTitle);
    },
    localDescription: function (newDescription) {
      this.$emit('updateDescription', newDescription);
    },
    localCategoryId: function (newCategoryId) {
      this.$emit('updateCategory', newCategoryId);
    },
  },
};
</script>
