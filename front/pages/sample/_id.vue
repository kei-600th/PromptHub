<template>
  <div class="container">
    <v-card>
      <div
        v-if="sampleEditting === false"
      >
        <SampleInfomation 
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
            color="appblue"
            class="white--text ma-5"
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
import SampleInfomation from '@/components/Sample/SampleInfomation.vue';
export default {
  components: {
    ChatLog,
    SampleInfomation
  },
  data () {
    return {
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
      const id = this.$route.params.id;
      await this.$axios
      .$get(`/api/v1/samples/${id}`)
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
    async cancelEditSample() {
      await this.getSample()
      this.sampleEditting = false
    }
  }
}
</script>
