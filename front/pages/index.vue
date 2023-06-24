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
