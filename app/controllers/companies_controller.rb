# coding: utf-8  
class CompaniesController < ApplicationController
  around_filter do |controller, action|
    if !@current_user.has_privilege?(controller.controller_name, controller.action_name)
      flash[:notice] = "你没有#{controller.controller_name}.#{controller.action_name}权限，请联系管理员"
      render_403
    else
      action.call
    end
  end
  # GET /companies
  # GET /companies.xml
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.xml
  def show
    @company = Company.find(params[:id])
  end

  # GET /companies/new
  # GET /companies/new.xml
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
  end

  # POST /companies
  # POST /companies.xml
  def create
    @company = Company.new(params[:company])


    if @company.save
      redirect_to(@company, :notice => 'Company was successfully created.')
    else
      render :action => "new"

    end

  end

  # PUT /companies/1
  # PUT /companies/1.xml
  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(params[:company])
      redirect_to(@company, :notice => 'Company was successfully updated.')

    else
      render :action => "edit"

    end

  end

  # DELETE /companies/1
  # DELETE /companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    respond_with(@company, :location=>:back)
  end
end
