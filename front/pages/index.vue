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
          class="v-btn text-capitalize mx-auto"
        >
          <v-img
            :src="images[(sample.category_id - 1)]"
            height="150"
            gradient="to bottom, rgba(0,0,0,.5), rgba(0,0,0,.5)"
            class="white--text align-end clickable"
            @click="$router.push(`/sample/${sample.id}`)"
          >
            <v-card-title>
              {{ sample.title }}
            </v-card-title>
            <v-icon color="white" class="ma-2" @click.stop="handleIconClick">mdi-heart-outline</v-icon>
          </v-img>
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
      categories: [{ id: null, name: 'すべてのカテゴリ' }],
      samples: [],
      card: {
        sm: 6,
        md: 4,
        height: 150,
        elevation: 4,
      },
      images: [
        require('@/assets/images/sample_images/pc.jpeg'),
        require('@/assets/images/sample_images/talking.jpeg'),
        require('@/assets/images/sample_images/buisiness.jpeg'),
        require('@/assets/images/sample_images/heart.jpeg'),
        require('@/assets/images/sample_images/academy.jpeg'),
        require('@/assets/images/sample_images/house.jpeg'),
        require('@/assets/images/sample_images/books.jpeg'),
        require('@/assets/images/sample_images/designing.jpeg')
      ],
    };
  },
  watch: {
    'params.category_id': function (newCategoryId, oldCategoryId) {
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
          params: { category_id: this.params.category_id }, // カテゴリIDをパラメータとして追加
        });
        this.samples = response;
      } catch (error) {
        handleFailure(error, this.$store);
      }
    },
    handleIconClick() {
      console.log("HelloWorld");
    },
  },
};
</script>

<style>
  .clickable {
    cursor: pointer;
  }
</style>
