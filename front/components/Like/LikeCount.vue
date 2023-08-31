<template>
  <v-row class="ma-2">
    <!-- いいねアイコン -->
    <div>
      <!-- ログインしている時 -->
      <div v-if="isLoggedIn">
        <!-- ユーザーがいいねをつけていない時 -->
        <div v-if="!sample.likes.some((like) => like.user_id === $auth.user.id)">
          <v-icon :color="heartColor" @click.stop="addLike(sample.id)">mdi-heart-outline</v-icon>
        </div>
        <!-- ユーザーがいいねをつけている時 -->
        <div v-else>
          <v-icon :color="heartColor" @click.stop="deleteLike(findLikeId(sample))">mdi-heart</v-icon>
        </div>
      </div>
      <!-- ログインしていない時 -->
      <div v-else>
        <v-icon :color="heartColor" @click.stop="notLoginUserClick">mdi-heart-outline</v-icon>
      </div>
    </div>
    <!-- いいね数 -->
    <div v-if="sample.likes.length > 0">
      <span :color="heartColor" class="ma-1">{{ sample.likes.length }}</span>
    </div>
  </v-row>
</template>

<script>
export default {
  props: {
    sample: {
      type: Object,
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
    heartColor: {
      type: String,
      required: true,
    },
  },
  methods: {
    addLike(sampleId) {
      this.$emit('add-like', sampleId);
    },
    findLikeId(sample) {
      const likeObject = sample.likes.find(
        (like) => like.user_id === this.$auth.user.id
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
