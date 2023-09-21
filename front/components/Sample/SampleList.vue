<template>
  <div>
    <div v-if="pageLoading"></div>
    <div v-else-if="samples.length === 0">
      <div class="not-found-box mt-4">
        <v-img
          :src="require('@/assets/images/other/sample-not-found.jpeg')"
          alt="sample-not-found"
          class="not-found-img"
        ></v-img>
        <h3 class="mt-3">まだサンプルが登録されてません</h3>
      </div>
    </div>
    <div v-else>
      <v-row>
        <v-col
          v-for="(sample, index) in samples"
          :key="index"
          cols="6"
          :sm="card.sm"
          :md="card.md"
          :lg="card.lg"
          :xl="card.xl"
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
              <v-card-subtitle style="position: absolute; top: 0">
                {{ sample.category.name }}
              </v-card-subtitle>
              <v-card-subtitle
                :class="
                  isMobileBreakpointLessThan
                    ? 'mobile-card-title font-weight-bold'
                    : 'unmobile-card-title text-h6'
                "
              >
                {{ sample.title }}
              </v-card-subtitle>
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
    </div>
  </div>
</template>

<script>
import LikeCount from '@/components/Like/LikeCount.vue';
import isMobileBreakpoint from '~/mixins/isMobileBreakpoint';
export default {
  components: {
    LikeCount,
  },
  mixins: [isMobileBreakpoint],
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
    pageLoading: {
      type: Boolean,
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
.mobile-card-title {
  height: 92px;
}

.unmobile-card-title {
  height: 98px;
}

.clickable {
  transition: transform 0.3s ease;
  cursor: pointer;
}

.clickable:hover {
  transform: scale(1.05);
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.3);
}

.not-found-box {
  max-width: 400px;
  max-height: 400px;
  text-align: center;
}
</style>
