require 'spec_helper'

describe Repository do
  it { should have_many :issues }
  it { should have_many :commits }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context "initialization" do
    it "has the correct name" do
      @repo = FactoryGirl.build(:repository)
      @repo.name.should eq "Rails"
    end

    it "has the correct url" do
      @repo = FactoryGirl.build(:repository)
      @repo.url.should eq "https://github.com/rails/rails"
    end

    describe ".from_url" do
      it "saves a new Repository to the database" do
        # Repository should_receive(:from_url) and respond_with (<file>)
        # Repository.from_url()
      end

      it "correctly sets the name of the Repository" do
      end

      it "correctly sets the URL of the Repository" do
      end

      it "returns cached data if the input URL is already in the database" do
      end

      it "collects child Issues" do
      end

      it "collects child Commits" do
      end

    end
  end

  context "data processing" do
    5.times do
      FactoryGirl.create(:fully_loaded_issue)
    end

    FactoryGirl.create(:repository_with_commits)

    let (:repo) { Repository.first }
    let (:repo_with_commits) { Repository.last}

    describe "#users_by_commits" do
      it "has number of user commits" do
        @data = repo_with_commits.users_by_commits
        @data[:committers].first["name"].should eq "octocat"
        @data[:committers].first["num"].should eq 6

        @data[:committers].last["name"].should eq "user2"
        @data[:committers].last["num"].should eq 4
      end
    end

    describe "#users_by_comments" do
      it "has number of user comments" do
        @data = repo.users_by_comments
        @data[:users_by_comments].first["name"].should eq "octocat"
        @data[:users_by_comments].first["num"].should eq 6

        @data[:users_by_comments].last["name"].should eq "user2"
        @data[:users_by_comments].last["num"].should eq 7
      end
    end

    describe "#to_json" do
      it "correctly formats a hash" do
        @data = repo.users_by_comments
        @json = @data.to_json
        @json.should eq "{\"users_by_comments\":[{\"name\":\"octocat\",\"num\":6},{\"name\":\"user2\",\"num\":7}]}"
      end
    end
  end
end
