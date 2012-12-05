require 'spec_helper'

describe Commit do
  it { should belong_to :issue }

  it { should validate_presence_of :user }
  it { should validate_presence_of :date }

  describe '' do
    context '' do
    end
  end
end
