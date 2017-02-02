class Answer
  include Mongoid::Document

  field :name, type: String

  embedded_in :question
end
