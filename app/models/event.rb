class Event < ActiveRecord::Base
  belongs_to :issue

  validates_presence_of :git_user, :date, :status

  def self.from_json(json)
    event         = self.new
    event.date    = DateTime.parse(json["created_at"])
    event.git_user    = json["actor"]["login"]
    event.status  = json["event"]
    # event.body    = json["body"]
    event
  end
end
