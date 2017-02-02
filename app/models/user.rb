class User
  include Mongoid::Document
  include Mongoid::Paperclip

  has_many :ratings
  has_and_belongs_to_many :rooms, inverse_of: :users

  after_create :initial_leaderboard

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  ## Database authenticatable
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## User Info
  field :username, type: String, default: ""
  field :first_name, type: String, default: ""
  field :last_name, type: String, default: ""
  field :bio, type: String, default: ""
  field :dob, type: Date
  field :gender, type: Symbol
  field :zip_code, type: String

  ## Recoverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count, type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip, type: String

  # omminuath
  field :provider, type: String, default: ""
  field :uid, type: String, default: ""

  # stats
  field :skill,        type: Float, default: 0.0
  field :timeliness,   type: Float, default: 0.0
  field :completion,   type: Float, default: 0.0
  field :language,     type: Float, default: 0.0
  field :friendliness, type: Float, default: 0.0

  # free text descriptions
  field :type_of_game,  type: String
  field :time_to_play,  type: String
  field :gear_used,     type: String
  field :stream,        type: String
  field :chat_time,     type: String

  has_mongoid_attached_file :avatar,
    styles: {
      :medium   => ['250x250',    :jpg]
    },
    default_url: '/assets/user_no_avatar.png'

  validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  validates_uniqueness_of :username

  validates :username, :first_name, :last_name, :bio, :dob, :gender, :zip_code, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider   = auth.provider
      user.email      = auth.info.email
      user.first_name = auth.extra.raw_info.first_name
      user.last_name  = auth.extra.raw_info.last_name
      user.password   = Devise.friendly_token[0,20]
      user.gender     = auth.extra.raw_info.gender
      user.dob        = auth.extra.raw_info.birthday
    end
  end

  def update_stats
    stats = %w{skill timeliness completion language friendliness}
    cumulative = {}
    self.ratings.each do |rating|
      stats.each {|stat| cumulative[stat] = cumulative[stat] ? cumulative[stat] + rating[stat] : rating[stat] }
    end

    cumulative.each {|k, v| cumulative[k] = v / ratings.count }

    if update!(cumulative)
      change_score(cumulative.values.inject(0.0){|sum, x| sum + x } / cumulative.size)
    end
  end

  def rating
    stats = %w{skill timeliness completion language friendliness}
    (stats.inject(0) {|sum, stat| sum + self[stat].clamp(0, 10) } / stats.length).to_i / 2
  end

  def need_more_information?
    %w{type_of_game time_to_play gear_used steam chat_time}.collect{|x| self[x].blank? }.any?
    false
  end

end
