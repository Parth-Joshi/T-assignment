# == Schema Information
#
# Table name: time_events
#
#  id         :bigint           not null, primary key
#  event_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_time_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class TimeEvent < ApplicationRecord
  belongs_to :user

  enum event_type: { 'clock_in': 0, 'clock_out': 1 }
end
