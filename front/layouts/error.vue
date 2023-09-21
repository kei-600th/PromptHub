<template>
  <div class="error-page">
    <div v-if="error.statusCode === 404" class="error-content">
      <h1 class="error-title">404 Not Found</h1>
      <p class="error-text">お探しのページは見つかりませんでした</p>
    </div>
    <div v-else class="error-content">
      <h1 class="error-title">エラーが発生しました</h1>
      <p class="error-text">{{ error.message }}</p>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    error: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style scoped>
.error-content {
  margin-top: 50px;
  text-align: center;
}
.error-text {
  margin-top: 30px;
}
</style>
