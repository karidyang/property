class AccountsController < ApplicationController
  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @accounts }
    end
  end

    # GET /accounts/1
    # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

    # GET /accounts/new
    # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # add_pre_money.html.erb
      format.xml { render :xml => @account }
    end
  end

    # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

    # POST /accounts
    # POST /accounts.xml
  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        format.html { redirect_to(@account, :notice => 'Account was successfully created.') }
        format.xml { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

    # PUT /accounts/1
    # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to(@account, :notice => 'Account was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

    # DELETE /accounts/1
    # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml { head :ok }
    end
  end

  def history
    @account = Account.find(params[:id])
    @details = @account.in_details
  end

  def add_pre_money
    if request.post?
      @detail = AccountDetail.new
      @detail.unit_price=params[:unitPrice]
      @detail.record = params[:record]
      @detail.can_push=params[:can_push]
      @detail.account_type=1
      @detail.money = @detail.record*@detail.unit_price

      @account = Account.find_by_item_id_and_house_id(params[:item_id],params[:house_id])
      @charge = Charge.find(params[:item_id])

      if !@account
        @account = Account.create(:house_id=>params[:house_id],
                                  :house_code=>params[:house_code],
                                  :item_id=>@charge.id,
                                  :item_name=>@charge.item_name,
                                  :plot_id=>params[:plot_id])

      end

      @account.transaction_in(@detail)
      @account.save
      redirect_to root_path
    else
      @house = House.find(params[:house_id])

      @items = Charge.where("plot_id=?", @house.plot_id)
      render 'add_pre_money'
    end
  end
end
