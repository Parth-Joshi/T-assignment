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
require "test_helper"

class TimeEventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end