class ChangeUserColumnsToGitUser < ActiveRecord::Migration
  def change
    rename_column :comments, :user, :git_user
    rename_column :commits, :user, :git_user
    rename_column :events, :user, :git_user
  end
end
