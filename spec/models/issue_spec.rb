require 'spec_helper'

describe Issue do
  it { should belong_to :repository }
  it { should have_many :comments }
  it { should have_many :commits}
  it { should have_many :events}

  it { should validate_presence_of :title}
  it { should validate_presence_of :body}

  let(:issue) { @issue.new }

  describe '.from_json' do
    let(:json) { {"title" => "dummy_title", "body" => "dummy_body", "git_created_at" => "", "git_updated_at" => "", "git_issue_number" => 2}}

    context 'given valid input' do
      it 'saves a new issue model' do
        Issue.from_json(json, 1)
        Issue.count.should eql(1)
      end
    end

    context 'given valid repo_id' do
      it 'sets the repository_id column' do
        Issue.find(1).repository_id.should eql(1)
      end
    end

  end
  
  describe '.comments_from_json' do
    let(:comment_data) { [{"user" => {"login" => "dummy_login"}, "body" => "dummy_body", "created_at" => ""}] }
    let(:comment) { Comment.new }

    GithubHandler.stub(:query_github_issue_data).and_return(comment_data)
    issue.stub(:id).and_return(1)

    context 'issue has no comments' do
      let(:comment_data) { [] }

      it 'does not save a new comment' do
        Issue.comments_from_json
        comment.count.should eql(0)
      end

    end

    context 'issue has comments' do
      it 'saves a new comment' do
        Issue.comments_from_json
        comment.count.should eql(1)
      end

      it 'saves the correct body to the DB' do
        comment.find(1).body.should eql("dummy_body")
      end
    end

  end

  describe '.events_from_json' do
    let(:event_data) { {"created_at" => "", "actor" => {"login" => "dummy_login"}, "event" => "dummy_event"} }
    let(:event) { Event.new }

    GithubHandler.stub(:query_github_issue_data).and_return(event_data)
    issue.stub(:id).and_return(1)    

    context 'issue has events' do
      it 'writes a new event to the DB' do
        Issue.events_from_json
        event.count.should eql(1)
      end
    end

    context 'issue has no events' do
      let(:event_data) { {} }
      it 'should not write a new event to the DB' do
        Issue.events_from_json
        event.count.should eql(1)
      end
    end

  end

end

