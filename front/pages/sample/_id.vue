<template>
  <div class="container">
    <v-card>
      <div v-if="sampleEditting === false">
        <SampleInformation
          v-if="params.sample.title && params.sample.description"
          :title="params.sample.title"
          :description="params.sample.description"
          :category-name="params.sample.category.name"
        />
      </div>
      <div v-if="sampleEditting === true">
        <SampleForm
          :title="params.sample.title"
          :description="params.sample.description"
          :category-id="params.sample.category_id"
          :categories="categories"
          @updateTitle="params.sample.title = $event"
          @updateDescription="params.sample.description = $event"
          @updateCategory="params.sample.category_id = $event"
        />
      </div>
      <div v-for="(prompt, index) in params.sample.prompts" :key="index">
        <ChatLog
          :request-text="prompt.request_text"
          :response-text="prompt.response_text"
        />
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
    </v-card>
  </div>
</template>

<script>
import qs from 'qs';
import ChatLog from '@/components/Sample/ChatLog.vue';
import SampleInformation from '@/components/Sample/SampleInformation.vue';
import SampleDetailButtons from '@/components/Sample/SampleDetailButtons.vue';
import { handleFailure } from '@/plugins/error-handler';
import checkAdminMixin from '@/plugins/check-admin-mixin';
export default {
  components: {
    ChatLog,
    SampleInformation,
    SampleDetailButtons,
  },
  mixins: [checkAdminMixin],
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
    };
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
  },
};
</script>
