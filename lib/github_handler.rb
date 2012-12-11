require 'net/http'
require 'net/https'

module GithubHandler

  OAUTH_TOKEN = "052fa222631a8872903551d0675953361d7810c7"

  def self.query_github(repo, state, page_num = 1)
    url = "https://api.github.com/repos#{repo}/issues?state=#{state}&page=#{page_num}&per_page=100"
    query_api(url)
  end

  def self.multi_query_github_issue_data(pool, repo_id)
    list, repo_id = pool, repo_id
    EventMachine.run do
      multi = EventMachine::MultiRequest.new
      list.each do |item|
        repo, issue_number, repo_id = item[1], item[2], item[3]
        comment_ident, event_ident = "#{item[0]}_comments", "#{item[0]}_events"

        url_comment = "https://api.github.com/repos#{repo}/issues/#{issue_number}/comments?access_token=#{OAUTH_TOKEN}"   
        url_event = "https://api.github.com/repos#{repo}/issues/#{issue_number}/events?access_token=#{OAUTH_TOKEN}"   
        
        multi.add comment_ident, EventMachine::HttpRequest.new(url_comment).get
        multi.add event_ident, EventMachine::HttpRequest.new(url_event).get
      end
      multi.callback do
        Issue.parsed_multi_response(multi.responses[:callback], repo_id)
        puts multi.responses[:errback]
        EventMachine.stop
      end
    end
  end

  def self.query_github_issue_data(repo, issue_number, data_type, issue_id)
    issue_id = issue_id
    url = "https://api.github.com/repos#{repo}/issues/#{issue_number}/#{data_type}?access_token=#{OAUTH_TOKEN}"  
    EventMachine.run {
      http = EventMachine::HttpRequest.new(url).get
      http.errback { 
        p 'Error Callback Reached'
        EM.stop 
      }
      http.callback {
        response = JSON.parse(http.response)
        data_type == "comments" ? Issue.new_comment(response, issue_id) : Issue.new_event(response, issue_id)
        EventMachine.stop
      }
    }        
  end

  def self.query_github_commits(repo, branch_name, branch_start_sha)
    url = "https://api.github.com/repos#{repo}/commits?per_page=100&sha=#{branch_start_sha}"
    request, http = self.set_connection_parameters(url, 443)
    response = http.request(request)
    json_body = JSON.parse(response.body)
  end

  def self.query_github_branches(repo)
    url = "https://api.github.com/repos#{repo}/branches"
    puts "*********** URL::: #{url}"
    query_api(url)
  end

  def self.set_connection_parameters(url, port = 80)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, port)
    # What does this stuff mean? What does it do? -LRW
    if port == 443
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request = Net::HTTP::Get.new(uri.request_uri, initheader = {"Authorization" => "token #{OAUTH_TOKEN}"})
    [request, http]
  end

  def self.query_api(url)
    request, http = self.set_connection_parameters(url, 443)
    response = http.request(request)
    json_body = JSON.parse(response.body)
  end

end
