require 'rails_helper'

RSpec.describe "programs/new", type: :view do
  before(:each) do
    assign(:program, Program.new())
  end

  it "renders new program form" do
    render

    assert_select "form[action=?][method=?]", programs_path, "post" do
    end
  end
end
