<template>
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
          :src="images[sample.category_id - 1]"
          height="180"
          gradient="to bottom, rgba(0,0,0,.5), rgba(0,0,0,.5)"
          class="white--text align-end clickable"
          @click="$router.push(`/sample/${sample.id}`)"
        >
          <v-card-subtitle style="position: absolute; top:0;">
            {{ sample.category.name }}
          </v-card-subtitle>
          <v-card-title class="fixed-height-title">
            {{ sample.title }}
          </v-card-title>
          <LikeCount
          :sample="sample"
          :is-logged-in="isLoggedIn"
          :is-loading="isLoading"
          :heart-color="heartColor"
          @add-like="addLike"
          @delete-like="deleteLike"
          @not-login-user-click="notLoginUserClick"
        />
        </v-img>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import LikeCount from '@/components/Like/LikeCount.vue';
export default {
  components: {
    LikeCount,
  },
  props: {
    samples: {
      type: Array,
      required: true,
    },
    isLoggedIn: {
      type: Boolean,
      required: true,
    },
    isLoading: {
      type: Boolean,
      required: true,
    },
    card: {
      type: Object,
      required: true,
    },
    images: {
      type: Array,
      required: true,
    },
    heartColor: {
      type: String,
      required: true,
    },
  },
  methods: {
    // 必要なメソッドもこちらに
    addLike(sampleId) {
      this.$emit('add-like', sampleId);
    },
    findLikeId(sample) {
      const likeObject = sample.likes.find(
        (like) => like.user_id === this.$auth.user.id,
      );
      return likeObject ? likeObject.id : null;
    },
    deleteLike(likeId) {
      this.$emit('delete-like', likeId);
    },
    notLoginUserClick() {
      this.$emit('not-login-user-click');
    },
  },
};
</script>

<style scoped>
.fixed-height-title {
  height: 98px;
}
</style>
