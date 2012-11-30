class RepositoriesController < ApplicationController

  def index

  end

  def create
    @repo = Repository.new_repository(params[:repo])
    @data = @repo.collect_data([@repo.users_by_comments]).to_json
    @repo.save_chart_data(@data)
    redirect_to :action => 'index'
    # Repository.collect_issue_data(params[:Repo])
  end

  def view

  end

end
