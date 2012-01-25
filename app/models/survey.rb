class Survey
  include Mongoid::Document

  field :name
  field :xml, default: File.new(File.join(Rails.root, 'app', 'assets', 'surveys', 'default.xml')).read

  belongs_to :user

  validates_presence_of :name
  validate :xml_should_be_valid

  def self.human_attribute_name(*args)
    case args[0]
    when :xml then 'Survey XML'
    else args[0].to_s.humanize
    end
  end

  def page_count
    doc.xpath("/survey/page").count
  end

  def page_title(page)
    doc.xpath("//page")[page].attribute("title").value if doc.xpath("//page")[page].has_attribute?("title")
  end

  def confirmation
    @confirmation_content ||= doc.xpath("//confirmation").first.content rescue ""
    @confirmation_content.blank? ? nil : @confirmation_content
  end

  def components(page)
    nodes = doc.xpath("//page[#{page+1}]/*")

    out = []

    nodes.each do |node|
      node_hash = {}
      if node.name == 'questionset'
        node_hash[:type] = node.name
        node_hash[:text] = node.xpath("./text()").first.content.strip
        node_hash[:questions] = []

        node.attributes.each do |key,attribute|
          node_hash[key.to_sym] = attribute.value
        end

        node.xpath("./question").each do |question_node|
          question_node_hash = {}
          question_node_hash[:text] = question_node.xpath("./text()").first.content.strip

          question_node.attributes.each do |key,attribute|
            question_node_hash[key.to_sym] = attribute.value
          end

          node_hash[:questions] << question_node_hash
        end
      else
        node_hash[:type] = node.name
        node_hash[:text] = node.xpath("./text()").first.content.strip

        node.attributes.each do |key,attribute|
          node_hash[key.to_sym] = attribute.value
        end

        node_hash[:options] = {} if node.xpath("./option").length > 0

        node.xpath("./option").each do |option|
          node_hash[:options][option.attr("value")] = option.text
        end
      end

      out << node_hash
    end

    out
  end

  def scale_options(scale)
    scale_node = doc.xpath("//scale[@id='#{scale}']").first

    return {} if scale_node.nil?

    options = {}

    scale_node.xpath("option").each do |node|
      options[node.attr('value')] = node.text.blank? ? nil : node.text
    end

    options
  end

  def doc
    @doc ||= Nokogiri::XML(self.xml)
  end

  # TODO: move this bitch back
  protected

  def xml_should_be_valid
    doc.errors.each do |error|
      errors.add(:xml, "is malformed: #{error.message}")
    end
  end
end
