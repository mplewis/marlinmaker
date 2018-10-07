<template>
<div class="container my-4">
  <div class="row">
    <div class="col-sm">
      <div v-for="(spec, key) in options" :key="key" class="mb-3">
        <b-form-checkbox v-if="spec.type === 'boolean'" v-model="selected[key]">{{spec.desc}}</b-form-checkbox>
        <b-form-input v-if="spec.type === 'number'" v-model="selected[key]" type="number" :placeholder="spec.desc" />
        <b-form-select v-if="spec.type === 'select'" v-model="selected[key]" :options="spec.options" />
      </div>
    </div>
  </div>
</div>
</template>

<script>
import options from './options.yml'
import { map } from 'ramda'

const fetchDefaults = map(spec => spec.default)

export default {
  data: () => ({
    options,
    selected: fetchDefaults(options)
  })
}
</script>
