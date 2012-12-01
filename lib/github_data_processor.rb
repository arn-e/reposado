module GithubDataProcessor
  def users_by_commits
    counts = Hash.new(0)
    result = []
    commits.group(:user).count.each do |commit_name, count|
      counts[commit_name] += count
      result.push({"name" => commit_name, "num" => counts[commit_name]})
    end
    { :commiters => result }
  end

  #{"octocat"=>5}
  #{"name"=>"octocat", "num=>5"}
  def users_by_comments
    counts = Hash.new(0)
    issues.each do |issue|
      issue.comments.group(:user).count.each do |comment_name, count|
        counts[comment_name] += count
        # result.push({"name" => comment_name, "num" => counts[comment_name]})
      end
    end
    result = []

    counts.each do |key,value|
      formatted_count = Hash.new
      formatted_count["name"] = key
      formatted_count["num"] = value
      result.push(formatted_count)
    end

    # combined_results = Hash.new(0)
    # result.each {|hash| hash.each {|key, value| combined_results[key] += value.to_i}}

    # {"username"=>20, "username2"=>15}
    # { {"name"=>"username", "num"=>20}, {"name"=>username2", "num"=>15} }
    { :committers => result }  #  ###################### do not forget to change this back
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
