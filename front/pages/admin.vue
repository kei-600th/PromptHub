<template>
  <div class="container">
    <!-- サンプル投稿用テンプレート -->
    <div v-if="promptCreated === false">
      <PromptForm
        :request-text="params.prompt.request_text"
        :loading="loading"
        @updateRequestText="params.prompt.request_text = $event"
        @createPrompt="createPrompt"
      />
    </div>
    <!-- 作成中サンプル表示用テンプレート -->
    <div v-if="promptCreated === true">
      <v-card>
        <v-card-title>作成するサンプルの確認</v-card-title>
        <SampleForm
          :title="params.sample.title"
          :description="params.sample.description"
          @updateTitle="params.sample.title = $event"
          @updateDescription="params.sample.description = $event"
        />
        <ChatLog
          :request-text="params.prompt.request_text"
          :response-text="params.prompt.response_text"
        />
        <v-row class="justify-end">
          <v-btn
            color="appblue"
            :disabled="
              anyIsEmptyOrWhitespace(
                params.sample.title,
                params.sample.description,
              ) || loading
            "
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
    ChatLog,
  },
  data() {
    return {
      loading: false,
      params: {
        ...this.defaultPromptAndSampleParams(),
        user: {
          id: null,
        },
      },
      promptCreated: false,
    };
  },
  computed: {
    isAdmin() {
      return this.$store.getters.isAdmin;
    },
    userId() {
      return this.$store.state.user.current ? this.$store.state.user.current.id : null;
    },
  },
  mounted() {
    if (!this.isAdmin) {
      this.$router.push('/');
      return;
    }
    if (this.userId) {
      this.params.user.id = this.userId;
    }
  },
  methods: {
    defaultPromptAndSampleParams() {
      return {
        prompt: {
          request_text: '',
          response_text: '',
        },
        sample: {
          title: '',
          description: '',
        },
      };
    },
    anyIsEmptyOrWhitespace(...texts) {
      return texts.some((text) => text.trim() === '');
    },
    async createPrompt() {
      this.loading = true;
      try {
        const response = await this.$axios.$get('/api/v1/admin/prompts/new', {
          params: this.params,
          paramsSerializer: (params) => {
            return qs.stringify(params);
          },
        });
        this.params.prompt.response_text = response.response_text;
        this.promptCreated = true;
      } catch (error) {
        this.postFailure(error);
      }
      this.loading = false;
    },
    async createSample() {
      this.loading = true;
      try {
        await this.$axios.$post('/api/v1/admin/samples/', this.params);
        // 変更を反映させるため1秒後にthis.$router.push('/')を実行
        setTimeout(() => {
          this.$router.push('/');
        }, 1000);
      } catch (error) {
        this.postFailure(error);
        this.loading = false;
      }
    },
    postFailure(error) {
      if (error.response) {
        const msg = error.response.data.error;
        return this.$store.dispatch('getToast', { msg });
      }
    },
    deletePrompt() {
      Object.assign(this.params, this.defaultPromptAndSampleParams());Object.assign(this.params, this.defaultPromptAndSampleParams());
      this.promptCreated = false;
    },
  },
};
</script>
