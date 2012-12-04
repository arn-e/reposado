class RemoveLimitFromRepositoriesChartData < ActiveRecord::Migration
  def up
    add_column :repositories, :chart_data, :text
  end

  def down
    remove_column :repositories, :chart_data
  end
end
