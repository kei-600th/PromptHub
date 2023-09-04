<template>
  <div class="eye-catching-container">
    <v-img :src="require('@/assets/images/sample_images/prompthub.jpeg')" alt="Prompthub" class="custom-img centered-img">
      <h1>ChatGPTを共有しよう</h1>
    </v-img>
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
  justify-content: center; /* 中央寄せのために追加 */
  min-height: 400px;
}

.custom-img {
  max-width: 400px;
}

.centered-img {
  width: 80%;
  height: 80%;
  border-radius: 15px;
  margin: auto; /* 中央寄せのために追加 */
}
</style>
