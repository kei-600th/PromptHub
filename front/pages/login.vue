<template>
  <user-form-card>
    <template
      #user-form-card-content
    >
      <v-form
      ref="form"
      v-model="isValid"
      >
        <user-form-email
          :email.sync="params.auth.email"
        />
        <user-form-password
          :password.sync="params.auth.password"
        />
        <v-card-actions>
          <nuxt-link
            to="#"
            class="body-2 text-decoration-none"
          >
            パスワードを忘れた?
          </nuxt-link>
        </v-card-actions>
        <v-card-text
        class="px-0"
        >
          <v-btn
            :disabled="!isValid || loading"
            :loading="loading"
            block
            color="appblue"
            class="white--text"
            @click="login"
          >
            ログインする
            </v-btn>
        </v-card-text>
      </v-form>
      <v-card-text>
      </v-card-text>
    </template>
  </user-form-card>
</template>

<script>

export default {
  layout: 'beforeLogin',
  data () {
    return {
      isValid: false,
      loading: false,
      // TODO 削除する
      params: { auth: { email: 'user0@example.com', password: 'password' } }
    }
  },
  methods: {
    async login () {
      this.loading = true
      if (this.isValid) {
        await this.$axios.$post('/api/v1/auth_token', this.params)
          .then(response => this.authSuccessful(response))
          .catch(error => this.authFailure(error))
      }
      this.loading = false
    },
    authSuccessful (response) {
      console.log('authSuccessful', response)
      this.$auth.login(response)
      // test
      console.log('token', this.$auth.token)
      console.log('expires', this.$auth.expires)
      console.log('payload', this.$auth.payload)
      console.log('user', this.$auth.user)
      // TODO リダイレクト処理
      this.$router.push('/')
    },
    authFailure ({ response }) {
      if (response && response.status === 404) {
        // TODO トースター出力
      }
      // TODO エラー処理
    }
  }
}
</script>
