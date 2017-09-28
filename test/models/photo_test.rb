# == Schema Information
#
# Table name: photos
#
#  id          :integer          not null, primary key
#  image_data  :string
#  user_id     :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location    :string
#  latitude    :float
#  longitude   :float
#

require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
