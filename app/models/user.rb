# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :time_events
  has_many :time_event_pairs

  has_many :followed_users, foreign_key: :follower_id, class_name: 'Follow'
  # Gives list of users which are followed BY current user
  has_many :followees, through: :followed_users
  
  has_many :following_users, foreign_key: :followee_id, class_name: 'Follow'
  # Gives list of users who follow current user
  has_many :followers, through: :following_users
end
