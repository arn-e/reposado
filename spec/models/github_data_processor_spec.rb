describe GithubDataProcessor do
  5.times do
    FactoryGirl.create(:fully_loaded_issue)
  end

  describe "#top_users_by_commits" do
    it "has number of user commits" do
      @data = GithubDataProcessor.top_users_by_commits
      @data.first[:username].should eq "octocat"
      @data.first[:commits].should eq 30

      @data.last[:username].should eq "user2"
      @data.last[:commits].should eq 20
    end

    it "" do
    end

  end

  describe "#top_users_by_comments" do
  end

  describe "#to_json" do
    it "converts a Ruby object to JSON" do
    end
  end
end


#GithubDataProcessor.top_users_by_commits.to_json => JSON object
