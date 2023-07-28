<template>
  <div class="container">
    <!-- サンプル投稿用テンプレート -->
    <div
      v-if="promptCreated === false"
    >
      <v-card>
        <v-card-title>ChatGPTへの質問と回答を作成する</v-card-title>
        <v-container>
          <v-textarea
            v-model="params.prompt.request_text"
            name="input-7-1"
            filled
            label="ChatGPTに送信するメッセージ"
            auto-grow
          ></v-textarea>
        </v-container>
        <v-row class="justify-end">
          <v-btn
            color="appblue"
            class="white--text ma-5"
            @click="createPrompt()"
          >
            送信する
          </v-btn>
        </v-row>
      </v-card>
    </div>
    <!-- 作成中サンプル表示用テンプレート -->
    <div
      v-if="promptCreated === true"
    >
      <v-card>
        <v-card-title>作成するサンプルの確認</v-card-title>
        <v-card-title class="text-h4">
          <v-text-field
            v-model="params.sample.title"
            label="タイトルを入力"
          ></v-text-field>
        </v-card-title>
        <v-card-subtitle class="ma-1 text-h6">
          <v-textarea
            v-model="params.sample.description"
            rows="2"
            label="説明文を入力"
          ></v-textarea>
        </v-card-subtitle>
        <v-divider class="mx-4"></v-divider>
        <v-card-title>
          <v-icon
            large
            left
          >
            mdi-account
          </v-icon>
          <span class="text-h6 font-weight-light">You</span>
        </v-card-title>

        <v-card-text class="text-h5">
          {{ params.prompt.request_text }}
        </v-card-text>
        <v-divider class="mx-4"></v-divider>
        <v-card-title>
          <v-icon
            large
            left
          >
            mdi-robot
          </v-icon>
          <span class="text-h6 font-weight-light">ChatGPT</span>
        </v-card-title>

        <v-card-text class="text-h5">
          {{ params.prompt.response_text }}
        </v-card-text>
        <v-divider class="mx-4"></v-divider>
        <v-row class="justify-end">
          <v-btn
            color="appblue"
            class="white--text ma-5"
          >
            作成する
          </v-btn>
          <v-btn
            color="appblue"
            class="white--text ma-5"
            @click="deletePrompt()"
          >
            作成を中止
          </v-btn>
        </v-row>
      </v-card>
    </div>
  </div>
</template>

<script>
import qs from 'qs';
export default {
  data() {
    return {
      params: {
        prompt: {
          request_text: '私はChatGPTと会話するのがとても楽しいです',
          response_text: null
        },
        sample: {
          title: '',
          description: ''
        }
      },
      promptCreated: false,
    };
  },
  methods: {
    async createPrompt() {
      const response = await this.$axios.$get('/api/v1/samples/new', {
        params: this.params,
        paramsSerializer: params => {
          return qs.stringify(params);
        },
      })
      this.params.prompt.response_text = response.response_text
      this.promptCreated = true
      // Todo レスポンスの確認の削除
      console.log(response.request_text);
      console.log(response.response_text);
    },
    deletePrompt() {
      this.params.prompt.request_text = ''
      this.params.prompt.response_text = null
      this.params.sample.title = ''
      this.params.sample.description = ''
      this.promptCreated = false
    }
  },
};
</script>
