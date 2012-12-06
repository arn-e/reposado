class Commit < ActiveRecord::Base
  belongs_to :repository
  validates_presence_of :git_user, :date

  def self.most_recent_commit(repo_id)
    most_recent_commit = DateTime.parse("1900-12-02 22:39:44")
    Repository.find(repo_id).commits.each do |commit|
      (most_recent_commit = commit.date) if commit.date > most_recent_commit
    end
    most_recent_commit
  end

  def self.update_commit_data(commit_data, repo_id)
    commit_data.each do |commit|
      # logger.debug("error : #{commit}")
      @new_commit = Commit.new
      @new_commit.repository_id = repo_id
      @new_commit.sha = commit["sha"]
      if commit["parents"].length != 0
        @new_commit.parent_sha = commit["parents"][0]["sha"] # add multiple parents?
      end
      if commit["commit"] != nil
        @new_commit.message = commit["commit"]["message"]
      end
      if commit["committer"] != nil
        if commit["committer"]["login"] == nil
          @new_commit.git_user = commit["commit"]["committer"]["name"]
        elsif commit["committer"]["login"] != nil
          @new_commit.git_user = commit["committer"]["login"]
        else
          @new_commit.git_user = " "
        end
        @new_commit.date = DateTime.parse(commit["commit"]["committer"]["date"])
        # if sha_collection[@new_commit.sha].nil?
          @new_commit.save 
          # sha_collection[@new_commit.sha] = 1
        # end
      end
    end
    # sha_collection
  end

end
