class ExpensesController < ApplicationController
  load_and_authorize_resource
  include ExpensesHelper

  def index
    @expenses = category_expenses
  end

  def show; end

  def new
    @expense = Expense.new
    @categories = Category.where(author: current_user)
  end

  def create
    @expense = Expense.create(expense_params)
     p request.referrer
    create_expense(@expense, params[:category][:category_id])

    if @expense.save
      redirect_to categories_path, notice: 'Added expense successfully!'
    else
      render :new, alert: 'Expense was not added!'
    end
  end

  def destroy; end

  def expense_params
    expense_hash = params.require(:expense).permit(:name, :amount)
    expense_hash[:author] = current_user
    expense_hash
  end
end
