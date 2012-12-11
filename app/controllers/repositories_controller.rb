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
    @valid = false
    repo_url = params[:repo]
    repo_name = URI.parse(repo_url).path # /pengwynn/octokit
    @repo       = Repository.find_by_url(repo_url)
    return if @repo
    @repo       = Repository.new
    @repo.url   = repo_url
    @repo.name  = repo_name
    if @repo.valid?
      @valid = true
      @repo.save!
      Delayed::Job.enqueue CreateRepoJob.new(repo_url)
    else
      @error_messages = []
      @repo.errors.each do |field, messages|
        if messages.respond_to? :each
          messages.each do |message|
            @error_messages << "#{field}: #{message}"
          end
        else
          @error_messages << "#{field}: #{messages}"
        end
      end
    end
  end
end
