class Question
  include Mongoid::Document

  field :is_correct,  type: Integer

  embeds_many :answers
  embedded_in :template
end
