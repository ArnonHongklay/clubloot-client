require 'rails_helper'

RSpec.describe "ledgers/edit", type: :view do
  before(:each) do
    @ledger = assign(:ledger, Ledger.create!())
  end

  it "renders the edit ledger form" do
    render

    assert_select "form[action=?][method=?]", ledger_path(@ledger), "post" do
    end
  end
end
