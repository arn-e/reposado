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
    res[:response_times].each do |time| 
      if (time.class == Float || time.class == Fixnum) && time > 0
        sum += time
      end
    end
    p "sum : #{sum}"
    p "divisor : #{res[:response_times].length}"
    avg = sum / res[:response_times].length
    { :average_response_time => avg }
  end

  def relevant_words
    # tfidf score based on issue (as document) vs corpus
    # to do : include commit messages
    document = []
    issues.each do |issue|
      words_body = issue.body.split(' ')
      words_title = issue.title.downcase.split(' ')
      words_all_comments = []
      issue.comments.each do |issue_comments|
        words_comments = issue_comments.body.downcase.split(' ')
        words_all_comments += words_comments
      end
      words_issue = []
      words_issue += words_body
      words_issue += words_title
      words_issue += words_all_comments
      document << sanitized(words_issue)
    end
    commits.each do |commit|
      words_commit_message = commit.message.downcase.split(' ')
      document << sanitized(words_commit_message)
    end

    combined = Hash.new(0)
    
    document.each_slice(50) do |slice|
      TfIdf.new(slice).tf_idf.each do |i|
        i.each do |key, value|
          (combined[key] = value) if (value > combined[key])
        end
      end
    end

    combined = combined.sort_by {|key, value| value}
    result = []
    p "almost there..."
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
    # string.each {|i| i.gsub!(/\w/,"")}
    string
  end

  def bayes_classifier(string)
    classifier = Classifier::Bayes.new 'Interesting'
    classifier.train_interesting "bug todo urgent critical broken"
    classifier.classify(string)
  end

end
