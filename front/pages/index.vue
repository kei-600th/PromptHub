<template>
  <div>
    <SelectCategory
      :category-id="params.category_id"
      :categories="categories"
      @updateCategory="params.category_id = $event"
    />
    <SampleList
      :samples="samples"
      :card="card"
      :is-logged-in="isLoggedIn"
      :images="images"
      :is-loading="isLoading"
      :heart-color="heartColor"
      @add-like="addLike"
      @find-like-id="findLikeId"
      @delete-like="deleteLike"
      @not-login-user-click="notLoginUserClick"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import SelectCategory from '@/components/Category/SelectCategory.vue';
import { handleFailure } from '@/plugins/error-handler';
import SampleList from '@/components/Sample/SampleList.vue';
import likeMixin from '@/mixins/likeMixin.js';
export default {
  components: {
    SelectCategory,
    SampleList,
  },
  mixins: [likeMixin],
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
        require('@/assets/images/sample_images/designing.jpeg'),
      ],
      heartColor: "white"
    };
  },
  computed: {
    ...mapGetters(['isLoggedIn']),
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
  },
};
</script>

<style>
.clickable {
  cursor: pointer;
}
</style>
