require 'helper'
require 'support/navigable_collection_example'
require 'support/renderable_example'
require 'cloudapp/cli/filters'

describe CloudApp::CLI::Filters do
  subject { CloudApp::CLI::Filters.new }

  it_behaves_like 'a navigable collection'
  it_behaves_like 'a renderable'

  describe '#each' do
    it 'iterates each filter' do
      expected = %w( Active Trash All )
      filters = []
      subject.each do |filter|
        filters << filter
      end

      filters.should eq(expected)
    end
  end

  describe '#first_page' do
    it 'returns itself' do
      subject.first_page.should eq(subject)
    end
  end

  describe '#previous_page' do
    it 'returns itself' do
      subject.previous_page.should eq(subject)
    end
  end

  describe '#next_page' do
    it 'returns itself' do
      subject.next_page.should eq(subject)
    end
  end

  describe '#selection_index' do
    it 'defaults to 0' do
      subject.selection_index.should eq(0)
    end

    it 'returns the given selected index' do
      filters = CloudApp::CLI::Filters.new selection_index: 1
      filters.selection_index.should eq(1)
    end

    it 'maxes out at 2' do
      filters = CloudApp::CLI::Filters.new selection_index: 42
      filters.selection_index.should eq(2)
    end

    it 'mins out at 0' do
      filters = CloudApp::CLI::Filters.new selection_index: -42
      filters.selection_index.should eq(0)
    end
  end

  describe '#selection' do
    it 'returns the selected filter' do
      filters = CloudApp::CLI::Filters.new selection_index: 0
      filters.selection.should eq('active')

      filters = CloudApp::CLI::Filters.new selection_index: 1
      filters.selection.should eq('trash')

      filters = CloudApp::CLI::Filters.new selection_index: 2
      filters.selection.should eq('all')
    end
  end

  describe '#previous_selection' do
    subject { CloudApp::CLI::Filters.new(selection_index: 1).previous_selection }

    it { should be_a(CloudApp::CLI::Filters) }
    its(:selection_index) { should eq(0) }
  end

  describe '#next_selection' do
    subject { CloudApp::CLI::Filters.new(selection_index: 0).next_selection }

    it { should be_a(CloudApp::CLI::Filters) }
    its(:selection_index) { should eq(1) }
  end
end
