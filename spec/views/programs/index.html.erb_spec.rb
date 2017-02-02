require 'rails_helper'

RSpec.describe "programs/index", type: :view do
  before(:each) do
    assign(:programs, [
      Program.create!(),
      Program.create!()
    ])
  end

  it "renders a list of programs" do
    render
  end
end
