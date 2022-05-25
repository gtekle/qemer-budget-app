require 'rails_helper'

RSpec.describe 'Categories', type: :system do
  before :all do
    Category.delete_all
    User.delete_all
    driven_by(:rack_test)

    visit '/users/sign_up'
    within('#new_user') do
      fill_in 'Email', with: 'adam@domain.com'
      fill_in 'Full name', with: 'Adam'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
    end
    user = User.first
    user.confirm

    category = Category.new(name: 'Foods and Drinks',
                     icon: 'category-icon',
                     author: user)
    category.save
  end

  context 'list view' do
    before :each do
      visit '/users/sign_in'
      within('#new_user') do
        fill_in 'Email', with: 'adam@domain.com'
        fill_in 'Password', with: 'password'
      end
      click_button 'Log in'
    end

    it 'should display categories in list view' do
      expect(current_path).to eq categories_path
      expect(page).to have_selector(:css, 'a#add_new_category')
      expect(page).to have_selector(:css, 'ul.list-group')
      within('ul.list-group') do
        expect(page).to have_css('li', count: 1)
      end
    end

    it 'should open add category page upon add category button click' do
      visit categories_path

      find("[id='add_new_category']").click
      
      expect(page).to have_current_path(new_category_path)
    end
    
    it 'should click category and redirect to expenses list' do
      category = Category.first
      id = "category_show#{category.id}"
      find("[id=#{id}]").click

      expect(page).to have_current_path(category_expenses_path(category_id: category.id))
    end
  end
end
