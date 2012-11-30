class RepositoriesController < ApplicationController

  def index

  end

  def create
    @repo = Repository.new_repository(params[:repo])
    @data = @repo.collect_data([@repo.users_by_comments]).to_json
    puts "DATA: #{@data}"
    @repo.chart_data = @data
    @repo.save

    if true # placeholder for cached? or something like that
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

  def view

  end

end
