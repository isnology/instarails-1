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

class Photo < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  
  belongs_to :user
  has_and_belongs_to_many :likers, class_name: 'User', join_table: :likes
  has_many :comments
  geocoded_by :location
  after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }

  def liked_by?(user)
    likers.exists?(user.id)
  end
  
  def toggle_liked_by(user)
    if likers.exists?(user.id)
      likers.destroy(user.id)
    else
      likers << user
    end
  end
  
end
