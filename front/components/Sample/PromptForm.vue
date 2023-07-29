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
    <v-row class="justify-end">
      <v-btn
        color="appblue"
        :disabled="isEmptyOrWhitespace(localRequestText) || loading"
        :loading="loading"
        class="white--text ma-5"
        @click="submitPrompt"
      >
        送信する
      </v-btn>
    </v-row>
  </v-card>
</template>

<script>
export default {
  props: ['requestText', 'loading', 'createPrompt'],
  data() {
    return {
      localRequestText: this.requestText
    };
  },
  watch: {
    localRequestText: function (newRequestText) {
      this.$emit('updateRequestText', newRequestText);
    },
  },
  methods: {
    isEmptyOrWhitespace(text) {
      return text.trim() === '';
    },
    submitPrompt() {
      this.$emit('createPrompt', this.localRequestText);
    }
  }
};
</script>
