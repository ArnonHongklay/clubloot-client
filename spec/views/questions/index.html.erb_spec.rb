require 'rails_helper'

RSpec.describe "questions/index", type: :view do
  before(:each) do
    assign(:questions, [
      Question.create!(),
      Question.create!()
    ])
  end

  it "renders a list of questions" do
    render
  end
end
