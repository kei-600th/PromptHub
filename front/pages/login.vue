<template>
  <user-form-card>
    <template #user-form-card-content>
      <v-form ref="form" v-model="isValid">
        <user-form-email :email.sync="params.auth.email" />
        <user-form-password :password.sync="params.auth.password" />
        <v-card-actions>
          <nuxt-link to="#" class="body-2 text-decoration-none">
            パスワードを忘れた?
          </nuxt-link>
        </v-card-actions>
        <v-card-text class="px-0">
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
      <v-card-text />
    </template>
  </user-form-card>
</template>

<script>
export default {
  layout: 'beforeLogin',
  data() {
    return {
      isValid: false,
      loading: false,
      // TODO 削除する
      params: { auth: { email: 'user0@example.com', password: 'password' } },
    };
  },
  methods: {
    async login() {
      if (!this.isValid) return;
      this.loading = true;
      try {
        const response = await this.$axios.$post('/api/v1/auth_token', this.params);
        this.authSuccessful(response);
      } catch (error) {
        this.authFailure(error);
      } finally {
        this.loading = false;
      }
    },
    authSuccessful(response) {
      this.$auth.login(response);
      this.$router.push('/');
    },
    authFailure({ response }) {
      if (response && response.status === 404) {
        const msg = 'ユーザーが見つかりません';
        return this.$store.dispatch('getToast', { msg });
      }
      // TODO エラー処理
    },
  },
};
</script>
