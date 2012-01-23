class Survey
  include Mongoid::Document

  field :name
  field :xml

  validates_presence_of :name

  belongs_to :user
end
