<template>
  <div class="my-4">
    <!-- ユーザー側 -->
    <div class="my-4">
      <v-card-title>
        <div class="sender">
          <v-icon large left> mdi-account </v-icon>
          <h4>あなた</h4>
        </div>
      </v-card-title>

      <!-- 本文 -->
      <v-card color="#E7FDCC" class="test rounded-xl">
        <div class="user-message-text">
          <v-card-text
            :class="isMobileBreakpointLessThan ? 'text-h6' : 'text-h5'"
          >
            <div v-html="formattedRequestText"></div>
          </v-card-text>
          <div>
            <v-tooltip bottom>
              <template #activator="{ on, attrs }">
                <v-icon
                  class="mr-4 mt-4"
                  v-bind="attrs"
                  @click="copyText(requestText)"
                  v-on="on"
                  >mdi-clipboard-outline
                </v-icon>
              </template>
              <span>Copy</span>
            </v-tooltip>
          </div>
        </div>
        <div v-if="image" class="ma-5">
          <img
            :src="image"
            alt="アップロードされた画像"
            class="rounded-xl"
            style="max-width: 200px; max-height: 200px; margin-right: 10px"
            @click="dialog = true"
          />
        </div>
      </v-card>
    </div>

    <!-- ChatGPT側 -->
    <div class="my-4">
      <v-card-title>
        <div class="sender">
          <v-icon large left> mdi-robot </v-icon>
          <h4>ChatGPT</h4>
        </div>
      </v-card-title>

      <!-- 本文 -->
      <v-card color="#EBECEE" class="rounded-xl">
        <v-card-text
          :class="isMobileBreakpointLessThan ? 'text-h6' : 'text-h5'"
        >
          <div v-html="formattedResponseText"></div>
        </v-card-text>
      </v-card>
    </div>

    <!-- モーダルウィンドウ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          <v-spacer></v-spacer>
          <v-btn icon @click="dialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-card-title>
        <v-card-text class="text-center">
          <img
            :src="image"
            alt="オリジナル画像"
            style="display: block; margin: auto"
          />
        </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { handleFailure } from '@/plugins/error-handler';
import isMobileBreakpoint from '~/mixins/isMobileBreakpoint';
export default {
  mixins: [isMobileBreakpoint],
  props: {
    requestText: {
      type: String,
      required: true,
    },
    responseText: {
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
      dialog: false,
    };
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

.user-message-text {
  display: flex;
  justify-content: space-between;
}

.sender {
  display: flex;
}
</style>
