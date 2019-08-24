# == Schema Information
#
# Table name: configuration_data
#
#  id                      :bigint           not null, primary key
#  url_background_carousel :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class ConfigurationData < ApplicationRecord
  mount_uploader :url_background_carousel, ImagenUploader

  def self.configure
    ConfigurationData.first || ConfigurationData.new
  end

  def background_url
    url_background_carousel_url
  end

end
