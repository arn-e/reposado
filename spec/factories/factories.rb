FactoryGirl.define do
  factory :repository do |f|
    f.name "/pengwynn/octokit"
    f.url "https://github.com/pengwynn/octokit"
  end

  factory :issue do |f|
    repository
    f.title "Found a bug"
    f.body "I'm having a problem with this."
  end

  factory :commit do
    repository
    git_user "octocat"
    date DateTime.strptime("2011-04-14T16:00:49Z")
  end

  factory :comment do
    issue
    git_user "octocat"
    date DateTime.strptime("2011-04-14T16:00:49Z")
    body "Me too"
  end

  factory :event do
    issue
    status "open"
    date DateTime.strptime("2011-04-14T16:00:49Z")
    git_user "octocat"
  end

  # NOTE: How to create fully loaded repository? Following code creates separate repository for each new issue
  factory :fully_loaded_issue, :parent => :issue do
    after(:create) do |issue|
      FactoryGirl.create_list(:comment, 2, :issue => issue, :date => DateTime.strptime("2011-04-14T16:00:49Z"))
      FactoryGirl.create_list(:comment, 2, :issue => issue, :date => DateTime.strptime("2011-04-14T17:00:49Z"))
      FactoryGirl.create_list(:comment, 2, :issue => issue, :date => DateTime.strptime("2011-04-14T18:00:49Z"))

      FactoryGirl.create_list(:comment, 2, :issue => issue, :git_user => "user2", :date => DateTime.strptime("2011-05-14T12:00:49Z"))
      FactoryGirl.create_list(:comment, 2, :issue => issue, :git_user => "user2", :date => DateTime.strptime("2011-05-14T11:00:49Z"))
      FactoryGirl.create_list(:comment, 3, :issue => issue, :git_user => "user2", :date => DateTime.strptime("2011-05-14T10:00:49Z"))

      FactoryGirl.create_list(:event, 2, :issue => issue, :date => DateTime.strptime("2011-06-14T16:00:49Z"))
      FactoryGirl.create_list(:event, 2, :issue => issue, :date => DateTime.strptime("2011-06-14T17:00:49Z"))
      FactoryGirl.create_list(:event, 2, :issue => issue, :date => DateTime.strptime("2011-06-14T18:00:49Z"))

      FactoryGirl.create_list(:event, 2, :issue => issue, :git_user => "user2", :date => DateTime.strptime("2011-05-14T07:00:49Z"))
      FactoryGirl.create_list(:event, 2, :issue => issue, :git_user => "user2", :date => DateTime.strptime("2011-05-14T08:00:49Z"))
      FactoryGirl.create_list(:event, 2, :issue => issue, :git_user => "user2", :date => DateTime.strptime("2011-05-14T09:00:49Z"))
    end
  end

  factory :repository_with_commits, :parent => :repository do
    after(:create) do |repo|
      FactoryGirl.create_list(:commit, 2, :repository => repo, :date => DateTime.strptime("2011-05-14T16:00:49Z"))
      FactoryGirl.create_list(:commit, 2, :repository => repo, :date => DateTime.strptime("2011-05-14T17:00:49Z"))
      FactoryGirl.create_list(:commit, 2, :repository => repo, :date => DateTime.strptime("2011-05-14T18:00:49Z"))

      FactoryGirl.create_list(:commit, 2, :repository => repo, :git_user => "user2", :date => DateTime.strptime("2011-05-14T15:00:49Z"))
      FactoryGirl.create_list(:commit, 2, :repository => repo, :git_user => "user2", :date => DateTime.strptime("2011-05-14T14:00:49Z"))
    end
  end

  factory :issue_with_comments, :parent => :issue do
    after(:create) do |issue|
      FactoryGirl.create_list(:comment, 2, :issue => issue, :date => DateTime.strptime("2011-05-14T16:00:49Z"))
      FactoryGirl.create_list(:comment, 2, :issue => issue, :git_user => "user2", :date => DateTime.strptime("2011-05-14T15:00:49Z"))
     end
  end
end


