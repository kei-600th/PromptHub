<template>
  <div>
    <!-- PC用の表示 -->
    <div v-if="!isMobileBreakpointLessThan">
      <div class="eye-catching-container">
        <div>
          <h1>ChatGPTの使い方を広げよう</h1>
        </div>
        <div>
          <v-img
            :src="require('@/assets/images/introduce/prompthub.jpeg')"
            alt="Prompthub"
            class="eye-catching-img"
          ></v-img>
        </div>
      </div>
      <div class="features-container">
        <h1>Prompthubの使い方</h1>
        <div class="features-row">
          <div class="how-to-use">
            <h2>ChatGPTの参考例を見つける</h2>
            <p>自分に合った参考例を見つけましょう</p>
          </div>
          <div class="card-img-container">
            <v-img
              :src="require('@/assets/images/introduce/lunch-break-e1.png')"
              class="card-img"
            ></v-img>
          </div>
          <div class="how-to-use">
            <h2>実際に使ってみる</h2>
            <p>サンプルをカスタマイズして実際に使ってみましょう</p>
          </div>
          <div class="card-img-container">
            <v-img
              :src="require('@/assets/images/introduce/user-interface-8.png')"
              class="card-img"
            ></v-img>
          </div>
        </div>
      </div>
    </div>
    <!-- モバイル用の表示 -->
    <div v-if="isMobileBreakpointLessThan">
      <div class="mobile-eye-catching-container">
        <div class="mobile-eye-catching-container-title">
          <h1>ChatGPTの使い方を広げよう</h1>
        </div>
        <div>
          <v-img
            :src="require('@/assets/images/introduce/prompthub.jpeg')"
            alt="Prompthub"
            class="mobile-eye-catching-img mx-auto"
          ></v-img>
        </div>
      </div>
      <div class="mobile-features-container">
        <h1>Prompthubの使い方</h1>
        <div class="mobile-features-row">
          <div class="mobile-how-to-use">
            <h2>ChatGPTの参考例を見つける</h2>
            <p>自分に合った参考例を見つけましょう</p>
          </div>
          <div class="mobile-card-img-container">
            <v-img
              :src="require('@/assets/images/introduce/lunch-break-e1.png')"
              class="card-img"
            ></v-img>
          </div>
          <div class="mobile-how-to-use">
            <h2>実際に使ってみる</h2>
            <p>サンプルをカスタマイズして実際に使ってみましょう</p>
          </div>
          <div class="mobile-card-img-container">
            <v-img
              :src="require('@/assets/images/introduce/user-interface-8.png')"
              class="card-img"
            ></v-img>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import isMobileBreakpoint from '~/mixins/isMobileBreakpoint';
export default {
  mixins: [isMobileBreakpoint],
};
</script>

<style scoped>
/* PC */
.eye-catching-container {
  position: relative;
  background-color: #d6d2e0;
  display: flex;
  align-items: center;
  justify-content: space-around;
}

.eye-catching-img {
  max-width: 400px;
  max-height: 400px;
  border-radius: 45px;
}

.features-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  margin-top: 50px;
}

.features-row {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-gap: 20px; /* 各要素の間隔 */
  margin-top: 50px;
}

.how-to-use {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

/* Mobile */

.mobile-eye-catching-container {
  position: relative;
  background-color: #d6d2e0;
  display: block;
  text-align: center;
  padding: 50px 0;
}

.mobile-eye-catching-img {
  max-width: 400px;
  max-height: 400px;
  border-radius: 45px;
  margin-top: 30px;
}

.mobile-features-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  margin-top: 50px;
}

.mobile-features-row {
  display: block;
}

.mobile-how-to-use {
  display: flex;
  flex-direction: column;
  justify-content: center;
  margin-top: 50px;
}

.mobile-card-img-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  margin-top: 30px;
}
</style>
