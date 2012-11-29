FactoryGirl.define do
  factory :repository do |f|
    f.name "Reposado"
    f.url "https://github.com/reposado/reposado"
  end

  factory :issue do |f|
    repository
    f.title "Found a bug"
    f.body "I'm having a problem with this."
  end

  factory :commit do |f|
    issue
    f.user "octocat"
    f.date DateTime.strptime("2011-04-14T16:00:49Z")
  end

  factory :comment do |f|
    issue
    f.user "octocat"
    f.date DateTime.strptime("2011-04-14T16:00:49Z")
    f.body "Me too"
  end

  factory :event do
    issue
    status "open"
    date DateTime.strptime("2011-04-14T16:00:49Z")
    user "octocat"
  end

  # NOTE: How to create fully loaded repository? Following code creates separate repository for each new issue
  factory :fully_loaded_issue, :parent => :issue do
    after(:create) do |issue|
      FactoryGirl.create_list(:commit, 2, :issue => issue, :date => DateTime.strptime("2011-05-14T16:00:49Z"))
      FactoryGirl.create_list(:commit, 2, :issue => issue, :date => DateTime.strptime("2011-05-14T17:00:49Z"))
      FactoryGirl.create_list(:commit, 2, :issue => issue, :date => DateTime.strptime("2011-05-14T18:00:49Z"))

      FactoryGirl.create_list(:commit, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T15:00:49Z"))
      FactoryGirl.create_list(:commit, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T14:00:49Z"))

      FactoryGirl.create_list(:comment, 2, :issue => issue, :date => DateTime.strptime("2011-04-14T16:00:49Z"))
      FactoryGirl.create_list(:comment, 2, :issue => issue, :date => DateTime.strptime("2011-04-14T17:00:49Z"))
      FactoryGirl.create_list(:comment, 2, :issue => issue, :date => DateTime.strptime("2011-04-14T18:00:49Z"))

      FactoryGirl.create_list(:comment, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T12:00:49Z"))
      FactoryGirl.create_list(:comment, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T11:00:49Z"))
      FactoryGirl.create_list(:comment, 3, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T10:00:49Z"))

      FactoryGirl.create_list(:event, 2, :issue => issue, :date => DateTime.strptime("2011-06-14T16:00:49Z"))
      FactoryGirl.create_list(:event, 2, :issue => issue, :date => DateTime.strptime("2011-06-14T17:00:49Z"))
      FactoryGirl.create_list(:event, 2, :issue => issue, :date => DateTime.strptime("2011-06-14T18:00:49Z"))

      FactoryGirl.create_list(:event, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T07:00:49Z"))
      FactoryGirl.create_list(:event, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T08:00:49Z"))
      FactoryGirl.create_list(:event, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T09:00:49Z"))
    end
  end

  # factory :fully_loaded_repo, :parent => :repository do
  #   after(:create) do |repo|
  #     FactoryGirl.create(:fully_loaded_issue)
  #   end
  # end
      # factory :fully_loaded_issue, :parent => :issue do
      #   after(:create) do |issue|
      #     FactoryGirl.create_list(:commit, 2, :issue => issue, :date => DateTime.strptime("2011-05-14T16:00:49Z"))
      #     FactoryGirl.create_list(:commit, 2, :issue => issue, :date => DateTime.strptime("2011-05-14T17:00:49Z"))
      #     FactoryGirl.create_list(:commit, 2, :issue => issue, :date => DateTime.strptime("2011-05-14T18:00:49Z"))

      #     FactoryGirl.create_list(:commit, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T15:00:49Z"))
      #     FactoryGirl.create_list(:commit, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T14:00:49Z"))

      #     FactoryGirl.create_list(:comment, 2, :issue => issue, :date => DateTime.strptime("2011-04-14T16:00:49Z"))
      #     FactoryGirl.create_list(:comment, 2, :issue => issue, :date => DateTime.strptime("2011-04-14T17:00:49Z"))
      #     FactoryGirl.create_list(:comment, 2, :issue => issue, :date => DateTime.strptime("2011-04-14T18:00:49Z"))

      #     FactoryGirl.create_list(:comment, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T12:00:49Z"))
      #     FactoryGirl.create_list(:comment, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T11:00:49Z"))
      #     FactoryGirl.create_list(:comment, 3, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T10:00:49Z"))

      #     FactoryGirl.create_list(:event, 2, :issue => issue, :date => DateTime.strptime("2011-06-14T16:00:49Z"))
      #     FactoryGirl.create_list(:event, 2, :issue => issue, :date => DateTime.strptime("2011-06-14T17:00:49Z"))
      #     FactoryGirl.create_list(:event, 2, :issue => issue, :date => DateTime.strptime("2011-06-14T18:00:49Z"))

      #     FactoryGirl.create_list(:event, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T07:00:49Z"))
      #     FactoryGirl.create_list(:event, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T08:00:49Z"))
      #     FactoryGirl.create_list(:event, 2, :issue => issue, :user => "user2", :date => DateTime.strptime("2011-05-14T09:00:49Z"))
      #   end
      # end
    # end
  # end
end


