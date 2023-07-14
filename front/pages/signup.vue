<template>
  <div>
    <v-alert v-if="errorMessage" type="error" :value="true" dismissible>{{ errorMessage }}</v-alert>
    <user-form-card>
      <template
        #user-form-card-content
      >
        <v-form
        ref="form"
        v-model="isValid"
        @submit.prevent="signup"
        >
          <user-form-name
            :name.sync="params.auth.name"
          />
          <user-form-email
            :email.sync="params.auth.email"
            placeholder
          />
          <user-form-password
            :password.sync="params.auth.password"
            set-validation
          />
          <v-btn
          type="submit"
          :disabled="!isValid || loading"
          :loading="loading"
          block
          color="appblue"
          class="white--text"
        >
          登録する
          </v-btn>
        </v-form>
        <v-card-text>
        </v-card-text>
      </template>
    </user-form-card>
  </div>
</template>

<script>

export default {
  layout: 'beforeLogin',
  data () {
    return {
      isValid: false,
      loading: false,
      errorMessage: null,
      params: { auth: { name: '', email: '', password: '' } }
    }
  },
  methods: {
    async signup () {
      this.loading = true
      if (this.isValid) {
        await this.$axios.$post('/api/v1/auth_token/registration', this.params)
          .then(response => this.authSuccessful(response))
          .catch((error) => {
            this.authFailure(error)
          })
      }
      this.formReset()
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
    authFailure (error) {
      if (error.response && error.response.status === 422) {
        // エラーメッセージを受け取る
        const messages = error.response.data.errors
        this.errorMessage = messages.join(', ')
      }
    },
    formReset () {
      this.$refs.form.reset()
      for (const key in this.params.auth) {
        this.params.auth[key] = ''
      }
    }
  }
}
</script>
