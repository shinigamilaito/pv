=begin

Catalog of contents to save the texts of the invitations.
Same use as the sample catalog, only the images will be text.

=end

# == Schema Information
#
# Table name: content_for_invitations
#
#  id             :bigint           not null, primary key
#  description    :text
#  image          :string
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :bigint
#  subcategory_id :bigint
#

class ContentForInvitation < ApplicationRecord
  belongs_to :category
  belongs_to :subcategory
end
