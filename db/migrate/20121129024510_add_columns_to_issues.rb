class AddColumnsToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :git_issue_number, :integer
    add_column :issues, :git_created_at, :datetime
    add_column :issues, :git_updated_at, :datetime
  end
end
