require 'rails_helper'

RSpec.describe "contests/edit", type: :view do
  before(:each) do
    @contest = assign(:contest, Contest.create!())
  end

  it "renders the edit contest form" do
    render

    assert_select "form[action=?][method=?]", contest_path(@contest), "post" do
    end
  end
end
