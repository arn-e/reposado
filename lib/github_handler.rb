require 'net/http'
require 'net/https'

module GithubHandler

  OAUTH_TOKEN = "052fa222631a8872903551d0675953361d7810c7"

  # refactor

  def self.query_github(repo, state, page_num = 1)
    url = "https://api.github.com/repos#{repo}/issues?state=#{state}&page=#{page_num}&per_page=100"
    request, http = self.set_connection_parameters(url, 443)
    response = http.request(request)
    json_body = JSON.parse(response.body)
  end

  def self.query_github_issue_data(repo, issue_number, data_type = "comments")
    url = "https://api.github.com/repos#{repo}/issues/#{issue_number}/#{data_type}"
    request, http = self.set_connection_parameters(url, 443)
    response = http.request(request)
    json_body = JSON.parse(response.body)
  end

  def self.query_github_commits(repo, branch_name, branch_start_sha)
    # https://api.github.com/repos/twitter/bootstrap/commits?per_page=100&sha=d335adf644b213a5ebc9cee3f37f781ad55194ef
    url = "https://api.github.com/repos#{repo}/commits?per_page=100&sha=#{branch_start_sha}"
    request, http = self.set_connection_parameters(url, 443)
    response = http.request(request)
    json_body = JSON.parse(response.body)
  end

  def self.query_github_branches(repo)
    url = "https://api.github.com/repos#{repo}/branches"
    request, http = self.set_connection_parameters(url, 443)
    response = http.request(request)
    json_body = JSON.parse(response.body)
  end

  def self.set_connection_parameters(url, port = 80)
    uri = URI.parse(url)
    uri.port = port
    http = Net::HTTP.new(uri.host, uri.port)
    if port == 443
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request = Net::HTTP::Get.new(uri.request_uri, initheader = {"Authorization" => "token #{OAUTH_TOKEN}"})
    [request, http]
  end

end
