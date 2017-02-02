require 'rails_helper'

RSpec.describe "contests/show", type: :view do
  before(:each) do
    @contest = assign(:contest, Contest.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
