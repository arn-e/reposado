class RepositoriesController < ApplicationController
  respond_to :json, :html

  def index
    @repos = Repository.order("created_at DESC")
  end

  def show
    @repo = Repository.find(params[:id])
    respond_with @repo
  end

  def create
    # params[:repo] looks like: https://github.com/pengwynn/octokit
    repo_url = params[:repo]
    repo_name = URI.parse(repo_url).path # /pengwynn/octokit
    @repo       = Repository.new
    @repo.url   = repo_url
    @repo.name  = repo_name
    @repo.save!
    Delayed::Job.enqueue CreateRepoJob.new(repo_url)
  end
end
