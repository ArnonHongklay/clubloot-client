require 'rails_helper'

RSpec.describe "contests/new", type: :view do
  before(:each) do
    assign(:contest, Contest.new())
  end

  it "renders new contest form" do
    render

    assert_select "form[action=?][method=?]", contests_path, "post" do
    end
  end
end
