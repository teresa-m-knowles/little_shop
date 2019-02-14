require 'rails_helper'

RSpec.describe 'Admin users index page' do
  context 'as an admin' do
    describe 'when I click on Users in the nav' do
      before :each do
        @admin = create(:admin, email: 'email1')
        @user_1 = create(:user, email: 'email2')
        @user_2 = User.create(name: 'John', city: 'Denver', state: 'CO', email: 'john@tim.com', password: 'password', address: '123 Main St.', zipcode: '12345', disabled: true)
        @user_3 = create(:merchant, email: 'email3')
      end
      it 'I see all users who are not merchants or admins' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

        visit root_path

        click_link 'Users'

        expect(current_path).to eq(admin_users_path)
        expect(page).to have_content(@user_1.name)
        expect(page).to have_content(@user_2.name)
        expect(page).to_not have_content(@user_3.name)
      end

      it 'each user\'s name is a link to their show page' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

        visit items_path

        click_link 'Users'
        click_link(@user_1.name)
        expect(current_path).to eq(admin_user_path(@user_1))
      end

      it 'next to each user\'s name is the date they registered' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

        visit root_path

        click_link 'Users'
        expect(page).to have_content(@user_1.created_at)
      end

      it 'I see an enable or disable button next to each user' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

        visit root_path

        click_link 'Users'
        within "#user-#{@user_1.id}" do
          expect(page).to have_button('Disable')
        end

        within "#user-#{@user_2.id}" do
          expect(page).to have_button('Enable')
        end
      end
    end
  end
end
