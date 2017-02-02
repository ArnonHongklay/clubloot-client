require 'rails_helper'

RSpec.describe "programs/show", type: :view do
  before(:each) do
    @program = assign(:program, Program.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
