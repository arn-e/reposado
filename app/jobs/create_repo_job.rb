class CreateRepoJob
  def initialize(repo_url)
    @repo_url = repo_url
  end

  def perform
    @repo = Repository.from_url(@repo_url)
    @data = @repo.collect_data([@repo.users_by_commits, @repo.users_by_comments, @repo.relevant_words, @repo.response_time_for_issues, @repo.average_response_time]).to_json
    @repo.chart_data = @data
    @repo.save!
  end

end
