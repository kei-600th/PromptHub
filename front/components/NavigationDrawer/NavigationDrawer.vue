<template>
  <v-navigation-drawer
    v-model="setDrawer"
    app
    clipped
    color="rgb(52,53,65)"
    dark
    :mobile-breakpoint="mobileBreakpoint"
  >
    <template v-if="isMobileBreakpointLessThan">
      <v-list-item @click="$emit('update:drawer', false)">
        <v-list-item-content class="text-center">
          <v-list-item-action-text class="d-flex justify-center align-center">
            <v-icon> mdi-chevron-double-left </v-icon>
            閉じる
          </v-list-item-action-text>
        </v-list-item-content>
      </v-list-item>
      <v-divider />
    </template>

    <v-divider />

    <v-list dense nav>
      <v-list-item v-for="item in items" :key="item.title" :to="item.path">
        <v-list-item-icon>
          <v-icon>{{ item.icon }}</v-icon>
        </v-list-item-icon>

        <v-list-item-content>
          <v-list-item-title>{{ item.title }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
    <div v-if="isLoggedIn">
      <navigation-drawer-user-card />
    </div>
  </v-navigation-drawer>
</template>

<script>
import { mapGetters } from 'vuex';
import isMobileBreakpoint from '~/mixins/isMobileBreakpoint';
export default {
  mixins: [isMobileBreakpoint],
  props: {
    drawer: {
      type: Boolean,
      default: null,
    },
  },
  data() {
    return {
      right: null,
    };
  },
  computed: {
    ...mapGetters(['isLoggedIn', 'isAdmin']),
    items() {
      const baseItems = [
        { title: 'Home', path: '/', icon: 'mdi-home' },
        { title: 'About', path: '/about', icon: 'mdi-help-box' },
      ];
      if (this.isLoggedIn) {
        baseItems.push({
          title: 'UserPage',
          path: `/user/${this.$auth.user.id}`,
          icon: 'mdi-notebook-edit ',
        });
      }
      if (this.isAdmin) {
        baseItems.push({
          title: 'Admin',
          path: '/admin',
          icon: 'mdi-monitor-dashboard',
        });
      }
      return baseItems;
    },
    setDrawer: {
      get() {
        return this.drawer;
      },
      set(newVal) {
        return this.$emit('update:drawer', newVal);
      },
    },
  },
};
</script>
