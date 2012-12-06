require 'spec_helper'

describe Event do
  it {should belong_to :issue }

  it { should validate_presence_of :status }
  it { should validate_presence_of :date }
  it { should validate_presence_of :git_user }

  let(:json) { {"created_at" => "2012-12-02 22:39:44", "actor" => { "login" => "dummy_login"}, "event" => "dummy_event"}}

  describe 'from_json' do

    it "assigns the correct values to events" do
      event = Event.from_json(json)
      event.date.should eql(DateTime.parse("2012-12-02 22:39:44"))
      event.git_user.should eql("dummy_login")
      event.status.should eql("dummy_event")
    end
  end
end
