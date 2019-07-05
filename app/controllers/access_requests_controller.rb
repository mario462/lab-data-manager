class AccessRequestsController < ApplicationController
  before_action :set_study, only: [:new]

  # GET /studies/new
  def new
    @request = AccessRequest.new(study: @study, user: current_user)
  end

  # POST /studies
  # POST /studies.json
  def create
    @request = AccessRequest.new(access_request_params)

    respond_to do |format|
      if @request.save
        format.html { redirect_to studies_path, notice: 'Your request has been successfully created and study admins will be notified.' }
        format.json { render :show, status: :created, location: studies_path }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_study
    @study = Study.find(params[:study_id])
  end

  def access_request_params
    params.require(:access_request).permit(:study_id, :user_id, :motivation)
  end
end
