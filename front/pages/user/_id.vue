<template>
  <div>
    <SampleList
      :samples="samples"
      :card="card"
      :isLoggedIn="isLoggedIn"
      :images="images"
      @add-like="addLike"
      @find-like-id="findLikeId"
      @delete-like="deleteLike"
      @not-login-user-click="notLoginUserClick"
    />
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import { handleFailure } from '@/plugins/error-handler';
import SampleList from '@/components/Sample/SampleList.vue';
export default {
  components: {
    SampleList,
  },
  data() {
    return {
      isLoading: false,
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
    if (Number(this.$route.params.id) !== Number(this.$auth.user.id)) {
      this.$router.push('/');
    }
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
    async addLike(sampleId) {
      if (this.isLoading) return;
      this.isLoading = true;
      try {
        await this.$axios.$post('/api/v1/likes/', {
          like: {
            sample_id: sampleId,
            user_id: this.$auth.user.id
          }
        });
        await this.getSamples()
      } catch (error) {
        handleFailure(error, this.$store);
      } finally {
        this.isLoading = false;
      }
    },
    findLikeId(sample) {
      const likeObject = sample.likes.find(like => like.user_id === this.$auth.user.id);
      return likeObject ? likeObject.id : null;
    },
    async deleteLike(likeId) {
      if (this.isLoading) return;
      this.isLoading = true;
      try {
        await this.$axios.$delete(`/api/v1/likes/${likeId}`);
        await this.getSamples()
      } catch (error) {
        handleFailure(error, this.$store);
      } finally {
        this.isLoading = false;
      }
    },
    notLoginUserClick() {
      this.$store.dispatch('getToast', {
        msg: 'ログインユーザのみいいねをつけることができます',
        color: 'primary',
        timeout: 4000
      });
    },
  },
};
</script>

<style>
  .clickable {
    cursor: pointer;
  }
</style>
