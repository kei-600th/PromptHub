<template>
  <div class="container">
    <div v-if="sampleEditting === false">
      <SampleInformation
        v-if="params.sample.title && params.sample.description"
        :sample="params.sample"
        :is-logged-in="isLoggedIn"
        :is-loading="isLoading"
        :heart-color="heartColor"
        @add-like="addLike"
        @find-like-id="findLikeId"
        @delete-like="deleteLike"
        @not-login-user-click="notLoginUserClick"
        @sayHelloChatGPT="updateCategoryId"
      />
    </div>
    <v-row class="mx-4 my-6">
      <v-icon class="ml-1 mr-2">mdi-emoticon-outline</v-icon>
      <h2>使用例</h2>
    </v-row>
    <div v-for="(prompt, index) in params.sample.prompts" :key="index">
      <ChatLog
        :request-text="prompt.request_text"
        :response-text="prompt.response_text"
      />
    </div>
    <div v-if="sampleEditting === true">
      <v-card>
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
      </v-card>
    </div>
    <SampleDetailButtons
      v-if="isAdmin"
      :loading="loading"
      :sample-editting="sampleEditting"
      :params="params"
      @editSample="editSample"
      @deleteSample="deleteSample"
      @updateSample="updateSample"
      @cancelEditSample="cancelEditSample"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import qs from 'qs';
import ChatLog from '@/components/Sample/ChatLog.vue';
import SampleInformation from '@/components/Sample/SampleInformation.vue';
import SampleDetailButtons from '@/components/Sample/SampleDetailButtons.vue';
import SelectCategory from '@/components/Category/SelectCategory.vue';
import { handleFailure } from '@/plugins/error-handler';
import checkAdminMixin from '@/mixins/checkAdminMixin';
import likeMixin from '@/mixins/likeMixin.js';
export default {
  components: {
    ChatLog,
    SampleInformation,
    SampleDetailButtons,
    SelectCategory,
  },
  mixins: [checkAdminMixin, likeMixin],
  data() {
    return {
      sampleId: null,
      loading: false,
      params: {
        sample: {},
        user: {
          id: null,
        },
      },
      sampleEditting: false,
      categories: [],
      heartColor: '#ff8db3',
    };
  },
  computed: {
    ...mapGetters(['isLoggedIn']),
  },
  async mounted() {
    await this.getSample();
    try {
      const response = await this.$axios.$get('/api/v1/categories');
      this.categories = response;
    } catch (error) {
      handleFailure(error, this.$store);
    }
  },
  methods: {
    async getSample() {
      try {
        this.sampleId = this.$route.params.id;
        const response = await this.$axios.$get(
          `/api/v1/samples/${this.sampleId}`,
        );
        this.params.sample = response;
      } catch (error) {
        handleFailure(error, this.$store);
      }
    },
    editSample() {
      this.sampleEditting = true;
    },
    async cancelEditSample() {
      await this.getSample();
      this.sampleEditting = false;
    },
    async updateSample() {
      this.loading = true;
      try {
        await this.$axios.$patch(
          `/api/v1/admin/samples/${this.sampleId}`,
          this.params,
        );
      } catch (error) {
        handleFailure(error, this.$store);
      }
      await this.getSample();
      this.loading = false;
      this.sampleEditting = false;
    },
    async deleteSample() {
      if (confirm('このサンプルを削除しますか?')) {
        await this.$axios;
        try {
          await this.$axios.$delete(`/api/v1/admin/samples/${this.sampleId}`, {
            params: this.params,
            paramsSerializer: (params) => {
              return qs.stringify(params);
            },
          });
          setTimeout(() => {
            this.$router.push('/');
          }, 1000);
        } catch (error) {
          handleFailure(error, this.$store);
        }
      }
    },
    async updateCategoryId(categoryId) {
      await this.$store.dispatch('updateCategoryId', categoryId);
      this.$router.push('/');
    },
  },
};
</script>
