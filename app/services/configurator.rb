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
  }.freeze

  MANDATORY = %i(
    board_name
  ).freeze

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
  ).freeze

  INTEGER = %i(
    ezabl_points
    ezable_probe_edge
    x_probe_offset_from_extruder
    y_probe_offset_from_extruder
    custom_esteps_value
    titan_extruder_steps
    x_home_location
    y_home_location
    linear_advance_k
  ).freeze

  FLOAT = %i(
    dual_hotend_x_distance
  ).freeze

  INCLUSION = {
    board_name: %w(CR10 CR10_MINI CR10_S4 CR10_S5),
    thermistor: %w(v6_hotend th3d_hotend_thermistor th3d_bed_thermistor keenovo_tempsensor),
    boot_screen: %w(tm3d_boot ender_boot disable_boot)
  }.freeze

  def self.generate(params)
    discovered_errors = errors(params)
    raise InvalidParamsError, "Invalid params: #{discovered_errors}" unless discovered_errors.empty?
    new(params).generate
  end

  def self.errors(params)
    new(params).errors
  end

  def initialize(params)
    @params = params.to_h.symbolize_keys
  end
  private_class_method :new

  def generate
    render 'marlin/configuration.txt', assigns: { params: data }
  end

  def errors
    errors = Hash.new { |h, k| h[k] = [] }

    MANDATORY.each do |key|
      next if data.keys.include? key
      errors[key] << "Missing mandatory key #{key.inspect}"
    end

    BOOLEAN.each do |key|
      value = data[key]
      next unless value
      next if [true, false].include? value
      errors[key] << "Value for key #{key.inspect} must be true or false, got #{value.inspect}"
    end

    INTEGER.each do |key|
      value = data[key]
      next if value == value.try(:to_i)
      errors[key] << "Value for key #{key.inspect} must be an integer, got #{value.inspect}"
    end

    FLOAT.each do |key|
      value = data[key]
      next if value == value.try(:to_f) || value == value.try(:to_i)
      errors[key] << "Value for key #{key.inspect} must be an integer, got #{value.inspect}"
    end

    INCLUSION.each do |key, expected_values|
      value = data[key]
      next unless value
      next if expected_values.include? value
      errors[key] << "Value for key #{key.inspect} must be one of #{expected_values.inspect}, got #{value.inspect}"
    end

    errors
  end

  private

  def data
    @data ||= DEFAULTS.merge(@params).compact
  end

  def render(*args, **kwargs)
    ApplicationController.renderer.render *args, **kwargs
  end

  class InvalidParamsError < StandardError; end
end
