<template>
<div class="container my-4">
  <div class="row">
    <div class="col-sm">
      <b-form-select v-model="board_name" :options="settings.board_name.options" class="mb-3" />
      <b-form-input v-model="ezabl_points" placeholder="EZABL Points" type="number" class="mb-3" />
      <b-form-checkbox v-model="ezabl_outside_grid_compensation" class="mb-3">EZABL: Outside Grid Compensation</b-form-checkbox>
      <b-form-select v-model="lcd_language" :options="settings.lcd_language.options" class="mb-3" />
    </div>
  </div>
</div>
</template>

<script>
const settings = require('./settings.yml')

export default {
  data: () => ({
    settings,
    board_name: null,
    ezabl_points: 5,
    ezabl_outside_grid_compensation: true,
    lcd_language: 'en',
  })
}
</script>
