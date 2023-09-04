<template>
  <div class="eye-catching-container">
    <div class="title-container">
      <h1>ChatGPTの使い方を共有しよう</h1>
    </div>
    <div class="img-container">
      <v-img :src="require('@/assets/images/sample_images/prompthub.jpeg')" alt="Prompthub" class="custom-img"></v-img>
    </div>
  </div>
</template>

<script>
export default {
}
</script>

<style>
.eye-catching-container {
  position: relative;
  background-color: #D6D2E0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  min-height: 400px;
}

.title-container {
  width: 70% !important;
  margin-right: 20px;
}

.img-container {
  width: 30% !important;
}

.custom-img {
}
</style>
