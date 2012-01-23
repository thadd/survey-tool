class User
  include Mongoid::Document

  field :uid
  field :name
  field :email

  has_many :surveys

  validates_presence_of :uid
end
