module GithubDataProcessor
  def users_by_commits
    counts = Hash.new(0)
    issues.each do |issue|
      issue.commits.group(:user).count.each do |commit_name, count|
        counts[commit_name] += count
      end
    end
    { :user_commit_counts => [counts] }
  end

  def users_by_comments
    counts = Hash.new(0)
    issues.each do |issue|
      issue.comments.group(:user).count.each do |comment_name, count|
        counts[comment_name] += count
      end
    end
    { :user_comment_counts => [counts] }
  end

  def activity_by_week
  end

  def collect_data(hashes=[])
    data = {}
    hashes.each do |hash|
      data[hash.keys.first] = hash.values.first
    end
    data
  end

  def save_data(data)

  end
end
