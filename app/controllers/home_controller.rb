# coding: utf-8  
class HomeController < ApplicationController
  def index
    @house = House.first
  end

end
