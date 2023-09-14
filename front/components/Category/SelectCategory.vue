<template>
  <v-select
    v-model="localCategoryId"
    :items="categories"
    item-text="name"
    item-value="id"
    label="カテゴリを選択"
    style="max-width: 200px"
  ></v-select>
</template>

<script>
export default {
  props: {
    categoryId: {
      type: [Number, null],
      default: null,
    },
    categories: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      localCategoryId: this.categoryId,
    };
  },
  watch: {
    localCategoryId: function (newCategoryId) {
      this.$emit('updateCategory', newCategoryId);
    },
  },
};
</script>
