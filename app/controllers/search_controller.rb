class SearchController < ApplicationController
  skip_authorization_check
  before_action :check_authentication

  def search
    @query = Query.new(query_params)
    @studies = current_user.available_studies
    if @query.validate
      datasets = current_user.available_datasets.to_a
      @studies.each do |s|
        datasets << Dataset.create_from_study(s)
      end
      @studies = FilterHelper::filter_datasets(datasets, @query).uniq unless (datasets.nil? || datasets.empty?)
    end
    render 'search'
  end

  private
  def check_authentication
    raise CanCan::AccessDenied unless current_user
  end

  def query_params
    if params[:query]
      filtered = params.require(:query).permit(:text_query, :min_year, :max_year, :min_subjects, :max_subjects, :required_data,
                                               :required_attachment, :selected_data_types => []).to_hash.symbolize_keys
      filtered[:min_year] = filtered[:min_year].to_i
      filtered[:max_year] = filtered[:max_year].to_i
      filtered[:min_subjects] = filtered[:min_subjects].to_i
      filtered[:max_subjects] = filtered[:max_subjects].to_i
      filtered[:required_data] = !filtered[:required_data].nil?
      filtered[:required_attachment] = !filtered[:required_attachment].nil?
      filtered
    else
      {}
    end
  end
end
