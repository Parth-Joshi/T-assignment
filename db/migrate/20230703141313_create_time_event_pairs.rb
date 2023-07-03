class CreateTimeEventPairs < ActiveRecord::Migration[7.0]
  def change
    create_table :time_event_pairs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ci_time_event, null: false, foreign_key: { to_table: :time_events }
      t.references :co_time_event, null: true, foreign_key: { to_table: :time_events }
      t.datetime :time_spent

      t.timestamps
    end
  end
end
