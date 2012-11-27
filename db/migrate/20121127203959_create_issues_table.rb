class CreateIssuesTable < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :repository_id
      t.string  :title
      t.text    :body
      t.timestamps

    end
  end
end
