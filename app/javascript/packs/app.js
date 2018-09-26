import Vue from 'vue'
import BootstrapVue from 'bootstrap-vue'
import App from '../app.vue'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(BootstrapVue)

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('app'))
  // eslint-disable-next-line no-new
  new Vue({
    el,
    render: h => h(App)
  })
})
