# class HomeController < ApplicationController
#   before_action :require_login
#   before_action :set_user

#   def index
#   end

#   def balance
#   end

#   def deposit_form
#   end

#   def deposit
#     amount = params[:amount].to_i

#     if amount <= 0
#       flash[:alert] = "Enter a valid amount greater than 0"
#       redirect_to deposit_path and return
#     end

#     @user.update(balance: @user.balance + amount)
#     redirect_to balance_path, notice: "Successfully deposited ₹#{amount}"
#   end

#   def withdraw_form
#   end

#   def withdraw
#     amount = params[:amount].to_i

#     if amount <= 0
#       flash[:alert] = "Amount must be greater than 0"
#       redirect_to withdraw_path and return
#     end

#     if amount > @user.balance
#       flash[:alert] = "Insufficient balance!"
#       redirect_to withdraw_path and return
#     end

#     @user.update(balance: @user.balance - amount)
#     redirect_to balance_path, notice: "₹#{amount} withdrawn successfully!"
#   end

#   private

#   def set_user
#     @user = User.find(session[:user_id])
#   end

#   def require_login
#     redirect_to login_path, alert: "Please log in first" unless session[:user_id]
#   end
# end
class HomeController < ApplicationController
  before_action :require_login
  before_action :set_user

  def index
  end

  def balance
    @balance = current_balance
  end

  def deposit_form
  end

  def deposit
    amount = params[:amount].to_i

    if amount <= 0
      flash[:alert] = "Enter a valid amount greater than 0"
      redirect_to deposit_path and return
    end

    old_balance = current_balance
    new_balance = old_balance + amount

    @user.transactions.create!(
      previous_balance: old_balance,
      amount: amount,
      new_balance: new_balance,
      transaction_type: "deposit"
    )

    redirect_to balance_path, notice: "Successfully deposited ₹#{amount}"
  end

  def withdraw_form
  end

  def withdraw
    amount = params[:amount].to_i
    old_balance = current_balance

    if amount <= 0
      flash[:alert] = "Amount must be greater than 0"
      redirect_to withdraw_path and return
    end

    if amount > old_balance
      flash[:alert] = "Insufficient balance!"
      redirect_to withdraw_path and return
    end

    new_balance = old_balance - amount

    @user.transactions.create!(
      previous_balance: old_balance,
      amount: amount,
      new_balance: new_balance,
      transaction_type: "withdraw"
    )

    redirect_to balance_path, notice: "₹#{amount} withdrawn successfully!"
  end

  def transactions_list
    @transactions = @user.transactions.order(created_at: :desc)
  end

  private

  def current_balance
    @user.transactions.last&.new_balance || 0
  end

  def set_user
    @user = User.find(session[:user_id])
  end

  def require_login
    redirect_to login_path, alert: "Please log in first" unless session[:user_id]
  end
end
