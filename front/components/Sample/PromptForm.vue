<template>
  <v-card>
    <v-card-title>ChatGPTへの質問と回答を作成する</v-card-title>
    <v-container>
      <v-textarea
        v-model="localRequestText"
        name="input-7-1"
        filled
        label="ChatGPTに送信するメッセージ"
        auto-grow
      ></v-textarea>
    </v-container>
    <div style="display: flex; align-items: center">
      <v-select
        v-model="localGptModel"
        :items="items"
        label="GPT-Model"
        outlined
        class="ma-5"
        style="max-width: 180px"
      ></v-select>
      <!-- 画像送信フォームの追加 -->
      <v-file-input
        v-model="localImage"
        label="画像を選択"
        prepend-icon="mdi-camera"
        outlined
        class="ma-5"
        @change="handleImageChange"
      ></v-file-input>
      <v-spacer></v-spacer>
      <v-btn
        color="appblue"
        :disabled="isEmptyOrWhitespace(localRequestText) || loading"
        :loading="loading"
        class="white--text ma-5"
        @click="submitPrompt"
      >
        送信する
      </v-btn>
    </div>
  </v-card>
</template>

<script>
export default {
  props: {
    requestText: {
      type: String,
      required: true,
    },
    loading: {
      type: Boolean,
      required: true,
    },
    gptModel: {
      type: String,
      required: true,
    },
    image: {
      type: String,
      default: () => null,
    },
  },
  data() {
    return {
      items: ['gpt-3.5-turbo', 'gpt-4', 'gpt-4-vision-preview'],
      localRequestText: this.requestText,
      localGptModel: this.gptModel,
      localImage: null, // ファイルオブジェクト用
      localBase64Image: null, // Base64文字列用
    };
  },
  watch: {
    localRequestText: function (newRequestText) {
      this.$emit('updateRequestText', newRequestText);
    },
    localGptModel: function (newGptModel) {
      this.$emit('updateGptModel', newGptModel);
    },
  },
  methods: {
    isEmptyOrWhitespace(text) {
      return text.trim() === '';
    },
    submitPrompt() {
      this.$emit('createPrompt', this.localRequestText, this.localGptModel);
    },
    handleImageChange(file) {
      console.log('HelloWorld!');
      if (!file) {
        this.localBase64Image = null;
        this.$emit('updateImage', null);
        return;
      }
      console.log('HelloHelpMe!');
      this.convertToBase64(file);
    },
    convertToBase64(file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        this.localBase64Image = e.target.result; // ここでBase64文字列をセット
        this.$emit('updateImage', this.localBase64Image); // ここで親コンポーネントに通知
      };
      reader.readAsDataURL(file);
    },
  },
};
</script>
