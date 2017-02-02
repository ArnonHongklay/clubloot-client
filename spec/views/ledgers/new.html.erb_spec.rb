require 'rails_helper'

RSpec.describe "ledgers/new", type: :view do
  before(:each) do
    assign(:ledger, Ledger.new())
  end

  it "renders new ledger form" do
    render

    assert_select "form[action=?][method=?]", ledgers_path, "post" do
    end
  end
end
