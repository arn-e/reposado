class AddChildObjectsLoadedFlagToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :child_objects_loaded, :boolean, :default => false

    Repository.all do |repo|
      repo.child_objects_loaded = true
      repo.save!
    end
  end
end
