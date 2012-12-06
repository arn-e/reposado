require 'spec_helper'

describe Comment do
  it { should belong_to :issue }
  it { should validate_presence_of :git_user }
  it { should validate_presence_of :date }
  it { should validate_presence_of :body }

  let(:json) { {"user" => {"login" => "dummy_login"}, "body" => "dummy_body", "created_at" => "2012-12-02 22:39:44"}  }
  describe "from_json" do

    it "assigns the correct values to comments" do
      comment = Comment.from_json(json)
      comment.git_user.should eql("dummy_login")
      comment.body.should eql("dummy_body")
      comment.date.should eql(DateTime.parse("2012-12-02 22:39:44"))
    end

  end




end
