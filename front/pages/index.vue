<template>
  <div class="container">
    <div>
      <h1 class="title">
        Zenn-app
      </h1>
      <h2 class="subtitle">
        {{ subTitle }}
      </h2>
      <v-btn @click="getSomething">
        タスク取得
      </v-btn>
      <ul v-for=" task in tasks" :key="task.id">
        <li style="text-align: left;">{{ task.title }}</li>
      </ul>
    </div>
    <v-container>
      <v-card>
        <v-card-title>
          VuetifyカスタムCSSの検証
        </v-card-title>
        <v-card-text>
          ipad（768px）とmobile（426px）で表示・非表示
        </v-card-text>
        <v-card-text>
          <v-card
            v-for="(cls, i) in customClass"
            :key="`cls-${i}`"
            :color="cls.color"
            :class="cls.name"
          >
            <v-card-text>
              {{ cls.des }}
            </v-card-text>
          </v-card>
        </v-card-text>
        <v-card-title>
          nuxt-i18nの検証
        </v-card-title>
        <v-card-text>
          <v-simple-table dense>
            <template v-slot:default>
              <thead>
                <tr>
                  <th>en</th>
                  <th>ja</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="(path, i) in ['signup', 'login']"
                  :key="`path-${i}`"
                >
                  <td>{{ path }}</td>
                  <td>{{ $t(`title.${path}`) }}</td>
                </tr>
              </tbody>
            </template>
          </v-simple-table>
        </v-card-text>
      </v-card>
    </v-container>
  </div>
</template>

<script>
export default {
  data () {
    return {
      subTitle: 'Zenn is great service!!',
      tasks: [],
      colors: ['primary', 'info', 'success', 'warning', 'error', 'background'],
      customClass: [
        { name: 'hidden-ipad-and-down', color: 'error', des: 'ipad未満で隠す' },
        { name: 'hidden-ipad-and-up', color: 'info', des: 'ipad以上で隠す' },
        { name: 'hidden-mobile-and-down', color: 'success', des: 'mobile未満で隠す' },
        { name: 'hidden-mobile-and-up', color: 'warning', des: 'mobile以上で隠す' }
      ]
    }
  },
  methods: {
    async getSomething () {
      const response = await this.$axios.$get('/api/v1/tasks')
      this.tasks = JSON.parse(response.tasks)
    }
  }
}
</script>
