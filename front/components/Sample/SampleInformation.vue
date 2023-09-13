<template>
  <div>
    <v-card
      color="#EBECEE"
      class="sample-information-card mt-6 py-2 rounded-xl"
    >
      <!-- タイトル -->
      <v-card-title class="sample-information-card-title my-4">
        <h2>
          {{ sample.title }}
        </h2>
      </v-card-title>
      <!-- タグとアイコン -->
      <div class="sample-information-card-chip my-4">
        <v-chip class="ml-3" color="primary">
          <strong>
            {{ sample.prompts[0].gpt_model }}
          </strong>
        </v-chip>
        <v-chip class="ml-2" color="primary">
          <strong>
            {{ sample.category.name }}
          </strong>
        </v-chip>
        <v-spacer></v-spacer>
        <div class="mr-2">
          <LikeCount
            :sample="sample"
            :is-logged-in="isLoggedIn"
            :is-loading="isLoading"
            :heart-color="heartColor"
            @add-like="addLike"
            @delete-like="deleteLike"
            @not-login-user-click="notLoginUserClick"
          />
        </div>
      </div>
      <!-- 説明文 -->
      <v-card-text class="sample-information-card-description my-6">
        <v-icon class="mr-1">mdi-information-slab-circle-outline</v-icon>
        <h2>
          {{ sample.description }}
        </h2>
      </v-card-text>
    </v-card>
  </div>
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
.sample-information-card-chip {
  display: flex;
  justify-content: space-between;
}

.sample-information-card-description {
  display: flex;
}
</style>
