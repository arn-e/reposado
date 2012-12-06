class Comment < ActiveRecord::Base
  belongs_to :issue

  validates_presence_of :git_user, :date, :body

  def self.from_json(json)
    comment      = self.new
    comment.git_user = json["user"]["login"]
    comment.body = json["body"]
    comment.date = DateTime.parse(json["created_at"])
    comment
  end
end
