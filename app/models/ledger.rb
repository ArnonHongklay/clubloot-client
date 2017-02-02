class Ledger
  include Mongoid::Document

  field :status,      type: String
  field :format,      type: String


end
