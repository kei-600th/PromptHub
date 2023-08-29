<template>
  <div>
    <v-divider class="mx-4"></v-divider>
    <v-card-title>
      <div>
        <v-icon large left> mdi-account </v-icon>
        <span class="text-h6 font-weight-light">You</span>
      </div>
      <v-spacer></v-spacer>
      <v-tooltip right>
        <template #activator="{ on, attrs }">
          <v-icon v-bind="attrs" @click="copyText(requestText)" v-on="on"
            >mdi-clipboard-outline
          </v-icon>
        </template>
        <span>Copy</span>
      </v-tooltip>
    </v-card-title>

    <v-card-text class="text-h5">
      {{ requestText }}
    </v-card-text>
    <v-divider class="mx-4"></v-divider>
    <v-card-title>
      <div>
        <v-icon large left> mdi-robot </v-icon>
        <span class="text-h6 font-weight-light">ChatGPT</span>
      </div>
      <v-spacer></v-spacer>
      <v-tooltip right>
        <template #activator="{ on, attrs }">
          <v-icon v-bind="attrs" @click="copyText(responseText)" v-on="on"
            >mdi-clipboard-outline
          </v-icon>
        </template>
        <span>Copy</span>
      </v-tooltip>
    </v-card-title>

    <v-card-text class="text-h5">
      <div v-html="formattedResponseText"></div>
    </v-card-text>
    <v-divider class="mx-4"></v-divider>
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
    formattedResponseText() {
      // バッククォートが3つ連続する部分を検知し、クラスを適用
      let result = this.responseText.replace(
        /```(\w*?)\n([\s\S]*?)```/g,
        (match, language, code) => {
          // ソースコード内の改行を<br>タグに置き換える
          code = code.replace(/\n/g, '<br>');
          return '<div class="code-block">' + code + '</div>';
        },
      );
      // ソースコードブロック外の改行も<br>タグに置き換える（必要であれば）
      result = result.replace(/\n/g, '<br>');
      return result;
    },
  },
  methods: {
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
</style>
