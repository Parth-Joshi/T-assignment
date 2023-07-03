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

  after_create :log_time_event_pair

  def log_time_event_pair
    case self.event_type
    when 'clock_in'
      TimeEventPair.create(user: self.user, ci_time_event: self)
      
    when 'clock_out'
      last_clocked_in_time_event_pair = self.user.time_event_pairs.last
      time_spent = Time.at(self.created_at - last_clocked_in_time_event_pair.ci_time_event.created_at)
      
      last_clocked_in_time_event_pair.update(co_time_event: self, time_spent: time_spent)
    end
  end
end
