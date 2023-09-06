<template>
  <div class="my-4">

    <!-- ユーザー側 -->
    <div class="my-4">
      <v-card-title>
        <div>
          <v-icon large left> mdi-account </v-icon>
          <span class="text-h6 font-weight-light">You</span>
        </div>
      </v-card-title>

      <!-- 本文 -->
      <v-card color="#E7FDCC" class="user-message rounded-xl">
        <v-card-text class="text-h5">
          <div v-html="formattedRequestText"></div>
        </v-card-text>
        <div>
          <v-tooltip right>
            <template #activator="{ on, attrs }">
              <v-icon class="mr-4 mt-4" v-bind="attrs" @click="copyText(requestText)" v-on="on"
                >mdi-clipboard-outline
              </v-icon>
            </template>
            <span>Copy</span>
          </v-tooltip>
        </div>
      </v-card>
    </div>

    <!-- ChatGPT側 -->
    <div class="my-4">
      <v-card-title>
        <div>
          <v-icon large left> mdi-robot </v-icon>
          <span class="text-h6 font-weight-light">ChatGPT</span>
        </div>
      </v-card-title>

      <!-- 本文 -->
      <v-card color="#EBECEE" class="rounded-xl">
        <v-card-text class="text-h5">
          <div v-html="formattedResponseText"></div>
        </v-card-text>
      </v-card>
    </div>
  </div>
</template>

<script>
import { handleFailure } from '@/plugins/error-handler';
/* eslint-disable vue/no-v-html */
export default {
  props: {
    requestText: {
      type: String,
      required: true,
    },
    responseText: {
      type: String,
      required: true,
    },
  },
  computed: {
    formattedRequestText() {
      return this.formatText(this.requestText);
    },
    formattedResponseText() {
      return this.formatText(this.responseText);
    },
  },
  methods: {
    formatText(text) {
      // 全体をエスケープ
      const escapedText = text
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');

      // コードブロック箇所にdivタグを適用
      let result = escapedText.replace(
        /```(\w*?)\n([\s\S]*?)```/g,
        (match, language, code) => {
          return `<div class="code-block">${code}</div>`;
        },
      );

      result = '<div style="white-space: pre-wrap;">' + result + '</div>';
      result = result.replace(/\n/g, '<br>');
      return result;
    },
    async copyText(text) {
      try {
        await this.$copyText(text);
        this.$store.dispatch('getToast', {
          msg: 'コピーしました!',
          color: 'success',
          timeout: 4000,
        });
      } catch (error) {
        handleFailure(error, this.$store);
      }
    },
  },
};
</script>

<style>
.code-block {
  background-color: black;
  color: white; /* 文字色を白に設定する */
  padding: 10px;
  border-radius: 5px;
  white-space: pre-wrap;
}

.user-message {
  display: flex;
	justify-content: space-between;
}

</style>
