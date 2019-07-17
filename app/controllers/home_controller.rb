class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check
  def index
    @cards = Card.get_home_cards
  end
end
