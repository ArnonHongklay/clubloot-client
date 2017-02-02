require 'rails_helper'

RSpec.describe "ledgers/show", type: :view do
  before(:each) do
    @ledger = assign(:ledger, Ledger.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
