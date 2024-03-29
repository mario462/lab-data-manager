class AccessRequestsController < ApplicationController
  before_action :set_study, only: [:new]
  before_action :set_request, only: [:approve, :deny, :destroy, :hide]
  skip_authorization_check

  def approve
    authorize! :manage, @request.study
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
    authorize! :manage, @request.study
    params = { user: @request.user, study: @request.study }
    error_message = @request.study.remove_member(params)
    options = { fallback_location: studies_path }
    if error_message
      options[:alert] = error_message
    else
      @request.update(status: AccessRequestStatus::DENIED)
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
    @requests = AccessRequest.where("study_id IN (?) AND user_id != ?", studies_ids, current_user.id)
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
        if @request.errors[:uniqueness]
          redirect_to studies_path, alert: @request.errors[:uniqueness].join('.') and return
        end
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def hide
    authorize! :manage, @request.study
    @request.hidden = true
    @request.save
    redirect_back fallback_location: incoming_access_requests_url, notice: 'You wont be seeing this request anymore'
  end

  # DELETE /access_request/1
  # DELETE /access_request/1.json
  def destroy
    raise CanCan::AccessDenied unless @request.user_id == current_user.id
    @request.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: studies_url, notice: 'Access request was successfully destroyed.' }
      format.json { head :no_content }
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
