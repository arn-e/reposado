class AddColumnsToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :chart_data, :string
  end
end
