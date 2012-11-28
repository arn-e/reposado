require 'spec_helper'

describe Event do
  it {should belong_to :issue }

  it { should validate_presence_of :status }
  it { should validate_presence_of :date }
  it { should validate_presence_of :user }
end
