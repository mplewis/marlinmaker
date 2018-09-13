class Configurator
  DEFAULTS = {
    ezabl_points: 4,
    ezabl_probe_edge: 15,
    ezabl_outside_grid_compensation: true,
    custom_esteps_value: 999,
    titan_extruder_steps: 463,
    dual_hotend_x_distance: 18.0,
    x_home_location: -10,
    y_home_location: -10,
    linear_advance_k: 0,
    lcd_language: 'en',
  }

  MANDATORY = %i(
    board_name
  )

  BOOLEAN = %i(
    ezout_enable
    ezabl_outside_grid_compensation
    ezabl_fastprobe
    babystep_offset
    probing_motors_off
    heaters_on_during_probing
    custom_esteps
    titan_extruder
    ac_bed
    pidbed_disable
    fan_fix
    manual_mesh_leveling
    power_loss_recovery
    home_adjust
    linear_advance
    new_jerk_control
    new_acceleration_control
  )

  INCLUSION = {
    board_name: %w(CR10 CR10_MINI CR10_S4 CR10_S5),
    thermistor: %w(v6_hotend th3d_hotend_thermistor th3d_bed_thermistor keenovo_tempsensor),
    boot_screen: %w(tm3d_boot ender_boot disable_boot)
  }

  class << self
    def generate(params)
      data = DEFAULTS.merge params
      render 'marlin/configuration.txt', assigns: { params: data }
    end

    private

    def render(*args, **kwargs)
      ApplicationController.renderer.render *args, **kwargs
    end
  end
end

