class SurveysController < ApplicationController
  before_filter :validate_user, except: :index
  before_filter :get_survey, except: [:index, :new, :create]

  def index
    @surveys = current_user.surveys if current_user
  end

  def new
    @survey = current_user.surveys.new
  end

  def edit; end

  def create
    @survey = current_user.surveys.build(params[:survey])

    if @survey.save
      if params[:commit] == "Save and preview"
        redirect_to preview_survey_url(@survey)
      else
        redirect_to root_url, notice: 'Added survey'
      end
    else
      render 'new'
    end
  end

  def update
    @survey.update_attributes(params[:survey])

    if @survey.save
      if params[:commit] == "Save and continue editing"
        flash[:notice] = 'Saved survey'
        flash[:scroll_top] = params[:scroll_top]
        redirect_to edit_survey_url(@survey)
      elsif params[:commit] == "Save and preview"
        redirect_to preview_survey_url(@survey)
      else
        redirect_to root_url, notice: 'Saved survey'
      end
    else
      render 'edit'
    end
  end

  def destroy
    @survey.destroy

    redirect_to root_url, notice: 'Removed survey'
  end

  def preview
  end

  def clear
    @survey.responses.delete_all
    redirect_to :back
  end

  protected

  def get_survey
    @survey = current_user.surveys.find(params[:id])
  end
end
