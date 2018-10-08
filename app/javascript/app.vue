<template>
<div class="container my-4">
  <div class="row">
    <div class="col-sm">
      <b-form>
        <div v-for="(groupInfo, groupName) in groupsWithOptions" :key="groupName">
          <div class="group-title">
            <h1 class="mb-0">{{groupName}}</h1>
            <b-btn v-b-toggle="groupName" size="sm" class="mb-3 ml-3">Toggle</b-btn>
            <p v-if="groupInfo.desc">{{groupInfo.desc}}</p>
          </div>
          <b-collapse :id="groupName" :visible="groupInfo.startOpen">
            <b-row v-for="(spec) in groupInfo.options" :key="spec.key" class="mb-3">
              <b-col cols="4" class="text-right">
                <b-form-group :label="spec.desc" :label-for="spec.key" class="mb-0" />
              </b-col>
              <b-col cols="8">
                <b-alert v-if="!spec.type" variant="danger" show>
                  No field type found for {{spec.key}}. Is it typed correctly?
                </b-alert>
                <b-form-checkbox v-else-if="spec.type === 'boolean'" v-model="selected[spec.key]">{{spec.enableVerb}}</b-form-checkbox>
                <b-form-input v-else-if="spec.type === 'integer'" v-model="selected[spec.key]" type="number" pattern="\d*" />
                <b-form-input v-else-if="spec.type === 'float'" v-model="selected[spec.key]" type="number" />
                <b-form-input v-else-if="spec.type === 'string'" v-model="selected[spec.key]" />
                <b-form-select v-else-if="spec.type === 'select'" v-model="selected[spec.key]" :options="spec.options" />
                <b-alert v-else variant="danger" show>
                  Could not generate form field for {{spec.key}} (type: "{{spec.type}}")
                </b-alert>
              </b-col>
            </b-row>
          </b-collapse>
        </div>
      </b-form>
    </div>
  </div>
</div>
</template>

<script>
import options from './options.yml'
import optionGroups from './option_groups.yml'
import { map } from 'ramda'

const fetchDefaults = map(spec => spec.default)
const mergeOptionsIntoGroups = map(groupInfo => {
    const relevantOptions = []
    groupInfo.options.forEach(key => 
      relevantOptions.push({key, ...options[key]}))
    return Object.assign({}, groupInfo, {options: relevantOptions})
  }
)

console.log({optionGroups})
const groupsWithOptions = mergeOptionsIntoGroups(optionGroups)
console.log({groupsWithOptions})

export default {
  data: () => ({
    groupsWithOptions,
    selected: fetchDefaults(options)
  })
}
</script>

<style lang="stylus" scoped>
.group-title h1
  display: inline-block
</style>
