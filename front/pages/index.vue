<template>
  <div>
    <v-row>
      <v-col
        v-for="(sample, index) in samples"
        :key="index"
        cols="12"
        :sm="card.sm"
        :md="card.md"
      >
        <v-card
          :height="card.height"
          :elevation="card.elevation"
          max-width="344"
          :to="`/sample/${sample.id}`"
          class="v-btn text-capitalize mx-auto"
        >
          <v-card-title>
            {{ sample.title }}
          </v-card-title>
          <v-chip class="ma-2" size="small" color="primary">
            {{ sample.category.name }}
          </v-chip>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import { handleFailure } from '@/plugins/error-handler';
export default {
  data() {
    return {
      samples: [],
      card: {
        sm: 6,
        md: 4,
        height: 150,
        elevation: 4,
      },
    };
  },
  async mounted() {
    await this.getSamples();
  },
  methods: {
    async getSamples() {
      try {
        const response = await this.$axios.$get('/api/v1/samples/');
        this.samples = response;
      } catch (error) {
        handleFailure(error, this.$store);
      }
    },
  },
};
</script>
