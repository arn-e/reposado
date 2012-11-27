class Issue < ActiveRecord::Base
  belongs_to :repository

  validates_presence_of :body, :title
end
