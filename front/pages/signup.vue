<template>
  <user-form-card>
    <template #user-form-card-content>
      <v-form ref="form" v-model="isValid" @submit.prevent="signup">
        <user-form-name :name.sync="params.auth.name" />
        <user-form-email :email.sync="params.auth.email" placeholder />
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
      params: { auth: { name: '', email: '', password: '' } },
    };
  },
  methods: {
    async signup() {
      if (!this.isValid) return;
      this.loading = true;
      try {
        const response = await this.$axios.$post('/api/v1/auth_token/registration', this.params);
        this.authSuccessful(response);
      } catch (error) {
        this.authFailure(error);
      } finally {
        this.formReset();
        this.loading = false;
      }
    },
    authSuccessful(response) {
      this.$auth.login(response);
      this.$router.push('/');
    },
    authFailure(error) {
      if (error.response && error.response.status === 422) {
        // エラーメッセージを受け取る
        const msg = error.response.data.errors.join(', ');
        return this.$store.dispatch('getToast', { msg });
      }
    },
    formReset() {
      this.$refs.form.reset();
      for (const key in this.params.auth) {
        this.params.auth[key] = '';
      }
    },
  },
};
</script>
