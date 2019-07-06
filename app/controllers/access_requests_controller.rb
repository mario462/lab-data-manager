class AccessRequestsController < ApplicationController
  before_action :set_study, only: [:new]
  before_action :set_request, only: [:approve, :deny]

  def approve
    @request.update(status: AccessRequestStatus::APPROVED)
    params = { user: @request.user, access: Access::VIEW }
    error_message = @request.study.add_member(params)
    options = { fallback_location: studies_path }
    if error_message
      options[:alert] = error_message
    else
      options[:notice] = 'The request was successfully approved and user will be notified.'
    end
    redirect_back options
  end

  def deny
    @request.update(status: AccessRequestStatus::DENIED)
    params = { user: @request.user, study: @request.study }
    error_message = @study.remove_member(params)
    options = { fallback_location: studies_path }
    if error_message
      options[:alert] = error_message
    else
      options[:notice] = 'The request was denied and user will be notified.'
    end
    redirect_back options
  end

  def outgoing
    @requests = AccessRequest.where(user: current_user)
    render 'access_requests/index'
  end

  def incoming
    @incoming = true
    studies_ids = current_user.owned_studies.collect(&:id)
    @requests = AccessRequest.where("study_id IN (?)", studies_ids)
    render 'access_requests/index'
  end

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
  def set_request
    @request = AccessRequest.find(params[:id])
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_study
    @study = Study.find(params[:study_id])
  end

  def access_request_params
    params.require(:access_request).permit(:study_id, :user_id, :motivation)
  end
end
