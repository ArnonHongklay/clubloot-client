class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic

  field :name,              type: String
  field :program_id,        type: BSON::ObjectId
  field :program_name,      type: String
  field :number_questions,  type: String
  field :number_answers,    type: String

  embeds_many :questions
  embeds_many :contests


  # field :start_time,        type: DateTime
  # field :end_time,          type: DateTime
  # field :active,            type: Boolean
end
