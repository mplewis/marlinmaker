# frozen_string_literal: true

class Configurator
  OPTIONS_PATH = Rails.root.join(*%w(app javascript options.yml)).freeze
  OPTIONS = YAML.load_file(OPTIONS_PATH).deep_symbolize_keys.freeze

  MANDATORY = OPTIONS.select { |k, v| v[:mandatory] }.map(&:first).freeze
  BOOLEAN = OPTIONS.select { |k, v| v[:type] == 'boolean' }.map(&:first).freeze
  INTEGER = OPTIONS.select { |k, v| v[:type] == 'integer' }.map(&:first).freeze
  FLOAT = OPTIONS.select { |k, v| v[:type] == 'float' }.map(&:first).freeze

  INCLUSION = OPTIONS.select { |k, v| v[:options] }
                     .map { |k, v| [k, v[:options].map(&:first).map { |v| v && v.to_s }] }
                     .to_h.freeze

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
      errors[key] << "Value for key #{key.inspect} must be a float, got #{value.inspect}"
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
    @params
  end

  def render(*args, **kwargs)
    ApplicationController.renderer.render *args, **kwargs
  end

  class InvalidParamsError < StandardError; end
end
