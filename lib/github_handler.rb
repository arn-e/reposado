require 'net/http'
require 'net/https'

module GithubHandler

  OAUTH_TOKEN = "052fa222631a8872903551d0675953361d7810c7" # move this out - AF

  def self.query_github(repo, state, page_num = 1)
    url = "https://api.github.com/repos#{repo}/issues?state=#{state}&page=#{page_num}&per_page=100"
    query_api(url)
  end

  def self.multi_query_github_issue_data(list)
    EventMachine.run do
      multi = EventMachine::MultiRequest.new
      list.each do |item|
        multi.add "#{item[0]}_comments", EventMachine::HttpRequest.new("https://api.github.com/repos#{item[1]}/issues/#{item[2]}/comments?access_token=#{OAUTH_TOKEN}").get
        multi.add "#{item[0]}_events", EventMachine::HttpRequest.new("https://api.github.com/repos#{item[1]}/issues/#{item[2]}/events?access_token=#{OAUTH_TOKEN}").get
      end
      multi.callback do
        Issue.parsed_multi_response(multi.responses[:callback], item[3])
        EventMachine.stop
      end
    end
  end

  def self.query_github_commits(repo, branch_name, branch_start_sha)
    url = "https://api.github.com/repos#{repo}/commits?per_page=100&sha=#{branch_start_sha}"
    request, http = self.set_connection_parameters(url, 443)
    response = http.request(request)
    json_body = JSON.parse(response.body)
  end

  def self.query_github_branches(repo)
    url = "https://api.github.com/repos#{repo}/branches"
    query_api(url)
  end

  def self.set_connection_parameters(url, port = 80)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, port)
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
