const { environment } = require('@rails/webpacker')
const vue = require('./loaders/vue')

environment.loaders.append('vue', vue)
environment.loaders.append('yml', {
  test: /\.yml$/,
  use: [{ loader: 'json-loader' }, { loader: 'yaml-loader' }]
})
module.exports = environment
