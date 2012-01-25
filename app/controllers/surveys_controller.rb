class SurveysController < ApplicationController
  before_filter :validate_user, except: :index
  before_filter :get_survey, except: [:index, :new, :create]

  def index
    @surveys = Survey.all
  end

  def new
    @survey = current_user.surveys.new
  end

  def edit; end

  def create
    @survey = current_user.surveys.build(params[:survey])

    if @survey.save
      redirect_to root_url, notice: 'Added survey'
    else
      render 'new'
    end
  end

  def update
    @survey.update_attributes(params[:survey])

    if @survey.save
      if params[:commit] == "Save and continue editing"
        flash.now[:notice] = 'Saved survey'
        render 'edit'
      elsif params[:commit] == "Save and preview"
        redirect_to action: 'preview'
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

  protected

  def get_survey
    @survey = current_user.surveys.find(params[:id])
  end
end
