class RepositoriesController < ApplicationController

  def index

  end

  def create
    @repo = Repository.new_repository(params[:repo])
    # need to save @repo.chart_data to db
    @data = @repo.collect_data([@repo.users_by_comments]).to_json
    redirect_to :action => 'index'
    # Repository.collect_issue_data(params[:Repo])
  end

end
