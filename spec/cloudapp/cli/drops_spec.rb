require 'helper'
require 'support/navigable_collection_example'
require 'support/renderable_example'
require 'cloudapp/cli/drops'

describe CloudApp::CLI::Drops do
  let(:drops) { DropsDouble.new count: 0 }
  subject { CloudApp::CLI::Drops.new drops }

  it_behaves_like 'a navigable collection'
  it_behaves_like 'a renderable'

  describe '#each' do
    subject { CloudApp::CLI::Drops.new(drops) }

    it 'delegates to drops' do
      drops.should_receive(:each).with(no_args).and_return(:response)
      subject.each.should eq(:response)
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

  describe '#selection_index' do
    let(:drops) { DropsDouble.new count: 2 }

    it 'defaults to 0' do
      subject.selection_index.should eq(0)
    end

    it 'returns the given selection index' do
      subject = CloudApp::CLI::Drops.new drops, selection_index: 1
      subject.selection_index.should eq(1)
    end

    it 'maxes out at the number of drops' do
      subject = CloudApp::CLI::Drops.new drops, selection_index: 42
      subject.selection_index.should eq(1)
    end

    it 'mins out at 0' do
      subject = CloudApp::CLI::Drops.new drops, selection_index: -42
      subject.selection_index.should eq(0)
    end
  end

  describe '#selection' do
    let(:drops) { DropsDouble.new count: 42 }
    subject { CloudApp::CLI::Drops.new drops, selection_index: 2 }

    it 'returns the selection' do
      selection = :selection
      drops.should_receive(:[]).with(2).and_return(selection)
      subject.selection.should eq(selection)
    end
  end

  describe '#previous_selection' do
    let(:drops) { DropsDouble.new count: 2 }
    subject {
      CloudApp::CLI::Drops.new(drops, selection_index: 1).previous_selection
    }

    it { should be_a(CloudApp::CLI::Drops) }
    its(:selection_index) { should eq(0) }
  end

  describe '#next_selection' do
    let(:drops) { DropsDouble.new count: 2 }
    subject { CloudApp::CLI::Drops.new(drops).next_selection }

    it { should be_a(CloudApp::CLI::Drops) }
    its(:selection_index) { should eq(1) }
  end

  describe '#trash_selection' do
    let(:drops) { DropsDouble.new count: 3, selection: selection, follow: self_page }
    let(:selection) { DropDouble.new }
    let(:self_page) { DropsDouble.new count: 3 }
    subject { CloudApp::CLI::Drops.new(drops, selection_index: 1).trash_selection }

    it { should be_a(CloudApp::CLI::Drops) }
    its(:selection_index) { should eq(1) }

    it 'trashes the drop' do
      selection.should_receive(:trash).once
      subject
    end

    it 'refreshes the same page of drops' do
      drops.should_receive(:follow).with('self').once.and_return(self_page)
      subject
    end
  end

  describe '#recover_selection' do
    let(:drops) { DropsDouble.new count: 3, selection: selection, follow: self_page }
    let(:selection) { DropDouble.new }
    let(:self_page) { DropsDouble.new count: 3 }
    subject { CloudApp::CLI::Drops.new(drops, selection_index: 1).recover_selection }

    it { should be_a(CloudApp::CLI::Drops) }
    its(:selection_index) { should eq(1) }

    it 'recovers the drop' do
      selection.should_receive(:recover).once
      subject
    end

    it 'refreshes the same page of drops' do
      drops.should_receive(:follow).with('self').once.and_return(self_page)
      subject
    end
  end

  describe '#toggle_selection_privacy' do
    let(:drops) { DropsDouble.new count: 3, selection: selection, follow: self_page }
    let(:selection) { DropDouble.new }
    let(:self_page) { DropsDouble.new count: 3 }
    subject {
      CloudApp::CLI::Drops.new(drops, selection_index: 1).
        toggle_selection_privacy
    }

    it { should be_a(CloudApp::CLI::Drops) }
    its(:selection_index) { should eq(1) }

    it "togglees the drop's privacy" do
      selection.should_receive(:toggle_privacy).once
      subject
    end

    it 'refreshes the same page of drops' do
      drops.should_receive(:follow).with('self').once.and_return(self_page)
      subject
    end
  end
end

class DropsDouble
  attr_reader :count
  def has_link?(link) @has_link  end
  def follow(link)    @follow    end
  def [](index)       @selection end

  def initialize(options = {})
    @count     = options.fetch :count,     0
    @follow    = options.fetch :follow,    nil
    @has_link  = options.fetch :has_link?, nil
    @selection = options.fetch :selection, nil
  end
end

class DropDouble
  def trash() end
  def recover() end
  def toggle_privacy() end
end

# I like the idea of asserting that my double adheres to the defined interface,
# but I'm not too thrilled that this particular interface is outside of my
# control. It's the response from CloudApp::Service#drops.
describe DropsDouble do
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

describe DropDouble do
  it { should respond_to(:trash) }
  it { should respond_to(:recover) }
  it { should respond_to(:toggle_privacy) }
end
