# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_one :profile
  has_many :photos
  has_and_belongs_to_many :followers, class_name: 'User', join_table: :followers, foreign_key: :followed_id,
                          association_foreign_key: :follower_id
  has_and_belongs_to_many :following, class_name: 'User', join_table: :followers, foreign_key: :follower_id,
                          association_foreign_key: :followed_id
  
  def followed_by?(user)
    followers.exists?(user.id)
  end
  
  def toggle_followed_by(user)
    if followers.exists?(user.id)
      followers.destroy(user)
    else
      followers << user
    end
  end
end
