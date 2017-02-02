class Contest
  include Mongoid::Document
  srore_in collection: 'templates', database: 'clubloot-development'

  field :name,  type: String
  field :stage, type: String
  field :owner, type: Hash
  field :max_player, type: Integer

  embeds_many :players
  embedded_in :template
end
