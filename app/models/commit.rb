class Commit < ActiveRecord::Base
  belongs_to :repository

  validates_presence_of :git_user, :date
end

def self.from_json
end

