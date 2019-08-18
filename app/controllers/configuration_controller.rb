class ConfigurationController < ApplicationController
  def quotation_printing_modal_image
    @configuration = ConfigurationData.configure
    @configuration.update configuration_params

    render json: {url: @configuration.background_url}
  end

  private

  def configuration_params
    params.require(:configuration).permit(:url_background_carousel)
  end
end
