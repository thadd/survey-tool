class SurveysController < ApplicationController
  def index
    @surveys = Survey.all
  end

  def new
    @survey = current_user.surveys.new
  end
end
