require 'helper'
require 'support/renderable_double'
require 'cloudapp/cli/drops_renderer'
require 'date'

describe CloudApp::CLI::DropsRenderer do
  let(:renderable) { RenderableDouble.new(drops) }
  let(:drops) {[ DropDouble.new(name: 'one',   views: 3),
                 DropDouble.new(name: 'two',   views: 2, created: DateTime.now - 1),
                 DropDouble.new(name: 'three', views: 1) ]}

  describe '#render' do
    subject { CloudApp::CLI::DropsRenderer.new(renderable).render }

    it 'renders each drop' do
      expected = <<-END.chomp
one
  just now, 3
two
  a day ago, 2
three
  just now, 1
END
      subject.should eq(expected)
    end

    context 'with a trashed drop' do
      let(:drops) {[ DropDouble.new(name: 'one', views: 3, trashed: true) ]}

      it 'marks trashed drops' do
        trashed_drop = <<-END.chomp
\u2716 one
  just now, 3
END
        subject.should include(trashed_drop)
      end
    end

    context 'with a public drop' do
      let(:drops) {[ DropDouble.new(name: 'one', views: 3, private: false) ]}

      it 'marks trashed drops' do
        trashed_drop = <<-END.chomp
! one
  just now, 3
END
        subject.should include(trashed_drop)
      end
    end

    context 'with a trashed, public drop' do
      let(:drops) {[
        DropDouble.new(name: 'one', views: 3, trashed: true, private: false)
      ]}

      it 'marks trashed drops' do
        trashed_drop = <<-END.chomp
\u2716! one
  just now, 3
END
        subject.should include(trashed_drop)
      end
    end
  end

  describe '#selection_line_number' do
    let(:renderable) { RenderableDouble.new(drops, 1) }
    subject {
      CloudApp::CLI::DropsRenderer.new(renderable).selection_line_number
    }

    it 'returns the line number' do
      subject.should eq(2)
    end
  end
end

DropDouble = Struct.new :name, :created, :views, :trashed
class DropDouble
  attr_reader :name, :views, :created
  def initialize(options = {})
    @name    = options.fetch :name, 'Drop'
    @views   = options.fetch :views, 0
    @created = options.fetch :created, DateTime.now
    @trashed = options.fetch :trashed, false
    @private = options.fetch :private, true
  end
  def trashed?() @trashed end
  def private?() @private end
end

describe DropDouble do
  subject { DropDouble.new }
  it { should respond_to(:name) }
  it { should respond_to(:created) }
  it { should respond_to(:views) }
  it { should respond_to(:trashed?) }
  it { should respond_to(:private?) }
end
