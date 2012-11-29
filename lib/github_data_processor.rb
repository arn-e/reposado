module GithubDataProcessor
  def top_users_by_commits
    counts = Hash.new(0)
    issues.each do |issue|
      issue.commits.group(:user).count.each do |commit_name, count|
        counts[commit_name] += count
      end
    end
    counts
  end

  def top_users_by_comments
    counts = Hash.new(0)
    issues.each do |issue|
      issue.comments.group(:user).count.each do |comment_name, count|
        counts[comment_name] += count
      end
    end
    counts
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
