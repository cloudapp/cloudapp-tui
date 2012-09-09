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
  end
end

RenderableDouble = Struct.new :name, :created, :views

describe RenderableDouble do
  subject { RenderableDouble.new }

  it 'has a name' do
    subject.should respond_to(:name)
  end

  it 'has a created date' do
    subject.should respond_to(:created)
  end

  it 'has views' do
    subject.should respond_to(:views)
  end
end
