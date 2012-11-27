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
end
