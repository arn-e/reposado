require 'spec_helper'

describe Repository do
  it { should have_many :issues }
  it { should have_many :commits }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context "initialization" do
    it "has the correct name" do
      @repo = FactoryGirl.build(:repository)
      @repo.name.should eq "/pengwynn/octokit"
    end

    it "has the correct url" do
      @repo = FactoryGirl.build(:repository)
      @repo.url.should eq "https://github.com/pengwynn/octokit"
    end

    describe ".from_url" do
      before(:all) do
        VCR.use_cassette('repositories') do
          Repository.from_url("https://github.com/reposado/reposado")
        end
        @repo = Repository.find_by_name('/reposado/reposado')
      end

      it "creates a new Repository" do
        @repo.should_not be_nil
      end

      it "correctly sets the name of the Repository" do
        @repo.name.should eq "/reposado/reposado"
      end

      it "correctly sets the URL of the Repository" do
        @repo.url.should eq "https://github.com/reposado/reposado"
      end

      it "returns cached data if the input URL is already in the database" do
        expect {
          Repository.from_url("https://github.com/reposado/reposado")
          }.to change{ Repository.count }.by(0)
      end

      it "saves a new Repository if it doesn't already exist" do
        Repository.stub(:issues_from_github)
        Repository.stub(:collect_commits)

        expect {
          Repository.from_url("https://github.com/rails/rails")
          }.to change{ Repository.count }.by(1)
      end

      it "collects child Issues" do
        @repo.issues.length.should eq 1
      end

      it "collects child Commits" do
        @repo.commits.length.should > 1
      end
    end
  end

  context "data processing" do
    # 5.times do
    #   FactoryGirl.create(:fully_loaded_issue)
    # end

    # FactoryGirl.create(:repository_with_commits)

    let (:repo_with_commits) { FactoryGirl.create(:repository_with_commits) }
    # let (:repo_with_commits) { Repository.last}

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
        pending
        # @data = repo_with_comments.users_by_comments
        # @data[:users_by_comments].first["name"].should eq "octocat"
        # @data[:users_by_comments].first["num"].should eq 6

        # @data[:users_by_comments].last["name"].should eq "user2"
        # @data[:users_by_comments].last["num"].should eq 7
      end
    end

    describe "#to_json" do
      it "correctly formats a hash" do
        @data = repo_with_commits.users_by_commits
        @json = @data.to_json
        @json.should eq "{\"committers\":[{\"name\":\"octocat\",\"num\":6},{\"name\":\"user2\",\"num\":4}]}"
      end
    end
  end
end
