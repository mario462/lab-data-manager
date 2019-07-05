class StudiesController < ApplicationController
  include Access
  before_action :set_study, only: [:show, :edit, :update, :destroy,
                                   :toggle_favorite, :members, :add_member]
  before_action :set_permission, only: [:update_permission]

  def add_member
    options = { fallback_location: study_path(@study) }
    notice = 'Successfully added new member.'
    params = add_member_params
    error_message = @study.add_member(params)
    if error_message.nil?
      options[:notice] = notice
    else
      options[:alert] = error_message
    end
    redirect_back options
  end

  def members
    @permissions = @study.permissions
  end

  def favorites
    @studies = current_user.favorites
    @favorites = true
    render 'studies/index'
  end

  def toggle_favorite
    if @study.in? current_user.favorites
      current_user.favorites.delete(@study)
      notice = "The study has been removed from your favorites."
    else
      current_user.favorites << @study
      notice = "The study has been added to your favorites."
    end
    redirect_back fallback_location: studies_path, notice: notice
  end

  # GET /studies
  # GET /studies.json
  def index
    @studies = current_user.available_studies
  end

  # GET /studies/1
  # GET /studies/1.json
  def show
  end

  # GET /studies/new
  def new
    @study = Study.new
  end

  # GET /studies/1/edit
  def edit
  end

  # POST /studies
  # POST /studies.json
  def create
    @study = Study.new(study_params)

    respond_to do |format|
      if @study.save
        set_study_owner(@study)
        format.html { redirect_to @study, notice: 'Study was successfully created.' }
        format.json { render :show, status: :created, location: @study }
      else
        format.html { render :new }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /studies/1
  # PATCH/PUT /studies/1.json
  def update
    respond_to do |format|
      if @study.update(study_params)
        format.html { redirect_to @study, notice: 'Study was successfully updated.' }
        format.json { render :show, status: :ok, location: @study }
      else
        format.html { render :edit }
        format.json { render json: @study.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /studies/1
  # DELETE /studies/1.json
  def destroy
    @study.destroy
    respond_to do |format|
      format.html { redirect_to studies_url, notice: 'Study was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_permission
      @permission = Permission.find(params[:id])
    end

    def set_study_owner(study)
      Permission.create(study: study, user: current_user, access: Access::DESTROY)
      current_user.favorites << study
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_study
      @study = Study.find(params[:id])
      @datasets = @study.datasets
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def study_params
      params.require(:study).permit(:name, :description, :url, :visibility)
    end

    def permission_params
      params.require(:permission).permit(:access)
    end

    def add_member_params
      params.permit(:email, :access)
    end
end
