class Commit < ActiveRecord::Base
  belongs_to :issue
  attr_accessible :date, :user

  validates_presence_of :user, :date
end
