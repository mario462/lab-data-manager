class SearchController < ApplicationController
  skip_authorization_check
  before_action :check_authentication

  def search
    query = filter_params[:query]
    studies = current_user.available_studies
    studies = FilterHelper::filter_for_search(studies, query)
    datasets = current_user.available_datasets
    datasets = FilterHelper::filter_for_search(datasets, query)
    @studies = Set.new(studies).union(datasets.map(&:study))
    render 'search'
  end

  def filter

  end

  private
  def check_authentication
    raise CanCan::AccessDenied unless current_user
  end

  def filter_params
    params.permit(:query)
  end
end
