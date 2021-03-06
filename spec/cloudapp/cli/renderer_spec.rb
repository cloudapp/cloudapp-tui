require 'helper'
require 'support/renderable_double'
require 'cloudapp/tui/renderer'

describe CloudApp::TUI::Renderer do
  let(:renderable) { RenderableDouble.new %w( one two three ), 1 }
  subject { CloudApp::TUI::Renderer.new(renderable) }

  describe '#render' do
    it 'renders each filter' do
      expected = <<-END.chomp
one
two
three
END
      subject.render.should eq(expected)
    end
  end

  describe '#selection_line_number' do
    it 'returns the selection index' do
      subject.selection_line_number.should eq(1)
    end
  end
end
