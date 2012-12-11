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
  validate :valid_github_url


  def self.from_url(url)
    repo_path   = URI.parse(url).path
    @repo = Repository.find_by_url(url)
    if @repo
      return @repo if @repo.child_objects_loaded
    else
      @repo       = Repository.new
      @repo.url   = url
      @repo.name  = repo_path
      @repo.save!
    end
    repo_id     = @repo.id
    issues_from_github(repo_path, repo_id)
    collect_commits(repo_path, repo_id)
    @repo.child_objects_loaded = true
    @repo
  end

  def valid_github_url
    is_valid = false
    if (url =~ /https:\/\/github.com\/\w+\/\w+$/)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      response = http.get(uri.request_uri)
      is_valid = true if response.is_a? Net::HTTPSuccess
    end
    if not is_valid
      errors.add(:url, "must be a valid github repository URL")
    end
    is_valid
  end

  private

  def self.issues_from_github(repo_path, repo_id)
    open_data         = GithubHandler.query_github(repo_path, "open")
    closed_data       = GithubHandler.query_github(repo_path, "closed")

    open_data.each do |issue|
      Issue.from_json(issue, repo_id)
    end

    closed_data.each do |issue|
      Issue.from_json(issue, repo_id)
    end

    pool, repo_id = Issue.query_pool(repo_id)    
    distributed_async_pool(pool, repo_id)

  end

  def self.distributed_async_pool(pool, repo_id, set = 20)
    pool.each_slice(set) do |collection|
      GithubHandler.multi_query_github_issue_data(collection, repo_id)
    end 
  end

  def self.collect_commits(repo_path, repo_id)

    branches = collect_branches(repo_path)
    sha_collection = list_sha(repo_id)

    branches.each do |branch|
      branch_name, branch_start_sha = branch["name"], branch["commit"]["sha"]
      commit_data = collect_commit_page(repo_path, repo_id, branch_name, branch_start_sha)
      Commit.update_commit_data(commit_data, repo_id, sha_collection) unless commit_data.nil? || commit_data.length < 1
    end

  end

  def self.list_sha(repo_id,sha_collection = {})
    Repository.find(repo_id).commits.each {|commit| sha_collection[commit.sha] = 1}
    sha_collection
  end

  def self.collect_commit_page(repo_path, repo_id, branch_name, branch_start_sha)
    GithubHandler.query_github_commits(repo_path, branch_name, branch_start_sha)
  end

  def self.collect_branches(repo_path)
    GithubHandler.query_github_branches(repo_path)
  end

end
