require './lib/github_data_processor.rb'
require './lib/github_handler.rb'

class Issue < ActiveRecord::Base
  include GithubDataProcessor

  belongs_to :repository
  has_many :comments
  has_many :events
  validates_presence_of :title

  def self.from_json(json, repo_id)
    issue = self.new
    issue.title = json["title"]
    issue.body = json["body"]
    issue.git_created_at = DateTime.parse(json["created_at"])
    issue.git_updated_at = DateTime.parse(json["updated_at"])
    issue.git_issue_number = json["number"]
    issue.repository_id = repo_id
    issue.save!
    comments_from_json(issue)
    events_from_json(issue)
  end

  def self.comments_from_json(issue)
    comments = GithubHandler.query_github_issue_data(issue.repository.name, issue.git_issue_number, "comments")
    if (comments.class == Array && comments != []) || (comments.class == Hash && comments["message"] != "Not Found")
        puts "*************************"
        puts "COMMENTS: #{comments}"
        puts "*************************"
        comments.each do |comment|
          new_comment          = Comment.from_json(comment)
          new_comment.issue_id = issue.id
          new_comment.save
        end
    end
  end

  def self.events_from_json(issue)
    events = GithubHandler.query_github_issue_data(issue.repository.name, issue.git_issue_number, "events")
    if (events.class == Array && events != []) || (events.class == Hash && events["message"] != "Not Found")
      events.each do |event|
        new_event          = Event.from_json(event)
        new_event.issue_id = issue.id
        new_event.save
      end
    end
  end

end
