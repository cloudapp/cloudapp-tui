shared_examples 'a renderable' do
  it { should be_an(Enumerable) }
  it { should respond_to(:each) }
  it { should respond_to(:selection_index) }
end
