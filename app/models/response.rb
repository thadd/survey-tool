class Response
  include Mongoid::Document

  field :session
  field :answers, type: Hash, default: {}
  field :completed_page, type: Integer, default: -1
  field :finished, type: Boolean, default: false

  embedded_in :survey

  before_save :check_for_finished

  scope :complete, where(finished: true)
  scope :incomplete, where(finished: false)

  protected

  def check_for_finished
    self.finished = self.completed_page == (self.survey.page_count - 1)
    true
  end
end
