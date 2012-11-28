module GithubDataProcessor
  def top_users_by_commits
    @commits = Commit.all
    @commits.group("user")
    # [ { :username => "octocat", :commits => 30 },
    #   { :username => "user2", :commits => 20 } ]
  end

  def top_users_by_comments
    # [ { :username => "user2", :comments => 35 },
    #   { :username => "octocat", :comments => 30 } ]
  end

  def activity_by_week
  end

  def to_json
  end

end


# @repos = Repository.all

# @repos.each do |repo|
#   repo.top_users_by_commits
# end
