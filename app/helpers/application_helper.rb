module ApplicationHelper
  def md(text)
    raw(BlueCloth.new(text).to_html)
  end

  def question_id(id)
    "response[page_answers][#{id}]"
  end

  def dependent_options(component, response)
    style = ""

    options = {}

    if component[:depends] && preview?
      options[:title] = "Dependent on #{component[:depends]} having value #{component[:dependsvalue]}"
      options[:class] = "dependent"
    end

    if response
      if component[:depends] && answer = response.answers[component[:depends]]
        options[:style] = "display:none;"

        if answer.is_a? Hash
          options[:style] = "" if answer[component[:dependsvalue]] == "1"
        else
          options[:style] = "" if answer == component[:dependsvalue]
        end
      end
    end

    options
  end

  def preview?
    params[:action] == 'preview'
  end
end
