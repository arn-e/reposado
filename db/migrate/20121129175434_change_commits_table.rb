class ChangeCommitsTable < ActiveRecord::Migration
  def change
    remove_column :commits, :issue_id
    add_column :commits, :sha, :string
    add_column :commits, :parent_sha, :string
  end
end
