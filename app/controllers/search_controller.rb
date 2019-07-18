class SearchController < ApplicationController
  skip_authorization_check
  before_action :check_authentication

  def search
    @query = Query.new(query_params)
    studies = FilterHelper::filter_for_search(current_user.available_studies, @query.text_query)
    datasets = FilterHelper::filter_for_search(current_user.available_datasets, @query.text_query)
    @studies = Set.new(studies).union(datasets.map(&:study))
    render 'search'
  end

  private
  def check_authentication
    raise CanCan::AccessDenied unless current_user
  end

  def query_params
    if params[:query]
      params.require(:query).permit(:text_query, :min_year, :max_year, :min_subjects, :max_subjects, :required_data,
                                    :required_attachment, :selected_data_types => []).to_hash.symbolize_keys
    else
      {}
    end
  end
end
