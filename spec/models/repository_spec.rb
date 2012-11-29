require 'spec_helper'

describe Repository do
  it { should have_many :issues }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context "initialization" do
    it "has the correct name" do
      @repo = FactoryGirl.build(:repository)
      @repo.name.should eq "Reposado"
    end

    it "has the correct url" do
      @repo = FactoryGirl.build(:repository)
      @repo.url.should eq "https://github.com/reposado/reposado"
    end
  end

  context "data processing" do
    5.times do
      FactoryGirl.create(:fully_loaded_issue)
    end

    let (:repo) { Repository.first }

    describe "#users_by_commits" do
      it "has number of user commits" do
        @data = repo.users_by_commits
        @data[:user_commit_counts].keys.first.should eq "octocat"
        @data[:user_commit_counts].values.first.should eq 6

        @data[:user_commit_counts].keys.last.should eq "user2"
        @data[:user_commit_counts].values.last.should eq 4
      end
    end

    describe "#users_by_comments" do
      it "has number of user comments" do
        @data = repo.users_by_comments
        @data[:user_comment_counts].keys.first.should eq "octocat"
        @data[:user_comment_counts].values.first.should eq 6

        @data[:user_comment_counts].keys.last.should eq "user2"
        @data[:user_comment_counts].values.last.should eq 7
      end
    end

    describe "#activity_by_week" do
      it "has dates" do
        pending
        # @data = repo.activity_by_week
        # @data.first[:date].should eq DateTime.strptime("2011-04-14T16:00:49Z")
        # @data.first[:activities].should eq 30
      end
    end

    describe "#to_json" do
      it "correctly formats a hash" do
        @data = repo.users_by_commits
        @json = repo.to_json(@data)
        @json.should eq "{\"user_commit_counts\":{\"octocat\":6,\"user2\":4}}"
      end
    end
  end
end
