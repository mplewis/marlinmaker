class CompileController < ApplicationController
  skip_before_action :verify_authenticity_token

  def validate
    render json: { errors: Configurator.errors(configuration_params) }
  end

  private

  def configuration_params
    params.require(:configuration).permit!
  end
end
