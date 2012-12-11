module GithubDataProcessor

  def users_by_commits(result = [])
    user_commit_counts.each do |key,value|
      formatted_count = Hash.new
      formatted_count["name"] = key
      formatted_count["num"] = value
      result.push(formatted_count)
    end
    { :committers => result }
  end

  def users_by_comments(result = [])
    user_comment_counts.each do |key,value|
      formatted_count = Hash.new
      formatted_count["name"] = key
      formatted_count["num"] = value
      result.push(formatted_count)
    end
    { :commenters => result }  
  end

  def response_time_for_issues(response_times = Hash.new(0), result = [])
    issues.each do |issue|
      event_date, comment_date = issue_event_date(issue), issue_comment_date(issue)
      response_times[issue.id] = response_time(issue, event_date, comment_date)
    end
    response_times.each { |response_time| result << response_time[1] }
    { :response_times => result }
  end

  def average_response_time(sum = 0)
    response_time_for_issues[:response_times].each do |time| 
      (sum += time) if (time.class == Float || time.class == Fixnum) && time > 0
    end
    { :average_response_time => (sum / res[:response_times].length) }
  end
  
  def relevant_words(document = [], combined = Hash.new(0))
    issues.each {|issue| document << words_in_issue(issue)}
    commits.each {|commit| document << sanitized(commit.message.downcase.split(' '))}

    combined = highest_scores.sort_by {|key, value| value}
    { :relevant_words => word_results_formatted.reverse[0...17] }
  end

  def collect_data(hashes=[])
    data = {}
    hashes.each do |hash|
      data[hash.keys.first] = hash.values.first
    end
    data
  end

  private

  def words_in_issue(issue, words_all_comments = [], words_issue = [])
    words_body, words_title = issue.body.split(' '), issue.title.downcase.split(' ')
    issue.comments.each {|issue_comments| words_all_comments += issue_comments.body.downcase.split(' ')}
    sanitized(append_words(words_issue, words_body, words_title, words_all_comments))
  end

  def append_words(words, body, title, comments)
    words += body
    words += title
    words += comments
    words
  end

  def highest_scores(document)
    document.each_slice(50) do |slice|
      TfIdf.new(slice).tf_idf.each do |i|
        i.each do |key, value|
          (combined[key] = value) if (value > combined[key])
        end
      end
    end
    combined
  end

  def word_results_formatted(combined, result = [])
    combined.each do |word_score|
      single_score = (['word','score']).zip(word_score).flatten
      single_hash = Hash.new
      single_hash[single_score[0]] = single_score[1]
      single_hash[single_score[2]] = single_score[3]
      result << single_hash
    end
    result
  end

  def response_time(issue, event_date, comment_date)
    return nil (if event_date == nil && comment_date == nil)
    if comment_date == nil && event_date != nil
      return (event_date - issue.git_created_at)
    elsif comment_date != nil && event_date == nil
      return (comment_date - issue.git_created_at)
    else
      comment_date < event_date ? (return (comment_date - issue.git_created_at)) : (return (event_date - issue.git_created_at))
    end
  end

  def issue_comment_date(issue)
    issue.comments.first != nil ? (comment_date = issue.comments.first.date) : (comment_date = nil)
    comment_date
  end

  def issue_event_date(issue)
    return nil if issue.events.first == nil
    if issue.events.first.date == issue.git_created_at
      issue.events.second.nil? ? (return nil) : (return issue.events.second.date)
    else
      return issue.events.first.date
    end
  end

  def user_comment_counts(counts = Hash.new(0))
    issues.each do |issue|
      issue.comments.group(:git_user).count.each { |comment_name, count| counts[comment_name] += count }
    end
    counts
  end

  def user_commit_counts(counts = Hash.new(0))
    commits.group(:git_user).count.each { |commit_name, count| counts[commit_name] += count }
    counts
  end

  def sanitized(string)
    words = {"about" => 1,"after" => 1,"all" => 1,"also" => 1,"an" => 1,"and" => 1,"another" => 1,"any" => 1,"are" => 1,"as" => 1,"at" => 1,"be" => 1,"because" => 1,"been" => 1,"before" => 1,
      "being" => 1,"between" => 1,"both" => 1,"but" => 1,"by" => 1,"came" => 1,"can" => 1,"come" => 1,"could" => 1,"did" => 1,"do" => 1,"each" => 1,"for" => 1,"from" => 1,"get" => 1,
      "got" => 1,"has" => 1,"had" => 1,"he" => 1,"have" => 1,"her" => 1,"here" => 1,"him" => 1,"himself" => 1,"his" => 1,"how" => 1,"if" => 1,"in" => 1,"into" => 1,"is" => 1,"it" => 1,"like" =>1,
      "make" => 1,"many" => 1,"me" => 1,"might" => 1,"more" => 1,"most" => 1,"much" => 1,"must" => 1,"my" => 1,"never" => 1,"now" => 1,"of" => 1,"on" => 1,"only" => 1,"or" => 1,"other" => 1,
      "our" => 1,"out" => 1,"over" => 1,"said" => 1,"same" => 1,"see" => 1,"should" => 1,"since" => 1,"some" => 1,"still" => 1,"such" => 1,"take" => 1,"than" => 1,"that" => 1,
      "the" => 1,"their" => 1,"them" => 1,"then" => 1,"there" => 1,"these" => 1,"they" => 1,"this" => 1,"those" => 1,"through" => 1,"to" => 1,"too" => 1,"under" => 1,"up" => 1,
      "very" => 1,"was" => 1,"way" => 1,"we" => 1,"well" => 1,"were" => 1,"what" => 1,"where" => 1,"which" => 1,"while" => 1,"who" => 1,"with" => 1,"would" => 1,"you" => 1,"your" => 1,"a" => 1,
      "b" => 1,"c" => 1,"d" => 1,"e" => 1,"f" => 1,"g" => 1,"h" => 1,"i" => 1,"j" => 1,"k" => 1,"l" => 1,"m" => 1,"n" => 1,"o" => 1,"p" => 1,"q" => 1,"r" => 1,"s" => 1,"t" => 1,"u" => 1,"v" => 1,"w" => 1,"x" => 1,"y" => 1,"z" => 1,"$" => 1,
      "1" => 1,"2" => 1,"3" => 1,"4" => 1,"5" => 1,"6" => 1,"7" => 1,"8" => 1,"9" => 1,"0" => 1,"_" => 1}
    string = string.delete_if {|i| words[i] == 1}  
    string = string.delete_if {|i| i.gsub!(/\W*/,"") == ""}
    string = string.delete_if {|i| i.gsub!(/\d*/,"") == ""}
    string
  end

  def bayes_classifier(string) #currently not used; there appears to be a bug in the library
    classifier = Classifier::Bayes.new 'Interesting'
    classifier.train_interesting "bug todo urgent critical broken"
    classifier.classify(string)
  end

end
