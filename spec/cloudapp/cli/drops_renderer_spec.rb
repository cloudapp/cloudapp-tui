require 'helper'
require 'cloudapp/cli/drops_renderer'

describe CloudApp::CLI::DropsRenderer do
  describe '#render' do
    let(:renderables) {[ RenderableDouble.new('one'),
                         RenderableDouble.new('two'),
                         RenderableDouble.new('three') ]}
    subject { CloudApp::CLI::DropsRenderer.new(renderables).render }

    it 'renders a list of names' do
      expected = "one\ntwo\nthree"
      subject.should eq(expected)
    end
  end
end

RenderableDouble = Struct.new :name

describe RenderableDouble do
  subject { RenderableDouble.new }

  it 'has a name' do
    subject.should respond_to(:name)
  end
end
