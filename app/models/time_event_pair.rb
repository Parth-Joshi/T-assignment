# == Schema Information
#
# Table name: time_event_pairs
#
#  id               :bigint           not null, primary key
#  time_spent       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  ci_time_event_id :bigint           not null
#  co_time_event_id :bigint
#  user_id          :bigint           not null
#
# Indexes
#
#  index_time_event_pairs_on_ci_time_event_id  (ci_time_event_id)
#  index_time_event_pairs_on_co_time_event_id  (co_time_event_id)
#  index_time_event_pairs_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (ci_time_event_id => time_events.id)
#  fk_rails_...  (co_time_event_id => time_events.id)
#  fk_rails_...  (user_id => users.id)
#
class TimeEventPair < ApplicationRecord
  belongs_to :user
  belongs_to :ci_time_event, class_name: 'TimeEvent'
  belongs_to :co_time_event, class_name: 'TimeEvent', optional: true
end
