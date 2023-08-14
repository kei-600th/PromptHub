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
    <div style="display: flex; align-items: center;">
      <v-select
        :items="items"
        label="GPT-Model"
        outlined
        class="ma-5"
        style="max-width: 150px;"
      ></v-select>
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
  },
  data() {
    return {
      items: ['GPT-3.5', 'GPT-4'],
      localRequestText: this.requestText,
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
    },
  },
};
</script>
