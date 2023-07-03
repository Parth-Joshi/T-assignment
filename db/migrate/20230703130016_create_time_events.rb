class CreateTimeEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :time_events do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :event_type, limit: 1

      t.timestamps
    end
  end
end
