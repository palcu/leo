class HomeController < ApplicationController
  def index
    @users = User.all
    @cover = 'cover.jpg'
  end
end
