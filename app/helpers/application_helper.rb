module ApplicationHelper
  def md(text)
    raw(BlueCloth.new(text).to_html)
  end

  def question_id(id)
    "response[page_answers][#{id}]"
  end

  def hidden_if_dependent(component, response)
    style = ""

    if response
      if component[:depends] && answer = response.answers[component[:depends]]
        style = "display:none;"

        if answer.is_a? Hash
          style = "" if answer[component[:dependsvalue]] == "1"
        else
          style = "" if answer == component[:dependsvalue]
        end
      end
    end

    style
  end
end
