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
        class="mx-auto"
        >
          <v-card-title>
            {{ sample.title }}
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
export default {
  data () {
    return {
      samples: [],
      card: {
        sm: 6,
        md: 4,
        height: 110,
        elevation: 4
      },
    }
  },
  mounted() {
    this.getSample();
  },
  methods: {
    async getSample() {
      await this.$axios
      .$get('/api/v1/samples/')
      .then(
        (response) => {
          this.samples = response;
          console.log(this.samples);
        }
      )
      .catch((error) => {
        console.log(error)
      });
    }
  },
};
</script>
