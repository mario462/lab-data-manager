class DatasetsController < ApplicationController
  before_action :set_dataset, only: [:show, :edit, :update, :destroy, :download, :approve]
  load_and_authorize_resource
  skip_authorize_resource only: [:new, :create]

  # GET /studies
  # GET /studies.json
  def index
    @datasets = Dataset.all
  end

  # GET /datasets/1
  # GET /datasets/1.jso
  def show
  end

  # GET /datasets/new
  def new
    study = Study.find(params[:study])
    authorize! :edit, study
    @dataset = Dataset.new(year: Date.today.year, number_subjects: 1, study: study)
  end

  # GET /datasets/1/edit
  def edit
  end

  # POST /datasets
  # POST /datasets.json
  def create
    @dataset = Dataset.new(dataset_params)
    study = @dataset.study
    authorize! :edit, study

    respond_to do |format|
      if @dataset.save
        format.html { redirect_to @dataset,
                                  notice: 'Dataset was successfully created. Your new dataset must be reviewed by an administrator before making it public.' }
        format.json { render :show, status: :created, location: @dataset }
      else
        format.html { render :new }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /datasets/1
  # PATCH/PUT /datasets/1.json
  def update
    respond_to do |format|
      if @dataset.update(dataset_params)
        format.html { redirect_to @dataset, notice: 'Dataset was successfully updated.' }
        format.json { render :show, status: :ok, location: @dataset }
      else
        format.html { render :edit }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /datasets/1
  # DELETE /datasets/1.json
  def destroy
    @dataset.destroy
    respond_to do |format|
      format.html { redirect_to study_path(@dataset.study), notice: 'Dataset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    @dataset.downloads += 1
    @dataset.save
    send_file File.join(Rails.root, 'public', @dataset.data.url)
  end

  def approve
    @dataset.pending = false
    @dataset.save
    redirect_back(fallback_location: study_path(@dataset.study), notice: 'Dataset was approved.')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dataset
      @dataset = Dataset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dataset_params
      filtered = params.require(:dataset).permit(:name, :description, :url, :year, :number_subjects, :pipeline,
                                                 :quotation, :data, :attachment, :study_id, data_type_ids: [])
      filtered[:data_type_ids].reject!(&:blank?)
      filtered
    end
end
