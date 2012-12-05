require 'spec_helper'

describe Issue do
  it { should belong_to :repository }
  it { should have_many :comments }
  it { should have_many :events}

  it { should validate_presence_of :title}
  # it { should validate_presence_of :body}

  let(:issue) { Issue.new }
  describe '.from_json' do
    
    context 'given valid input' do
      let(:json) { {"title" => "dummy_title", "body" => "dummy_body", "created_at" => "2012-12-02 22:39:44", "updated_at" => "2012-12-02 22:39:44", "git_issue_number" => 2}}

      before do
        Issue.stub(:comments_from_json).and_return(nil)
        Issue.stub(:events_from_json).and_return(nil)
      end

      it 'saves a new issue model' do
        base_count = Issue.count
        Issue.from_json(json, 1)
        Issue.count.should eql(base_count + 1)
      end
    end

    context 'given valid repo_id' do
      it 'sets the repository_id column' do
        Issue.find(1).repository_id.should eql(1)
      end
    end

  end
  
  describe '.comments_from_json' do
    
    context 'issue has no comments' do
      let(:comment_data) { [{"user" => {"login" => "dummy_login"}, "body" => "dummy_body", "created_at" => ""}] }
      let(:comment) { Comment.new }
      let(:comment_data) { [] }
      let(:issue) { Issue.new }
      let(:repository) { Repository.new }
      before(:each) do
        repository.stub(:name).and_return("dummy_repo")
        issue.stub(:id).and_return(1)
        issue.stub(:repository).and_return(repository)
        issue.stub(:github_issue_number).and_return(17)
      end      

      it 'does not save a new comment' do
        GithubHandler.stub(:query_github_issue_data).and_return(comment_data)
        # issue.stub(:id).and_return(1)
        base_count = Comment.count
        Issue.comments_from_json(issue)
        Comment.count.should eql(base_count)
      end

    end

    context 'issue has comments' do
      let(:issue) { Issue.new }
      let(:repository) { Repository.new }
      before(:each) do
        repository.stub(:name).and_return("dummy_repo")
        issue.stub(:id).and_return(1)
        issue.stub(:repository).and_return(repository)
        issue.stub(:github_issue_number).and_return(17)
      end      

      it 'saves a new comment' do
        GithubHandler.stub(:query_github_issue_data).and_return(comment_data)
        Issue.comments_from_json(issue)
        comment.count.should eql(1)
      end

      it 'saves the correct body to the DB' do
        comment.find(1).body.should eql("dummy_body")
      end
    end

  end

  describe '.events_from_json' do
    let(:event_data) { {"created_at" => "2012-12-02 22:39:44", "actor" => {"login" => "dummy_login"}, "event" => "dummy_event"} }
    let(:event) { Event.new }
    let(:issue) { Issue.new }

    let(:repository) { Repository.new }
  
    before(:each) do
      repository.stub(:name).and_return("dummy_repo")
      issue.stub(:repository).and_return(repository)
      issue.stub(:github_issue_number).and_return(17)
    end      

    before do
      issue.stub(:id).and_return(1)
      GithubHandler.stub(:query_github_issue_data).and_return(event_data)
    end

    context 'issue has events' do

      before(:each) do
        repository.stub(:name).and_return("dummy_repo")
        issue.stub(:id).and_return(1)
        issue.stub(:repository).and_return(repository)
        issue.stub(:github_issue_number).and_return(17)
      end      

      it 'writes a new event to the DB' do
        Issue.events_from_json(issue)
        Event.count.should eql(1)
      end
    end

    context 'issue has no events' do
      let(:event_data) { {} }

      before do
        repository.stub(:name).and_return("dummy_repo")
        issue.stub(:id).and_return(1)
        issue.stub(:repository_name).and_return("dummy_repo")
        issue.stub(:github_issue_number).and_return(17)
        GithubHandler.stub(:query_github_issue_data).and_return(event_data)
      end

      it 'should not write a new event to the DB' do
        base_count = Event.count
        Issue.events_from_json(issue)
        Event.count.should eql(base_count)
      end
    end

  end

end

