<template>
<div class="container">
  <div class="row">
    <div class="col-sm">
      <p>{{ message }}</p>
      <b-button variant="success">
        BootstrapVue works!
      </b-button>
    </div>
  </div>
</div>
</template>

<script>
export default {
  data: function() {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped lang="stylus">
p
  color: navy
</style>
