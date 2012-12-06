module GithubDataProcessor
  def users_by_commits
    counts = Hash.new(0)
    # TO DO: break this out into separate method -LRW
    commits.group(:git_user).count.each do |commit_name, count|
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
      issue.comments.group(:git_user).count.each do |comment_name, count|
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

  def response_time_for_issues
    response_times = Hash.new(0)
    # todo : refactor this really ugly code :)
    issues.each do |issue|
      issue_created = issue.git_created_at
      if issue.events.first != nil
        if issue.events.first.date == issue.git_created_at
          issue.events.second.nil? ? (event_date = nil) : (event_date = issue.events.second.date)
        else
          event_date = issue.events.first.date
        end
      end
      issue.comments.first != nil ? (comment_date = issue.comments.first.date) : (comment_date = nil)
      # p "*********************************issue ID     : #{issue.id}"
      # p "*********************************created date : #{issue_created}"
      # p "*********************************event date   : #{event_date}"
      # p "*********************************comment_date : #{comment_date}"
      if event_date == nil && comment_date == nil
        response_times[issue.id] = nil
      elsif comment_date == nil && event_date != nil
        response_times[issue.id] = event_date - issue_created
      elsif event_date == nil && comment_date != nil
        response_times[issue.id] = comment_date - issue_created
      else
        comment_date < event_date ? (response_times[issue.id] = (comment_date - issue_created)) : (response_times[issue.id] = (event_date - issue_created))
      end
    end

    result = []
    response_times.each do |response_time|
      result << response_time[1]
    end
    { :response_times => result }

  end

  def resolution_time_for_issues
  end

  def average_response_time(sum = 0)
    res = response_time_for_issues
    res[:response_times].each {|time| sum += time}
    avg = sum / res[:response_times].length
    { :average_response_time => avg }
  end

  def relevant_words
    # tfidf score based on issue (as document) vs corpus
    # to do : include commit messages
    document = []

    issues.each do |issue|
      words_body = issue.body.split(' ')
      words_title = issue.title.split(' ')
      words_all_comments = []
      issue.comments.each do |issue_comments|
        words_comments = issue_comments.body.split(' ')
        words_all_comments += words_comments
      end
      words_issue = []
      words_issue += words_body
      words_issue += words_title
      words_issue += words_all_comments
      document << words_issue
    end

    commits.each do |commit|
      words_commit_message = commit.message.split(' ')
      document << words_commit_message
    end

    score = TfIdf.new(document)
    combined = Hash.new(0)
    score.tf_idf.each do |i|
      i.each do |key, value|
        (combined[key] = value) if (value > combined[key])
      end
    end

    combined = combined.sort_by {|key, value| value}
    result = []

    combined.each do |word_score|
      single_score = (['word','score']).zip(word_score).flatten
      single_hash = Hash.new
      single_hash[single_score[0]] = single_score[1]
      single_hash[single_score[2]] = single_score[3]
      result << single_hash
    end

    { :relevant_words => result.reverse[0...17] }
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
