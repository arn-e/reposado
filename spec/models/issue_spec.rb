require 'spec_helper'

describe Issue do
  it { should belong_to :repository }
  it { should have_many :comments }

  it { should validate_presence_of :title}
  it { should validate_presence_of :body}
end
