class CreateTableRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :url, :default => "", :null => false
      t.string :name, :default => "", :null => false
      t.timestamps
    end

  end
end
