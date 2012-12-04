class RemoveLimitFromRepositoriesChartData < ActiveRecord::Migration
  def up
    remove_column :repositories, :chart_data
    add_column :repositories, :chart_data, :text
  end

end
