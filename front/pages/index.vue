<template>
  <div>
    <v-row class="ma-4">
      <v-icon class="mr-2">mdi-view-list</v-icon>
      <h2>サンプル一覧</h2>
    </v-row>
    <div class="sample-sorting-container mt-4">
      <SelectCategory
        class="ml-1"
        :category-id="getCategoryId"
        :categories="categories"
        @updateCategory="updateCategoryId($event)"
      />
      <div class="ma-1 switch">
        新着順
        <v-switch
          v-model="isPopularOrder"
          :disabled="isLoadingSwitch"
          class="ml-3 mr-1"
        ></v-switch>
        人気順
      </div>
    </div>
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
import { mapGetters, mapActions } from 'vuex';
import SelectCategory from '@/components/Category/SelectCategory.vue';
import { handleFailure } from '@/plugins/error-handler';
import SampleList from '@/components/Sample/SampleList.vue';
import likeMixin from '@/mixins/likeMixin.js';
import sampleListCardMixin from '@/mixins/sampleListCardMixin.js';
export default {
  components: {
    SelectCategory,
    SampleList,
  },
  mixins: [likeMixin, sampleListCardMixin],
  data() {
    return {
      categories: [{ id: null, name: 'すべてのカテゴリ' }],
      samples: [],
      isPopularOrder: false,
      isLoadingSwitch: false,
    };
  },
  computed: {
    ...mapGetters(['isLoggedIn', 'getCategoryId']),
  },
  watch: {
    getCategoryId: function (newCategoryId, oldCategoryId) {
      if (newCategoryId !== oldCategoryId) {
        this.getSamples(); // カテゴリIDが変更された時にサンプルを更新
      }
    },
    isPopularOrder: function (newVal, oldVal) {
      if (newVal !== oldVal) {
        this.getSamples(); // 人気順判定変数が変更された時にサンプルを更新
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
    ...mapActions(['updateCategoryId']),
    async getSamples() {
      this.isLoadingSwitch = true;
      try {
        const response = await this.$axios.$get('/api/v1/samples/', {
          params: {
            category_id: this.getCategoryId,
            is_popular_order: this.isPopularOrder,
          }, // カテゴリIDをパラメータとして追加
        });
        this.samples = response;
      } catch (error) {
        handleFailure(error, this.$store);
      } finally {
        setTimeout(() => {
          this.isLoadingSwitch = false;
        }, 500);
      }
    },
  },
};
</script>

<style scoped>

.sample-sorting-container {
  margin-left: 3%;
}

.switch {
  display: flex;
  align-items: center;
}
</style>
