class Issue < ActiveRecord::Base
  belongs_to :repository
  has_many :commits
  has_many :comments
  has_many :events
  validates_presence_of :title
end
