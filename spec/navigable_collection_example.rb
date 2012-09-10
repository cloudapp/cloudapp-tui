shared_examples 'a navigable collection' do
  it { should be_an(Enumerable) }
  it { should respond_to(:first_page) }
  it { should respond_to(:previous_page) }
  it { should respond_to(:next_page) }
  it { should respond_to(:selection_index) }
  it { should respond_to(:selection) }
  it { should respond_to(:previous_selection) }
  it { should respond_to(:next_selection) }
end
