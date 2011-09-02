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
