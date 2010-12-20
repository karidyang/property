# coding: utf-8  
class ApplicationController < ActionController::Base
  respond_to :html, :xml
  protect_from_forgery
end
