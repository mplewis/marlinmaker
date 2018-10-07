<template>
<div class="container my-4">
  <div class="row">
    <div class="col-sm">
      <b-form>
        <b-row v-for="(spec, key) in options" :key="key" class="mb-3">
          <b-col cols="4" class="text-right">
            <b-form-group :label="spec.desc" :label-for="key" class="mb-0" />
          </b-col>
          <b-col cols="8">
            <b-form-checkbox v-if="spec.type === 'boolean'" v-model="selected[key]">Enable</b-form-checkbox>
            <b-form-input v-else-if="spec.type === 'integer'" v-model="selected[key]" type="number" pattern="\d*" />
            <b-form-input v-else-if="spec.type === 'float'" v-model="selected[key]" type="number" />
            <b-form-select v-else-if="spec.type === 'select'" v-model="selected[key]" :options="spec.options" />
            <b-alert v-else variant="danger" show>
              Could not generate form field of type {{spec.type}} for {{key}}
            </b-alert>
          </b-col>
        </b-row>
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
