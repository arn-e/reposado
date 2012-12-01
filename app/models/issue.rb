class Issue < ActiveRecord::Base
  belongs_to :repository
  # has_many :commits
  has_many :comments
  has_many :events
  validates_presence_of :title

  def self.from_json(json, repo_id)
    @issue = self.new
    @issue.title = json["title"]
    @issue.body = json["body"]
    @issue.git_created_at = Date.strptime(json["created_at"])
    @issue.git_updated_at = Date.strptime(json["updated_at"])
    @issue.repository_id = repo_id
    @issue.save!
  end

  def self.comments_from_json(data)
    data.each do |comment|
      @comment = Comment.from_json(comment)
      @comment.save
    end
  end

  def self.events_from_json(data)
    data.each do |event|
      @event = Event.from_json(event)
      @event.save
    end
  end
end
