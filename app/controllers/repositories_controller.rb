class RepositoriesController < ApplicationController

  def index
    @repos = Repository.order("created_at DESC").limit(2).map { |repo| repo.name || "" }
  end

  def create
    @repo = Repository.from_url(params[:repo])
    @data = @repo.collect_data([@repo.users_by_commits, @repo.users_by_comments]).to_json
    @repo.chart_data = @data
    @repo.save
    # @exists = false

    if true# placeholder for cached? or something like that
      #render :json => @data_json # the dummy data above
      puts "draw_pie(\'#{@data}\');"
      render :js => "draw_pie(#{@data});"
    else
      # the uncached case
      # @repo = Repository.new_repository(params[:repo])
      # @data = @repo.collect_data([@repo.users_by_comments]).to_json
      # @repo.chart_data = @data
      # @repo.save
      render :nothing
    end
  end

end
