require 'eventmachine'
require 'em-http'

# EventMachine.run do
#   multi = EventMachine::MultiRequest.new

#   multi.add :gh1, EventMachine::HttpRequest.new("https://api.github.com/repos/pengwynn/octokit/issues/1/events").get
#   multi.add :gh2, EventMachine::HttpRequest.new("https://api.github.com/repos/pengwynn/octokit/issues/2/events").get

#   multi.callback do
#     a = multi.responses[:callback]
#     p a.class
#     p a.length
#     p a[:gh1].response
#     puts multi.responses[:errback]
#     EventMachine.stop
#   end
# end

 EventMachine.run {
      http = EventMachine::HttpRequest.new('"https://api.github.com/repos/pengwynn/octokit/issues/1/events"').get

      http.errback { p 'Uh oh'; EM.stop }
      http.callback {
        p http.response_header.status
        puts
        puts
        p http.response_header
        puts
        puts
        p http.response

        EventMachine.stop
      }
    }