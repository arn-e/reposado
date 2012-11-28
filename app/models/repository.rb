require './lib/github_data_processor.rb'

class Repository < ActiveRecord::Base
  include GithubDataProcessor

  has_many :issues
  validates_presence_of :name, :url
end
