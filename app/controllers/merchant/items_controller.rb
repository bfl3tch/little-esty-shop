class Merchant::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_items = @merchant.merchant_items  #helper method for item specific to merchant
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to merchant_items_path(params[:merchant_id])
      flash[:notice] = "#{@item.name} successfully Created."
    else
      redirect_to new_merchant_item_path(params[:merchant_id])
      flash[:alert] = "All fields are required."
    end
  end

  def update
    item = Item.find(params[:id])
    item.update(item_model_params)
    return redirect_back(fallback_location: merchant_items_path(item.merchant_id)) if params[:direct] == 'enable'
    redirect_to merchant_item_path(item.merchant_id, item.id), notice: "Item successfully updated."
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :enable, :merchant_id)
  end

  def item_model_params
    params.require(:item).permit(:name, :description, :unit_price, :enable)
  end
end
