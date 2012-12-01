class Event < ActiveRecord::Base
  belongs_to :issue

  validates_presence_of :user, :date, :status

  def self.from_json(json)
    event         = self.new
    p "EVENT ::: #{event}"
    p "JSON  ::: #{json}"
    event.date    = DateTime.parse(json["created_at"])
    event.user    = json["actor"]["login"]
    event.status  = json["event"]
    # event.body    = json["body"]
    event
  end
end
