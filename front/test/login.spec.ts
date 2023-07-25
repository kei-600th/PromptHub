import { mount, createLocalVue } from '@vue/test-utils';
import Vuetify from 'vuetify';
import Vue from 'vue';
import login from '@/pages/login.vue';

Vue.use(Vuetify);

const localVue = createLocalVue();
let vuetify: Vuetify;
const stubs = {
  'user-form-card': true,
  'user-form-email': true,
  'user-form-password': true,
};

beforeAll(() => {
  vuetify = new Vuetify();
});

describe('login.vue', () => {
  it('render page name', () => {
    const wrapper = mount(login, {
      localVue,
      vuetify,
      stubs,
    });

    expect(wrapper.text()).toContain('ログインする');
  });
});
