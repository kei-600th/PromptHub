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
      tasks: []
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
