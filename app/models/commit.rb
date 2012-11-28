class Commit < ActiveRecord::Base
  belongs_to :issue

  validates_presence_of :user, :date
end
