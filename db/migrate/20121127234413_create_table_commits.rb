class CreateTableCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :user
      t.datetime :date
      t.integer :issue_id
      t.timestamps
    end
  end
end
