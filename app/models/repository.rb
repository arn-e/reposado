require './lib/github_data_processor.rb'
require './lib/github_handler.rb'

class Repository < ActiveRecord::Base
  include GithubDataProcessor
  include GithubHandler

  attr_accessible :chart_data
  has_many :issues
  has_many :commits
  validates_presence_of :name, :url

  def self.new_repository(url)
    full_url = url
    repo_path = URI.parse(url).path
    @repo = Repository.new
    @repo.url = full_url
    @repo.name = repo_path
    @repo.save!
    repo_id = Repository.last.id
    collect_issues(repo_path, repo_id)
    collect_commits(repo_path, repo_id)
    @repo
  end

  private

  def self.collect_issues(repo_path, repo_id)
    open_data = GithubHandler.query_github(repo_path, "open")
    closed_data = GithubHandler.query_github(repo_path, "closed")
    update_issue_data(open_data, repo_id)
    update_issue_data(closed_data, repo_id)
    collect_issue_data(repo_path, open_data)
    collect_issue_data(repo_path, closed_data)
  end

  def self.collect_issue_data(repo_path, data)
    data_types = ["comments", "events"]
    data.each do |issue|
      data_types.each do |data_type|
        comment_data = GithubHandler.query_github_issue_data(repo_path, issue["number"].to_i, data_type)
        update_issue_child_data(comment_data, issue["number"].to_i, data_type) unless comment_data.length < 1
      end
    end
  end

  def self.collect_commits(repo_path, repo_id)
    # 1. get all branches
    # 2. get all commits for a given branch by first getting the top 100, then passing in the last SHA as the next parameter
    # 3. de-duplicate the results, probably based on SHA1
    # need : starting sha
    #      : starting branch
    # GET /repos/:owner/:repo/commits

  end

  def self.collect_branches(repo_path)
    # GET /repos/:owner/:repo/branches

  end

  def self.update_issue_child_data(data, issue_number, data_type)
    data.each do |issue_data|
      case data_type
      when "comments"
        new_issue_data = Comment.new
      when "events"
        new_issue_data = Event.new
      end
      new_issue_data.issue_id = issue_number.to_i
      if data_type == "comments"
        new_issue_data.body = issue_data["body"]
        new_issue_data.user = issue_data["user"]["login"]
      elsif data_type == "events"
        new_issue_data.user = issue_data["actor"]["login"]
        new_issue_data.status = issue_data["event"]
      end
      new_issue_data.date = issue_data["created_at"]
      new_issue_data.save!
    end
  end

  def self.update_issue_data(data, repo_id)
    data.each do |issue|
      new_issue = Issue.new
      new_issue.repository_id = repo_id
      new_issue.git_issue_number = issue["number"]
      new_issue.title = issue["title"]
      new_issue.body = issue["body"]
      new_issue.git_created_at = issue["created_at"]
      new_issue.git_updated_at = issue["updated_at"]
      # new_issue.date_closed = issue["closed_at"]
      # new_issue.state = issue["state"]
      new_issue.save!
    end
  end

  def self.save_chart_data(data)
    chart_data = data
  end
end
