require 'rails_helper'

RSpec.describe "contests/index", type: :view do
  before(:each) do
    assign(:contests, [
      Contest.create!(),
      Contest.create!()
    ])
  end

  it "renders a list of contests" do
    render
  end
end
