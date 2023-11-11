<template>
  <div class="container">
    <!-- プロンプトが作成されていれば表示する -->
    <div v-if="params.prompts.length > 0">
      <!-- チャットログの表示 -->
      <div v-for="(prompt, index) in params.prompts" :key="index">
        <ChatLog
          :request-text="prompt.request_text"
          :response-text="prompt.response_text"
          :image="params.prompt.image"
        />
      </div>
      <v-card>
        <!-- プロンプト作成用タブ -->
        <v-tabs v-model="tab" background-color="cyan" dark>
          <v-tabs-slider color="yellow"></v-tabs-slider>
          <v-tab key="1">プロンプトの作成</v-tab>
          <v-tab key="2">サンプルの保存</v-tab>
        </v-tabs>
        <v-tabs-items v-model="tab">
          <v-tab-item key="1">
            <PromptForm
              :request-text="params.prompt.request_text"
              :gpt-model="params.prompt.gpt_model"
              :image="params.prompt.image"
              :loading="loading"
              @updateRequestText="params.prompt.request_text = $event"
              @updateGptModel="params.prompt.gpt_model = $event"
              @updateImage="updateImage"
              @createPrompt="createPrompt"
            />
          </v-tab-item>

          <!-- サンプル投稿用タブ -->
          <v-tab-item key="2">
            <v-card>
              <v-card-title>サンプルを保存する</v-card-title>
              <SampleForm
                :title="params.sample.title"
                :description="params.sample.description"
                @updateTitle="params.sample.title = $event"
                @updateDescription="params.sample.description = $event"
              />
              <SelectCategory
                :category-id="params.sample.category_id"
                :categories="categories"
                @updateCategory="params.sample.category_id = $event"
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
          </v-tab-item>
        </v-tabs-items>
      </v-card>
    </div>
    <!-- プロンプトが作成されていなければ表示する -->
    <div v-if="params.prompts.length === 0">
      <!-- プロンプト作成用テンプレート -->
      <PromptForm
        :request-text="params.prompt.request_text"
        :gpt-model="params.prompt.gpt_model"
        :image="params.prompt.image"
        :loading="loading"
        @updateRequestText="params.prompt.request_text = $event"
        @updateGptModel="params.prompt.gpt_model = $event"
        @updateImage="updateImage"
        @createPrompt="createPrompt"
      />
    </div>
  </div>
</template>

<script>
import PromptForm from '@/components/Sample/PromptForm.vue';
import SampleForm from '@/components/Sample/SampleForm.vue';
import SelectCategory from '@/components/Category/SelectCategory.vue';
import ChatLog from '@/components/Sample/ChatLog.vue';
import { handleFailure } from '@/plugins/error-handler';
import checkAdminMixin from '@/mixins/checkAdminMixin';

export default {
  components: {
    PromptForm,
    SampleForm,
    SelectCategory,
    ChatLog,
  },
  mixins: [checkAdminMixin],
  data() {
    return {
      loading: false,
      tab: null,
      categories: [],
      params: {
        prompts: [],
        ...this.defaultPromptAndSampleParams(),
        user: {
          id: null,
        },
        messages: [],
      },
    };
  },
  async mounted() {
    if (!this.isAdmin) {
      this.$router.push('/');
    }
    try {
      const response = await this.$axios.$get('/api/v1/categories');
      this.categories = response;
    } catch (error) {
      handleFailure(error, this.$store);
    }
  },
  methods: {
    defaultPromptAndSampleParams() {
      return {
        prompt: {
          request_text: '',
          response_text: '',
          gpt_model: 'gpt-3.5-turbo',
          image: null,
        },
        sample: {
          title: '',
          description: '',
          category_id: 2,
        },
      };
    },
    anyIsEmptyOrWhitespace(...texts) {
      return texts.some((text) => text.trim() === '');
    },
    async createPrompt() {
      this.loading = true;
      if (this.params.prompt.gpt_model === 'gpt-4-vision-preview') {
        this.params.messages.push({
          role: 'user',
          content: [
            {
              type: 'text',
              text: this.params.prompt.request_text,
            },
            {
              type: 'image_url',
              image_url: this.params.prompt.image,
            },
          ],
        });
      } else {
        this.params.messages.push({
          role: 'user',
          content: this.params.prompt.request_text,
        });
      }
      try {
        const response = await this.$axios.$post(
          '/api/v1/admin/prompts',
          this.params,
        );
        this.params.prompt.response_text = response.response_text;
        this.params.prompts.push({ ...this.params.prompt });
        // OpenAIからのmessagesをparams.messagesに保存
        this.params.messages.push({
          role: 'assistant',
          content: response.response_text,
        });
        console.log(this.params);
      } catch (error) {
        handleFailure(error, this.$store);
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
        handleFailure(error, this.$store);
        this.loading = false;
      }
    },
    deletePrompt() {
      Object.assign(this.params, this.defaultPromptAndSampleParams());
      this.params.prompts.length = 0;
      this.params.messages.length = 0;
    },
    updateImage(base64Image) {
      this.params.prompt.image = base64Image;
    },
  },
};
</script>
