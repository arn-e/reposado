class RepositoriesController < ApplicationController
  respond_to :json, :html

  def index
    @repo_names = Repository.order("created_at DESC").limit(2).map { |repo| repo.name || "" }
  end

  def show
    repo_name = "/#{params[:github_owner]}/#{params[:github_project]}"
    puts "repo_name = #{repo_name}"
    @repo = Repository.find_by_name(repo_name)
    puts "@repo = #{@repo}"
    respond_with @repo
  end

  def create
    # params[:repo] looks like: https://github.com/pengwynn/octokit
    repo_url = params[:repo]
    repo_name = URI.parse(repo_url).path # /pengwynn/octokit
    ignore, @github_owner, @github_name = repo_name.split('/')
    Delayed::Job.enqueue CreateRepoJob.new(repo_url)
  end
end
