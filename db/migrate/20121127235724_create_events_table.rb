class CreateEventsTable < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :date
      t.string :user
      t.string :status, :default => "", :null => false
      t.integer :issue_id

      t.timestamps
    end
  end
end
