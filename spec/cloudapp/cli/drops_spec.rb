require 'helper'
require 'cloudapp/cli/drops'

describe CloudApp::CLI::Drops do
  let(:drops) { DropsDouble.new count: 0 }
  subject { CloudApp::CLI::Drops.new drops }

  it 'is an Enumerable' do
    subject.should be_kind_of(Enumerable)
  end

  it 'accepts an optional selected index' do
    subject = CloudApp::CLI::Drops.new (0..2).to_a, selected_index: 2
    subject.selected_index.should eq(2)
  end

  describe '#each' do
    subject { CloudApp::CLI::Drops.new(drops) }

    it 'delegates to drops' do
      drops.should_receive(:each).with(no_args).and_return(:response)
      subject.each.should eq(:response)
    end
  end

  describe '#next_page' do
    let(:drops) { DropsDouble.new follow: next_page, has_link?: true }
    let(:next_page) { DropsDouble.new }
    subject { CloudApp::CLI::Drops.new(drops) }

    it 'follows the next link' do
      drops.should_receive(:follow).with('next').and_return(next_page)

      subject = CloudApp::CLI::Drops.new drops
      subject.next_page
    end

    it 'returns the next page of drops' do
      subject.next_page.should be_a(CloudApp::CLI::Drops)
    end

    context 'with no next page' do
      let(:drops) { DropsDouble.new has_link?: false }

      it 'returns itself' do
        subject.next_page.should eq(subject)
      end

      it 'follows no links' do
        drops.should_not_receive(:follow)
        subject.next_page.should eq(subject)
      end
    end
  end

  describe '#previous_page' do
    let(:drops) { DropsDouble.new follow: previous_page, has_link?: true }
    let(:previous_page) { DropsDouble.new }
    subject { CloudApp::CLI::Drops.new(drops) }

    it 'follows the previous link' do
      drops.should_receive(:follow).with('previous').and_return(previous_page)

      subject = CloudApp::CLI::Drops.new drops
      subject.previous_page
    end

    it 'returns the previous page of drops' do
      subject.previous_page.should be_a(CloudApp::CLI::Drops)
    end

    context 'with no previous page' do
      let(:drops) { DropsDouble.new count: 42, follow: nil, has_link?: false }

      it 'returns itself' do
        subject.previous_page.should eq(subject)
      end

      it 'follows no links' do
        drops.should_not_receive(:follow)
        subject.previous_page.should eq(subject)
      end
    end
  end

  describe '#first_page' do
    let(:drops) { DropsDouble.new follow: first_page, has_link?: true }
    let(:first_page) { DropsDouble.new }
    subject { CloudApp::CLI::Drops.new(drops) }

    it 'follows the first link' do
      drops.should_receive(:follow).with('first').and_return(first_page)

      subject = CloudApp::CLI::Drops.new drops
      subject.first_page
    end

    it 'returns the first page of drops' do
      subject.first_page.should be_a(CloudApp::CLI::Drops)
    end

    context 'with no first page' do
      let(:drops) { DropsDouble.new count: 42, follow: nil, has_link?: false }

      it 'returns itself' do
        subject.first_page.should eq(subject)
      end

      it 'follows no links' do
        drops.should_not_receive(:follow)
        subject.first_page.should eq(subject)
      end
    end
  end

  describe '#selected_index' do
    let(:drops) { DropsDouble.new count: 2 }

    it 'defaults to 0' do
      subject.selected_index.should eq(0)
    end

    it 'returns the given selected index' do
      subject = CloudApp::CLI::Drops.new drops, selected_index: 1
      subject.selected_index.should eq(1)
    end

    it 'maxes out at the number of drops' do
      subject = CloudApp::CLI::Drops.new drops, selected_index: 42
      subject.selected_index.should eq(1)
    end

    it 'mins out at 0' do
      subject = CloudApp::CLI::Drops.new drops, selected_index: -42
      subject.selected_index.should eq(0)
    end
  end

  describe '#selection' do
    let(:drops) { DropsDouble.new count: 42 }
    subject { CloudApp::CLI::Drops.new drops, selected_index: 2 }

    it 'returns the selection' do
      selection = :selection
      drops.should_receive(:[]).with(2).and_return(selection)
      subject.selection.should eq(selection)
    end
  end
end

class DropsDouble
  attr_reader :count
  def has_link?(link) @has_link end
  def follow(link)    @follow   end
  def [](index)       @index    end

  def initialize(options = {})
    @count    = options.fetch :count,     0
    @follow   = options.fetch :follow,    nil
    @has_link = options.fetch :has_link?, nil
  end
end

# I like the idea of asserting that my double adheres to the defined interface,
# but I'm not too thrilled that this particular interface is outside of my
# control. It's the response from CloudApp::Service#drops.
describe DropsDouble do
  subject { DropsDouble.new }

  it { should respond_to(:count) }

  it 'responds to #follow' do
    subject.should respond_to(:follow)
    -> { subject.follow('link') }.should_not raise_error(ArgumentError)
  end

  it 'responds to #has_link?' do
    subject.should respond_to(:has_link?)
    -> { subject.has_link?('link') }.should_not raise_error(ArgumentError)
  end

  it 'responds to #[]' do
    subject.should respond_to(:[])
  end
end
