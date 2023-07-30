<template>
  <div class="container">
    <v-card>
      <div
        v-if="sampleEditting === false"
      >
        <SampleInformation 
          v-if="params.sample.title && params.sample.description"
          :title="params.sample.title"
          :description="params.sample.description"
        />
      </div>
      <div
        v-if="sampleEditting === true"
      >
        <SampleForm 
          :title="params.sample.title"
          :description="params.sample.description"
          @updateTitle="params.sample.title = $event"
          @updateDescription="params.sample.description = $event"
        />
      </div>
      <div
      v-for="(prompt, index) in params.sample.prompts"
      :key="index"
      >
        <ChatLog 
          :requestText="prompt.request_text" 
          :responseText="prompt.response_text"
        />
      </div>
      <v-row class="justify-end">
        <div
          v-if="sampleEditting === false"
        >
          <v-btn
            color="appblue"
            class="white--text ma-5"
            @click="editSample()"
          >
            サンプルを編集
          </v-btn>
          <v-btn
            :disabled="loading"
            :loading="loading"
            color="appblue"
            class="white--text ma-5"
            @click="deleteSample()"
          >
            サンプルを削除
          </v-btn>
        </div>
        <div
          v-if="sampleEditting === true"
        >
          <v-btn
            :disabled="anyIsEmptyOrWhitespace(params.sample.title, params.sample.description) || loading"
            :loading="loading"
            color="appblue"
            class="white--text ma-5"
            @click="updateSample()"
          >
            編集を保存
          </v-btn>
          <v-btn
            color="appblue"
            class="white--text ma-5"
            @click="cancelEditSample()"
          >
            編集を取消
          </v-btn>
        </div>
      </v-row>
    </v-card>
  </div>
</template>

<script>
import ChatLog from '@/components/Sample/ChatLog.vue';
import SampleInformation from '@/components/Sample/SampleInformation.vue';
export default {
  components: {
    ChatLog,
    SampleInformation
  },
  data () {
    return {
      sampleId: null,
      loading: false,
      params: {
        sample: {},
      },
      sampleEditting: false,
    }
  },
  async mounted() {
    await this.getSample();
  },
  methods: {
    anyIsEmptyOrWhitespace(...texts) {
      return texts.some(text => text.trim() === '');
    },
    async getSample() {
      this.sampleId = this.$route.params.id;
      await this.$axios
      .$get(`/api/v1/samples/${this.sampleId}`)
      .then((response) => {
        this.params.sample = response;
      })
      .catch((error) => {
        console.log(error);
      });
    },
    editSample() {
      this.sampleEditting = true
    },
    async deleteSample() {
      await this.$axios
      .$delete(`/api/v1/samples/${this.sampleId}`)
      .then(() => {
        // 変更を反映させるため1秒後にthis.$router.push('/')を実行
        setTimeout(() => {
          this.$router.push('/');
        }, 1000);
      })
      .catch((error) => {
        console.log(error);
      });
    },
    async updateSample() {
      this.loading = true;
      await this.$axios
      .$patch(`/api/v1/samples/${this.sampleId}`, this.params)
      .catch((error) => {
        this.updateFailure(error);
      });
      this.loading = false;
      this.sampleEditting = false
    },
    updateFailure(error) {
      if (error.response && error.response.status === 422) {
        const msg = error.response.data.error
        return this.$store.dispatch('getToast', { msg });
      }
    },
    async cancelEditSample() {
      await this.getSample()
      this.sampleEditting = false
    }
  }
}
</script>
