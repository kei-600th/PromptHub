<template>
  <div>
    <v-row class="ma-4">
      <v-icon class="mr-2">mdi-star-shooting-outline</v-icon>
      <h2>お気に入りのサンプル</h2>
    </v-row>
    <SampleList
      :samples="samples"
      :card="card"
      :is-logged-in="isLoggedIn"
      :is-loading="isLoading"
      :images="images"
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
import { mapGetters } from 'vuex';
import { handleFailure } from '@/plugins/error-handler';
import SampleList from '@/components/Sample/SampleList.vue';
import likeMixin from '@/mixins/likeMixin.js';
import sampleListCardMixin from '@/mixins/sampleListCardMixin.js';
export default {
  components: {
    SampleList,
  },
  mixins: [likeMixin, sampleListCardMixin],
  data() {
    return {
      categories: [{ id: null, name: 'すべてのカテゴリ' }],
      samples: [],
      pageLoading: true,
    };
  },
  computed: {
    ...mapGetters(['isLoggedIn']),
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
      this.pageLoading = true;
      try {
        const response = await this.$axios.$get('/api/v1/samples/favorite', {
          params: { user_id: Number(this.$route.params.id) }, // カテゴリIDをパラメータとして追加
        });
        this.samples = response;
      } catch (error) {
        handleFailure(error, this.$store);
      } finally {
        this.pageLoading = false;
      }
    },
  },
};
</script>
