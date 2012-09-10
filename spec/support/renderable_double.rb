require 'support/renderable_example'

class RenderableDouble
  include Enumerable
  def initialize(items = [], selection_index = 0)
    @items = items
    @selection_index = selection_index
  end

  def each(&block) @items.each(&block) end
  def selection_index() @selection_index end
end

describe RenderableDouble do
  it_behaves_like 'a renderable'
end
