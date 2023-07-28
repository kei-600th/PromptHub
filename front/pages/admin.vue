<template>
  <div class="container">
    <!-- サンプル投稿用テンプレート -->
    <div
      v-if="promptCreated === false"
    >
      <PromptForm 
        :requestText="params.prompt.request_text"
        :loading="loading"
        @updateRequestText="params.prompt.request_text = $event"
        @createPrompt="createPrompt"
      />
    </div>
    <!-- 作成中サンプル表示用テンプレート -->
    <div
      v-if="promptCreated === true"
    >
      <v-card>
        <v-card-title>作成するサンプルの確認</v-card-title>
        <SampleForm 
          :title="params.sample.title"
          :description="params.sample.description"
          @updateTitle="params.sample.title = $event"
          @updateDescription="params.sample.description = $event"
        />
        <ChatLog 
          :requestText="params.prompt.request_text" 
          :responseText="params.prompt.response_text"
        />
        <v-row class="justify-end">
          <v-btn
            color="appblue"
            :disabled="anyIsEmptyOrWhitespace(params.sample.title, params.sample.description) || loading"
            :loading="loading"
            class="white--text ma-5"
            @click="createSample()"
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
import PromptForm from '@/components/Sample/PromptForm.vue';
import SampleForm from '@/components/Sample/SampleForm.vue';
import ChatLog from '@/components/Sample/ChatLog.vue';
export default {
  components: {
    PromptForm,
    SampleForm,
    ChatLog
  },
  data() {
    return {
      loading: false,
      params: {
        prompt: {
          request_text: '',
          response_text: null
        },
        sample: {
          title: '',
          description: ''
        }
      },
      promptCreated: true,
    };
  },
  methods: {
    anyIsEmptyOrWhitespace(...texts) {
      return texts.some(text => text.trim() === '');
    },
    async createPrompt() {
      this.loading = true;
      const response = await this.$axios.$get('/api/v1/samples/new', {
        params: this.params,
        paramsSerializer: params => {
          return qs.stringify(params);
        },
      })
      this.params.prompt.response_text = response.response_text
      this.promptCreated = true
      this.loading = false;
      // Todo レスポンスの確認の削除
      console.log(response.request_text);
      console.log(response.response_text);
    },
    async createSample() {
      this.loading = true;
      await this.$axios.$post('/api/v1/samples/', this.params)
      this.loading = false;
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
