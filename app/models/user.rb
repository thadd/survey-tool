class User
  include Mongoid::Document

  field :name
  field :email

  has_many :surveys

  validates_presence_of :email
end
