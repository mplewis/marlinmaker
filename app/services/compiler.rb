class Compiler
  CONTAINER_NAME = 'th3d_ufw_compiler'.freeze
  OUTPUT_FILE = 'firmware.elf'.freeze

  def self.compile!(params)
    new(params).compile!
  end

  def initialize(params)
    @params = params
  end
  private_class_method :new

  def compile!
    config_header = Configurator.generate @params
    Dir.mktmpdir do |tmp_dir|
      # Docker doesn't handle symlinked paths properly
      @target_dir = Pathname.new(tmp_dir).realpath.to_s
      write_config_header! config_header
      copy_platformio_ini!
      run_service!
      return read_output
    end
  end

  private

  def write_config_header!(body)
    target = File.join @target_dir, 'Configuration.h'
    File.open(target, 'w') { |f| f.write body }
  end

  def copy_platformio_ini!
    src = Rails.root.join *%w(app views marlin platformio.ini)
    dst = File.join @target_dir, 'platformio.ini'
    FileUtils.cp src, dst
  end

  def run_service!
    exec(
      'docker', 'run',
      '--mount', "type=bind,source=#{@target_dir},target=/config",
      CONTAINER_NAME,
    )
  end

  def read_output
    target = File.join @target_dir, OUTPUT_FILE
    File.open(target, 'rb').read
  end

  def exec(*cmd)
    raise ShellCommandError, "Exit status #{$? >> 8} returned for #{cmd.join ' '}" unless system *cmd
  end

  class ShellCommandError < StandardError; end
end
