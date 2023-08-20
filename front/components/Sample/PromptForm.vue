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
  },
  data() {
    return {
      items: ['gpt-3.5-turbo', 'gpt-4'],
      localRequestText: this.requestText,
      localGptModel: this.gptModel,
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
  },
};
</script>
