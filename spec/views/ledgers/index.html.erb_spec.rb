require 'rails_helper'

RSpec.describe "ledgers/index", type: :view do
  before(:each) do
    assign(:ledgers, [
      Ledger.create!(),
      Ledger.create!()
    ])
  end

  it "renders a list of ledgers" do
    render
  end
end
