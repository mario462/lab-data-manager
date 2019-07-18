class SearchController < ApplicationController
  skip_authorization_check
  before_action :check_authentication

  def search
    query = filter_params[:query]
    studies = current_user.available_studies
    sql_query = 'name LIKE ? or description LIKE ?'
    studies = studies.where(sql_query, "%#{query}%", "%#{query}%")
    datasets = Dataset.where("#{sql_query} AND study_id IN (?)", "%#{query}%", "%#{query}%", studies.pluck(:id))
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
