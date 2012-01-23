require 'xmlsimple'

class Survey
  include Mongoid::Document

  field :name
  field :xml, default: File.new(File.join(Rails.root, 'app', 'assets', 'surveys', 'default.xml')).read
  field :content, type: Hash

  belongs_to :user

  validates_presence_of :name
  validate :xml_should_be_valid

  def self.human_attribute_name(*args)
    case args[0]
    when :xml then 'Survey XML'
    else args[0].to_s.humanize
    end
  end

  def hashie_content
    Hashie::Mash.new(content)
  end

  protected

  def xml_should_be_valid
    begin
      self.content = XmlSimple.xml_in(self.xml)
    rescue REXML::ParseException => oops
      errors.add(:xml, "is malformed: #{oops.explain}")
    end
  end
end
