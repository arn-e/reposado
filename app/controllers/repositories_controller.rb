class RepositoriesController < ApplicationController

  def index

  end

  def create

    # dummy data

    # @data_json = '{"committers" : [
    #   {"name" : "alice", "num" : 125},
    #   {"name" : "bob",   "num" : 2},
    #   {"name" : "carol", "num" : 34},
    #   {"name" : "dan",   "num" : 14},
    #   {"name" : "ed",    "num" : 5},
    #   {"name" : "frankie", "num" : 61},
    #   {"name" : "scoobydoo", "num" : 81},
    #   {"name" : "hunter5", "num" : 31},
    #   {"name" : "joelanders", "num" : 1},
    #   {"name" : "rms", "num" : 21},
    #   {"name" : "esr", "num" : 11},
    #   {"name" : "jonathan_doe", "num" : 91},
    #   {"name" : "obama", "num" : 71}
    # ]}'

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


end
