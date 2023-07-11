<template>
  <v-navigation-drawer
    v-model="setDrawer"
    app
    clipped
    color="rgb(52,53,65)"
    dark
    :mobile-breakpoint="mobileBreakpoint"
  >
    <template
      v-if="isMobileBreakpointLessThan"
    >
      <v-list-item
        @click="$emit('update:drawer', false)"
      >
        <v-list-item-content
          class="text-center"
        >
          <v-list-item-action-text
            class="d-flex justify-center align-center"
          >
            <v-icon>
              mdi-chevron-double-left
            </v-icon>
            閉じる
          </v-list-item-action-text>
        </v-list-item-content>
      </v-list-item>
      <v-divider />
    </template>

    <v-divider />

    <v-list
      dense
      nav
    >
      <v-list-item
        v-for="item in items"
        :key="item.title"
        :to="item.path"
      >
        <v-list-item-icon>
          <v-icon>{{ item.icon }}</v-icon>
        </v-list-item-icon>

        <v-list-item-content>
          <v-list-item-title>{{ item.title }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
    <navigation-drawer-user-card />
  </v-navigation-drawer>
</template>

<script>
export default {
  props: {
    drawer: {
      type: Boolean,
      default: null
    }
  },
  data () {
    return {
      mobileBreakpoint: 960,
      items: [
        { title: 'Dashboard', path: '/', icon: 'mdi-view-dashboard' },
        { title: 'Workplace', path: 'workplace', icon: 'mdi-notebook-edit ' },
        { title: 'Share', path: 'share', icon: 'mdi-crowd ' },
        { title: 'About', path: 'about', icon: 'mdi-help-box' }
      ],
      right: null
    }
  },
  computed: {
    setDrawer: {
      get () { return this.drawer },
      set (newVal) { return this.$emit('update:drawer', newVal) }
    },
    isMobileBreakpointLessThan () {
      // 現在のビューポートの幅を取得しwindowwidthに当てはめる
      const windowWidth = this.$vuetify.breakpoint.width
      return this.mobileBreakpoint > windowWidth
    }
  }
}
</script>
