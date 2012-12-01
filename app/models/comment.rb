class Comment < ActiveRecord::Base
  belongs_to :issue

  validates_presence_of :user, :date, :body

  def self.from_json(json)
    comment      = self.new
    puts "************************"
    puts "USER LOGIN: #{json["user"]["login"]}"
    comment.user = json["user"]["login"]
    comment.body = json["body"]
    comment.date = Date.strptime(json["created_at"])
    comment
  end
end
