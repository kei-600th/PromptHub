export default {
  data() {
    return {
      isLoading: false,
    };
  },
  methods: {
    async addLike(sampleId) {
      if (this.isLoading) return;
      this.isLoading = true;
      try {
        await this.$axios.$post('/api/v1/likes/', {
          like: {
            sample_id: sampleId,
            user_id: this.$auth.user.id,
          },
        });
        if (typeof this.getSamples === 'function') {
          await this.getSamples();
        } else if (typeof this.getSample === 'function') {
          await this.getSample();
        }
      } catch (error) {
        this.handleFailure(error, this.$store);
      } finally {
        this.isLoading = false;
      }
    },
    findLikeId(sample) {
      const likeObject = sample.likes.find(
        (like) => like.user_id === this.$auth.user.id,
      );
      return likeObject ? likeObject.id : null;
    },
    async deleteLike(likeId) {
      if (this.isLoading) return;
      this.isLoading = true;
      try {
        await this.$axios.$delete(`/api/v1/likes/${likeId}`);
        if (typeof this.getSamples === 'function') {
          await this.getSamples();
        } else if (typeof this.getSample === 'function') {
          await this.getSample();
        }
      } catch (error) {
        this.handleFailure(error, this.$store);
      } finally {
        this.isLoading = false;
      }
    },
    notLoginUserClick() {
      this.$store.dispatch('getToast', {
        msg: 'ログインユーザのみいいねをつけることができます',
        color: 'primary',
        timeout: 4000,
      });
    },
  },
};
