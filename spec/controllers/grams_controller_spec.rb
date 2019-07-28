require 'rails_helper'

RSpec.describe GramsController, type: :controller do

	describe "grams#index action" do
		it "should successfully show the page" do
			get :index
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#new action" do
		it "should require users to be logged in" do
			get :new
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully show the new form" do
	      user = FactoryBot.create(:user)
	      sign_in user

	      get :new
	      expect(response).to have_http_status(:success)
	    end
	end

	describe "grams#create action" do
		it "should require users to be logged in" do
			post :create, params: { gram: { message: "Hello" } }
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully create a new gram in our database" do
			user = FactoryBot.create(:user)
	      	sign_in user

			post :create, params: {gram: {message: 'Hello!'}}
			expect(response).to redirect_to root_path
			gram = Gram.last
			expect(gram.message).to eq('Hello!')
			expect(gram.user).to eq(user)
		end

		it "should successfully create a new 5char gram in our database" do
			user = FactoryBot.create(:user)
	      	sign_in user

			post :create, params: {gram: {message: '#'*5}}
			expect(response).to redirect_to root_path
		end

		it "should fail to create a new 4char gram in our database" do
			user = FactoryBot.create(:user)
	      	sign_in user

			post :create, params: {gram: {message: '#'*4}}
			expect(response).to have_http_status(:unprocessable_entity)
		end

		it "should successfully create a new 100char gram in our database" do
			user = FactoryBot.create(:user)
	      	sign_in user

			post :create, params: {gram: {message:  '#'*100}}
			expect(response).to redirect_to root_path
		end

		it "should fail to create a new 101char gram in our database" do
			user = FactoryBot.create(:user)
	      	sign_in user

			post :create, params: {gram: {message:  '#'*101}}
			expect(response).to have_http_status(:unprocessable_entity)
		end

		it "should properly deal with validation errors" do
			user = FactoryBot.create(:user)
	      	sign_in user

			gram_count = Gram.count
			post :create, params: {gram: {message: ''}}
			expect(response).to have_http_status(:unprocessable_entity)
			expect(gram_count).to eq Gram.count
		end
	end
end
