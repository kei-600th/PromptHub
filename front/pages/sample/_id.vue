<template>
  <div class="container">
    <v-card>
      <v-card-title
      class="text-h4"
      >
        {{ sample.title }}
      </v-card-title>
      <v-card-subtitle
      class="text-h6 my-2"
      >
        {{ sample.description }}
      </v-card-subtitle>
      <div
      v-for="(prompt, index) in sample.prompts"
      :key="index"
      >
        <ChatLog 
          :requestText="prompt.request_text" 
          :responseText="prompt.response_text"
        />
      </div>
    </v-card>
  </div>
</template>

<script>
import ChatLog from '@/components/Sample/ChatLog.vue';
export default {
  components: {
    ChatLog
  },
  data () {
    return {
      sample: {},
    }
  },
  async mounted() {
    await this.getSample();
  },
  methods: {
    async getSample() {
      const id = this.$route.params.id;
      await this.$axios
      .$get(`/api/v1/samples/${id}`)
      .then((response) => {
        this.sample = response;
        console.log(this.sample);
      })
      .catch((error) => {
        console.log(error);
      });
    }
  }
}
</script>
