module GithubDataProcessor
  def users_by_commits
    counts = Hash.new(0)
    # TO DO: break this out into separate method -LRW
    commits.group(:user).count.each do |commit_name, count|
      counts[commit_name] += count
    end

    result = []
    counts.each do |key,value|
      formatted_count = Hash.new
      formatted_count["name"] = key
      formatted_count["num"] = value
      result.push(formatted_count)
    end
    { :committers => result }
  end

  #{"octocat"=>5}
  #{"name"=>"octocat", "num=>5"}
  def users_by_comments
    counts = Hash.new(0)
    issues.each do |issue|
      issue.comments.group(:user).count.each do |comment_name, count|
        counts[comment_name] += count
      end
    end

    result = []
    counts.each do |key,value|
      formatted_count = Hash.new
      formatted_count["name"] = key
      formatted_count["num"] = value
      result.push(formatted_count)
    end

    { :users_by_comments => result }  #  ###################### do not forget to change this back
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
