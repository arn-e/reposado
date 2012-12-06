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
    # comments_from_json(issue)
    # events_from_json(issue)
  end

  def self.query_pool(repo_id)
    pool = []
    Repository.find(repo_id).issues.each do |issue|
      pool << [issue.id, issue.repository.name, issue.git_issue_number, repo_id]
    end
    [pool, repo_id]
  end

  def self.parsed_multi_response(multi_response, repo_id)
    Repository.find(repo_id).issues.each do |issue|
      ["comments", "events"].each do |data_type|
        ident = "#{issue.id}_#{data_type}"
        if multi_response[ident] != nil
          response = JSON.parse(multi_response[ident].response)
          data_type == "comments" ? new_comment(response, issue.id) : new_event(response, issue.id)
        end
      end
    end
  end

  def self.comments_from_json(issue)
    GithubHandler.query_github_issue_data(issue.repository.name, issue.git_issue_number, "comments", issue.id)
  end

  def self.new_comment(response, issue_id)
    # response = JSON.parse(response)
    if (response.class == Array && response != []) || (response.class == Hash && response["message"] != "Not Found")
        response.each do |comment|
          new_comment          = Comment.from_json(comment)
          new_comment.issue_id = issue_id
          new_comment.save
        end
    end
  end

  def self.events_from_json(issue)
    GithubHandler.query_github_issue_data(issue.repository.name, issue.git_issue_number, "events", issue.id)
  end

  def self.new_event(response, issue_id)
    # response = JSON.parse(response)
    if (response.class == Array && response != []) || (response.class == Hash && response["message"] != "Not Found")
      response.each do |event|
        new_event          = Event.from_json(event)
        new_event.issue_id = issue_id
        new_event.save
      end
    end
  end

end
