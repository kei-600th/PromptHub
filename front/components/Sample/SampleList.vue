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
          height="150"
          gradient="to bottom, rgba(0,0,0,.5), rgba(0,0,0,.5)"
          class="white--text align-end clickable"
          @click="$router.push(`/sample/${sample.id}`)"
        >
          <v-card-subtitle>
            {{ sample.category.name }}
          </v-card-subtitle>
          <v-card-title>
            {{ sample.title }}
          </v-card-title>
          <v-row class="ma-2">
            <!-- いいねアイコン -->
            <div>
              <!-- ログインしている時 -->
              <div v-if="isLoggedIn">
                <!-- ユーザーがいいねをつけていない時 -->
                <div
                  v-if="
                    !sample.likes.some((like) => like.user_id === $auth.user.id)
                  "
                >
                  <v-icon :color="heartColor" @click.stop="addLike(sample.id)"
                    >mdi-heart-outline</v-icon
                  >
                </div>
                <!-- ユーザーがいいねをつけている時 -->
                <div v-else>
                  <v-icon
                    :color="heartColor"
                    @click.stop="deleteLike(findLikeId(sample))"
                    >mdi-heart</v-icon
                  >
                </div>
              </div>
              <!-- ログインしていない時 -->
              <div v-else>
                <v-icon
                  :color="heartColor"
                  :disabled="isLoading"
                  @click.stop="notLoginUserClick"
                  >mdi-heart-outline</v-icon
                >
              </div>
            </div>
            <!-- いいね数 -->
            <div v-if="sample.likes.length > 0">
              <span class="white--text ma-1">{{ sample.likes.length }}</span>
            </div>
          </v-row>
        </v-img>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
    samples: {
      type: Array,
      required: true,
    },
    isLoggedIn: {
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
