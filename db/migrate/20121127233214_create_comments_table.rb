class CreateCommentsTable < ActiveRecord::Migration
  def change
    create_table  :comments do |t|
      t.integer   :issue_id
      t.string    :user, :default => "", :null => false
      t.text      :body
      t.datetime  :date

      t.timestamps
    end
  end
end
