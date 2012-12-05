class CreateRepoJob
  def initialize(repo_url)
    @repo_url = repo_url
  end

  def perform
    @repo = Repository.from_url(@repo_url)
    @data = @repo.collect_data([@repo.users_by_commits, @repo.users_by_comments, @repo.relevant_words]).to_json
    @repo.chart_data = @data
    @repo.save!
  end

end
