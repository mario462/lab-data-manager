class PermissionsController < ApplicationController
  before_action :set_permission, only: [:update, :destroy]

  # PATCH/PUT /studies/1
  # PATCH/PUT /studies/1.json
  def update
    options = { fallback_location: study_path(@study) }
    notice = 'Permission updated successfully'
    if @study.permissions.count <= 1
      options[:alert] = 'You cannot modify permissions for a study with a single member.'
    end
    unless :alert.in?(options)
      if @permission.update(permission_params)
        options[:notice] = notice
      else
        options[:alert] = 'There was an error updating the permissions.'
      end
    end
    redirect_back options
  end

  # DELETE /studies/1
  # DELETE /studies/1.json
  def destroy
    options = { fallback_location: study_path(@study) }
    error_message = @study.remove_member({ permission: @permission })
    if error_message
      options[:alert] = error_message
    else
      options[:notice] = 'Member was successfully removed from project.'
    end
    respond_to do |format|
      format.html { redirect_back options }
      format.json { head :no_content }
    end
  end

  private
  def set_permission
    @permission = Permission.find(params[:id])
    @study = @permission.study
  end

  def permission_params
    params.require(:permission).permit(:access)
  end
end
