class ChangeRepositoriesChartDataField < ActiveRecord::Migration
  def change
    change_column :repositories, :chart_data, :text
  end
end
