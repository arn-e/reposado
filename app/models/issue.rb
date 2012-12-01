require './lib/github_data_processor.rb'
require './lib/github_handler.rb'

class Issue < ActiveRecord::Base
  include GithubDataProcessor

  belongs_to :repository
  # has_many :commits
  has_many :comments
  has_many :events
  validates_presence_of :title

  def self.from_json(json, repo_id)
    @issue = self.new
    @issue.title = json["title"]
    @issue.body = json["body"]
    @issue.git_created_at = DateTime.parse(json["created_at"])
    @issue.git_updated_at = DateTime.parse(json["updated_at"])
    @issue.git_issue_number = json["number"]
    @issue.repository_id = repo_id
    @issue.save!
    comments_from_json
    events_from_json
  end

  def self.comments_from_json
    puts "*************************"
    puts "repo name: #{@issue.repository.name}"
    puts "repo number: #{@issue.git_issue_number}"
    puts "*************************"
    comments = GithubHandler.query_github_issue_data(@issue.repository.name, @issue.git_issue_number, "comments")

    #query API for issue comments
    #receive parsed JSON
    #create Comment for each element of parsed JSON
    if (comments.class == Array && comments != []) || (comments.class == Hash && comments["message"] != "Not Found")
      # unless (comments["message"] == "Not Found")
        puts "*************************"
        puts "COMMENTS: #{comments}"
        puts "*************************"
        comments.each do |comment|
          # unless (comments["message"] == "Not Found")
          @comment          = Comment.from_json(comment)
          @comment.issue_id = @issue.id
          @comment.save
        end
      # end
    end
  end

  def self.events_from_json
    events = GithubHandler.query_github_issue_data(@issue.repository.name, @issue.git_issue_number, "events")
    if (events.class == Array && events != []) || (events.class == Hash && events["message"] != "Not Found")
    # unless (events["message"] == "Not Found") || (events == [])
      events.each do |event|
        @event          = Event.from_json(event)
        @event.issue_id = @issue.id
        @event.save
      end
    end
  end

end
