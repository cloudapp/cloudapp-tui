require 'helper'
require 'support/renderables_double'
require 'cloudapp/cli/drops_renderer'
require 'date'

describe CloudApp::CLI::DropsRenderer do
  let(:renderables) { RenderablesDouble.new(drops) }
  let(:drops) {[ DropDouble.new('one',   DateTime.now,     3),
                 DropDouble.new('two',   DateTime.now - 1, 2),
                 DropDouble.new('three', DateTime.now,     1) ]}

  describe '#render' do
    subject { CloudApp::CLI::DropsRenderer.new(renderables).render }

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
      let(:drops) {[ DropDouble.new('one', DateTime.now, 3, true) ]}

      it 'marks trashed drops' do
        trashed_drop = <<-END.chomp
\u2716 one
  just now, 3
END
        subject.should include(trashed_drop)
      end
    end
  end

  describe '#selection_line_number' do
    let(:renderables) { RenderablesDouble.new(drops, 1) }
    subject {
      CloudApp::CLI::DropsRenderer.new(renderables).selection_line_number
    }

    it 'returns the line number' do
      subject.should eq(2)
    end
  end
end

DropDouble = Struct.new :name, :created, :views, :trashed
class DropDouble
  alias_method :trashed?, :trashed
end

describe DropDouble do
  subject { DropDouble.new }
  it { should respond_to(:name) }
  it { should respond_to(:created) }
  it { should respond_to(:views) }
  it { should respond_to(:trashed?) }
end
