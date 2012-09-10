require 'helper'
require 'support/navigable_collection_example'
require 'support/renderable_example'
require 'cloudapp/cli/help'

describe CloudApp::CLI::Help do
  subject { CloudApp::CLI::Help.new }

  it_behaves_like 'a navigable collection'
  it_behaves_like 'a renderable'

  its(:first_page) { should eq(subject) }
  its(:previous_page) { should eq(subject) }
  its(:next_page) { should eq(subject) }
  its(:selection_index) { should eq(0) }
  its(:selection) { should be_nil }
  its(:previous_selection) { should equal(subject) }

  describe '#each' do
    subject { CloudApp::CLI::Help.new.to_a }
    it 'iterates each message' do
      subject.should_not be_empty
    end
  end
end
