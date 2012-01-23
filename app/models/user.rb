class User
  include Mongoid::Document

  field :uid
  field :name
  field :email

  validates_presence_of :uid

  has_many :surveys
end
