class Repository < ActiveRecord::Base
  has_many :issues
  validates_presence_of :name, :url
end
