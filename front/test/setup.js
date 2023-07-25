import Vue from 'vue'
import Vuetify from 'vuetify'
import { RouterLinkStub, config } from '@vue/test-utils'

Vue.use(Vuetify)

config.stubs['nuxt-link'] = RouterLinkStub;