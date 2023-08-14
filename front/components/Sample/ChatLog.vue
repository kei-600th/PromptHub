<template>
  <div>
    <v-divider class="mx-4"></v-divider>
    <v-card-title>
      <v-icon large left> mdi-account </v-icon>
      <span class="text-h6 font-weight-light">You</span>
    </v-card-title>

    <v-card-text class="text-h5">
      {{ requestText }}
    </v-card-text>
    <v-divider class="mx-4"></v-divider>
    <v-card-title>
      <v-icon large left> mdi-robot </v-icon>
      <span class="text-h6 font-weight-light">ChatGPT</span>
    </v-card-title>

    <v-card-text class="text-h5">
      <div v-html="formattedResponseText"></div>
    </v-card-text>
    <v-divider class="mx-4"></v-divider>
  </div>
</template>

<script>
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
      let result = this.responseText.replace(/```(\w*?)\n([\s\S]*?)```/g, (match, language, code) => {
        // ソースコード内の改行を<br>タグに置き換える
        code = code.replace(/\n/g, '<br>');
        return '<div class="code-block">' + code + '</div>';
      });
      // ソースコードブロック外の改行も<br>タグに置き換える（必要であれば）
      result = result.replace(/\n/g, '<br>');
      return result;
    }
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
