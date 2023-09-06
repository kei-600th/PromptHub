<template>
  <div>
    <v-card-title class="text-h4">
      {{ sample.title }}
    </v-card-title>
    <v-row>
      <div class="ml-6 mt-4">
        <v-chip color="primary">
          {{ sample.prompts[0].gpt_model }}
        </v-chip>
        <v-chip class="ml-2" color="primary">
          {{ sample.category.name }}
        </v-chip>
      </div>
      <v-spacer></v-spacer>
      <div class="mr-4">
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
    </v-row>
    <v-card-subtitle class="text-h6 my-2">
      {{ sample.description }}
    </v-card-subtitle>
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
