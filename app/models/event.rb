class Event < ActiveRecord::Base
  belongs_to :issue

  validates_presence_of :git_user, :date, :status

  def self.from_json(json)
    event         = self.new
    event.date    = DateTime.parse(json["created_at"])
    if json["actor"] != nil
      event.git_user    = json["actor"]["login"]
    else
      event.git_user    = ""
    end
    event.status  = json["event"]
    # event.body    = json["body"]
    event
  end
end
