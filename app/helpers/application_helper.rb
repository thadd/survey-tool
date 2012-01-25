module ApplicationHelper
  def md(text)
    raw(BlueCloth.new(text).to_html)
  end
end
