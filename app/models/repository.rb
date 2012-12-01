require './lib/github_data_processor.rb'
require './lib/github_handler.rb'
require 'date'

class Repository < ActiveRecord::Base

  include GithubDataProcessor
  include GithubHandler

  attr_accessible :chart_data
  has_many :issues
  has_many :commits
  validates_presence_of :name, :url

  def self.new_repository(url)
    full_url    = url
    repo_path   = URI.parse(url).path
    @repo       = Repository.new
    @repo.url   = full_url
    @repo.name  = repo_path
    @repo.save!
    repo_id     = Repository.last.id
    collect_issues(repo_path, Repository.last.id)
    collect_commits(repo_path, Repository.last.id)
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
    branches = collect_branches(repo_path)

    branches.each do |branch|
      branch_name, branch_start_sha = branch["name"], branch["commit"]["sha"]
      commit_data = collect_commit_page(repo_path, repo_id, branch_name, branch_start_sha)
      update_commit_data(commit_data, repo_id) unless commit_data.nil? || commit_data.length < 1
    end

  end

  def self.collect_commit_page(repo_path, repo_id, branch_name, branch_start_sha)
    GithubHandler.query_github_commits(repo_path, branch_name, branch_start_sha)
  end

  def self.collect_branches(repo_path)
    GithubHandler.query_github_branches(repo_path)
  end

  def self.update_commit_data(commit_data, repo_id)
    commit_data.each do |commit|
      logger.debug("error : #{commit}")
      @new_commit = Commit.new
      @new_commit.repository_id = repo_id
      @new_commit.sha = commit["sha"]
      if commit["parents"].length != 0
        @new_commit.parent_sha = commit["parents"][0]["sha"] # add multiple parents?
      end
      if commit["committer"] != nil
        if commit["committer"]["login"] == nil
          @new_commit.user = commit["commit"]["committer"]["name"]
        elsif commit["committer"]["login"] != nil
          @new_commit.user = commit["committer"]["login"]
        else
          @new_commit.user = " "
        end
        @new_commit.date = commit["commit"]["committer"]["date"]
        @new_commit.save!
      end
    end
  end

  def self.update_issue_child_data(data, issue_number, data_type)
    data.each do |issue_data|

      case data_type
      when "comments"
        @new_issue_data = Comment.new
        puts "***************************"
        puts "MOST RECENT ISSUE ID: #{Issue.last.id}"
        puts "***************************"
        @new_issue_data.issue_id = Issue.last.id
      when "events"
        @new_issue_data = Event.new
        @new_issue_data.issue_id = Issue.last.id
      end

      puts "*****************************"
      puts "NEW_ISSUE_DATA: #{@new_issue_data}"
      puts "*****************************"

      if data_type == "comments"
        @new_issue_data.body = issue_data["body"]
        @new_issue_data.user = issue_data["user"]["login"]
      elsif data_type == "events"
        @new_issue_data.user = issue_data["actor"]["login"]
        @new_issue_data.status = issue_data["event"]
      end
      @new_issue_data.date = Date.strptime(issue_data["created_at"])
      @new_issue_data.save!
    end
  end

  def self.update_issue_data(data, repo_id)
    data.each do |issue|
      # Why did this work when I changed new_issue from a local variable to an instance variable? -LRW
      @new_issue = Issue.new
      # new_issue.git_issue_number = issue["number"].to_i
      @new_issue.title = issue["title"]

      @new_issue.body = issue["body"]
      @new_issue.git_created_at = Date.strptime(issue["created_at"])
      @new_issue.git_updated_at = Date.strptime(issue["updated_at"])
      # new_issue.date_closed = issue["closed_at"]

      @new_issue.repository_id = repo_id
      # new_issue.state = issue["state"]
      @new_issue.save!

    end
  end


end
