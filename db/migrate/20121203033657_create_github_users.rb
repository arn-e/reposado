class CreateGithubUsers < ActiveRecord::Migration
  def change
    create_table :github_users do |t|
      t.integer :github_id
      t.text :login
      t.string :gravatar_id
      
      t.timestamps
    end
  end
end
