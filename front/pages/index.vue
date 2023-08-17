<template>
  <div>
    <SelectCategory
      :category-id="params.category_id"
      :categories="categories"
      @updateCategory="params.category_id = $event"
    />
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
import SelectCategory from '@/components/Category/SelectCategory.vue';
import { handleFailure } from '@/plugins/error-handler';
export default {
  components: {
    SelectCategory,
  },
  data() {
    return {
      params: {
        category_id: null,
      },
      categories: [
        { id: null, name: 'すべてのカテゴリ' }
      ],
      samples: [],
      card: {
        sm: 6,
        md: 4,
        height: 150,
        elevation: 4,
      },
    };
  },
  watch: {
    'params.category_id': function(newCategoryId, oldCategoryId) {
      if (newCategoryId !== oldCategoryId) {
        this.getSamples(); // カテゴリIDが変更された時にサンプルを更新
      }
    },
  },
  async mounted() {
    await this.getSamples();
    try {
      const response = await this.$axios.$get('/api/v1/categories');
      this.categories = [{ id: null, name: 'すべてのカテゴリ' }, ...response];
    } catch (error) {
      handleFailure(error, this.$store);
    }
  },
  methods: {
    async getSamples() {
      try {
        const response = await this.$axios.$get('/api/v1/samples/', {
          params: { category_id: this.params.category_id } // カテゴリIDをパラメータとして追加
        });
        this.samples = response;
      } catch (error) {
        handleFailure(error, this.$store);
      }
    },
  },
};
</script>
