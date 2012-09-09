require 'helper'
require 'cloudapp/cli/drops_renderer'
require 'date'

describe CloudApp::CLI::DropsRenderer do
  describe '#render' do
    let(:renderables) {[ RenderableDouble.new('one',   DateTime.now, 3),
                         RenderableDouble.new('two',   DateTime.now - 1, 2),
                         RenderableDouble.new('three', DateTime.now, 1) ]}
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
      let(:renderables) {[ RenderableDouble.new('one', DateTime.now, 3, true) ]}

      it 'marks trashed drops' do
        trashed_drop = <<-END.chomp
\u2716 one
  just now, 3
END
        subject.should include(trashed_drop)
      end
    end
  end
end

RenderableDouble = Struct.new :name, :created, :views, :trashed
class RenderableDouble
  alias_method :trashed?, :trashed
end

describe RenderableDouble do
  subject { RenderableDouble.new }
  it { should respond_to(:name) }
  it { should respond_to(:created) }
  it { should respond_to(:views) }
  it { should respond_to(:trashed?) }
end
