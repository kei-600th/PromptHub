export default {
  computed: {
    isAdmin() {
      return this.$store.getters.isAdmin;
    },
    userId() {
      return this.$store.state.user.current
        ? this.$store.state.user.current.id
        : null;
    },
  },
  mounted() {
    if (this.userId) {
      this.params.user.id = this.userId;
    }
  },
};
