module ExpensesHelper
  def create_expense(expense, category_ids)
    categories = []
    category_ids.each_with_index do |category_id, idx|
      categories << category_id unless idx.zero?
    end

    expense.transaction do
      categories.each do |category_id|
        @category = Category.find(category_id)
        ExpenseCategory.save_category(@category, expense)
      end
    end
  end

  def category_expenses(category_id)
    @expenses = []
    @expense_categories = ExpenseCategory.where(category_id: category_id).order(created_at: :desc)
    @expense_categories.each do |expense_category|
      @expenses.push(Expense.find(expense_category.expense_id))
    end

    @expenses
  end

  def total_category_expense(category_id)
    total_expense_amount = 0
    category_expenses(category_id).each do |expense|
      total_expense_amount += expense.amount
    end
    total_expense_amount
  end
end
