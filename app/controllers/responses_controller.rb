class ResponsesController < ApplicationController
  before_filter :get_survey
  before_filter :hide_login
  before_filter :get_response
  before_filter :validate_user, only: :index

  def index
    @survey = current_user.surveys.find(params[:survey_id])
    send_data @survey.generate_csv, filename: "#{@survey.name.parameterize}.csv"
  end

  def new
    @page = @response.completed_page + 1
  end

  def submit
    @response.completed_page = params[:response][:completed_page]
    @response.answers.merge!(params[:response][:page_answers])
    @response.save!
    redirect_to new_survey_response_url(@survey)
  end

  protected

  def get_response
    @response = @survey.responses.find_or_initialize_by(session: session_id)
  end

  def get_survey
    @survey = Survey.find(params[:survey_id])
  end

  def hide_login
    @hide_login_link = true
  end
end
