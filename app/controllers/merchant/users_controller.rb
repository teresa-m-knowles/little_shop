class Merchant::UsersController < Merchant::BaseController
  def show
    @orders = Order.pending_orders(current_user)
    @user = current_user
  end
end
