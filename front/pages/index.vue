<template>
  <div>
    <v-row class="ma-4">
      <v-icon class="mr-2">mdi-view-list</v-icon>
      <h2>サンプル一覧</h2>
    </v-row>
    <div class="sample-sorting-container mt-4">
      <div class="select-boxes">
        <SelectCategory
          :category-id="getCategoryId"
          :categories="categories"
          @updateCategory="updateCategoryId($event)"
        />
        <v-select
          :value="getGptModel"
          class="ml-8"
          :items="models"
          label="ChatGPTのモデルを選択"
          style="max-width: 200px"
          @input="newGptModel => updateGptModel(newGptModel)"
        ></v-select>
      </div>
      <div v-if="!pageLoading">
        <div v-if="!(samples.length === 0)">
          <div class="my-1 ml-4 switch">
            新着順
            <v-switch
              v-model="isPopularOrder"
              :disabled="isLoadingSwitch"
              class="ml-3 mr-1"
            ></v-switch>
            人気順
          </div>
        </div>
      </div>
    </div>
    <SampleList
      :samples="samples"
      :card="card"
      :is-logged-in="isLoggedIn"
      :images="images"
      :is-loading="isLoading"
      :heart-color="heartColor"
      :page-loading="pageLoading"
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
      models: ['すべてのモデル','gpt-3.5-turbo','gpt-4'],
      pageLoading: true,
    };
  },
  computed: {
    ...mapGetters(['isLoggedIn', 'getCategoryId', 'getGptModel']),
  },
  watch: {
    getCategoryId: function (newCategoryId, oldCategoryId) {
      if (newCategoryId !== oldCategoryId) {
        this.pageLoading = true;
        this.getSamples(); // カテゴリIDが変更された時にサンプルを更新
        this.pageLoading = false;
      }
    },
    isPopularOrder: function (newVal, oldVal) {
      if (newVal !== oldVal) {
        this.getSamples(); // 人気順判定変数が変更された時にサンプルを更新
      }
    },
    getGptModel: function (newGptModel, oldGptModel) {
      if (newGptModel !== oldGptModel) {
        this.pageLoading = true;
        this.getSamples();
        this.pageLoading = false;
      }
    },
  },
  async mounted() {
    this.pageLoading = true;
    await this.getSamples();
    try {
      const response = await this.$axios.$get('/api/v1/categories');
      this.categories = [{ id: null, name: 'すべてのカテゴリ' }, ...response];
    } catch (error) {
      handleFailure(error, this.$store);
    } finally {
      this.pageLoading = false;
    }
  },
  methods: {
    ...mapActions(['updateCategoryId', 'updateGptModel']),
    async getSamples() {
      this.isLoadingSwitch = true;
      try {
        const response = await this.$axios.$get('/api/v1/samples/', {
          params: {
            category_id: this.getCategoryId,
            is_popular_order: this.isPopularOrder,
            gpt_model: this.getGptModel
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

.select-boxes{
  display:flex;
}
.switch {
  display: flex;
  align-items: center;
}
</style>
