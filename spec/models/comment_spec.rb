require 'spec_helper'

describe Comment do
  it { should belong_to :issue }

  it { should validate_presence_of :user }
  it { should validate_presence_of :date }
  it { should validate_presence_of :body }

  describe '' do
    context '' do
    end
  end

end
