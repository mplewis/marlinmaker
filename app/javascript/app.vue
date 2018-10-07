<template>
<div class="container my-4">
  <div class="row">
    <div class="col-sm">
      <b-form>
        <div v-for="(spec, key) in options" :key="key" class="mb-3">
          <b-form-group :label="spec.desc" :label-for="key">
            <b-form-checkbox v-if="spec.type === 'boolean'" v-model="selected[key]">Enable</b-form-checkbox>
            <b-form-input v-else-if="['integer', 'float'].includes(spec.type)" v-model="selected[key]" type="number" />
            <b-form-select v-else-if="spec.type === 'select'" v-model="selected[key]" :options="spec.options" />
            <b-alert v-else variant="danger" show>Could not generate form field of type {{spec.type}} for {{key}}</b-alert>
          </b-form-group>
        </div>
      </b-form>
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
