require 'support/renderable_example'

class RenderablesDouble
  include Enumerable
  def initialize(rendersables = [], selection_index = 0)
    @rendersables    = rendersables
    @selection_index = selection_index
  end

  def each(&block) @rendersables.each(&block) end
  def selection_index() @selection_index end
end

describe RenderablesDouble do
  it_behaves_like 'a renderable'
end
