export default {
  computed: {
    isMobileBreakpointLessThan() {
      const windowWidth = this.$vuetify.breakpoint.width;
      return this.mobileBreakpoint > windowWidth;
    }
  },
  data() {
    return {
      mobileBreakpoint: 960,
    };
  }
};
