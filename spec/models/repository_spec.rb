require 'spec_helper'

describe Repository do
  it { should have_many :issues }
end
