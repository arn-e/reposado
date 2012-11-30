class RepositoriesController < ApplicationController

  def index

  end

  def create
    Repository.new_repository(params[:repo])
    redirect_to :action => 'index'
    # Repository.collect_issue_data(params[:Repo])
  end

  def view

  end

end
