require 'rails_helper'

RSpec.describe GramsController, type: :controller do
	describe "grams#show action" do
		it "should successfully show the page if a gram is found" do
			gram = FactoryBot.create(:gram)
			get :show, params: {id: gram.id}
			expect(response).to have_http_status(:success)
		end

		it "should return error 404 if gram not found" do
			get :show, params: {id: 0}
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "grams#edit action" do
		it "should require users to be logged in" do
			gram = FactoryBot.create(:gram)
			get :edit, params: {id: gram.id}
			expect(response).to redirect_to new_user_session_path
		end

		it "should show the edit form if gram is found and owned by the current user" do
			user = FactoryBot.create(:user)
			sign_in user
			gram = FactoryBot.create(:gram, user: user)
			get :edit, params: {id: gram.id}
			expect(response).to have_http_status :success
		end

		it "should return unauthorized if the gram is not owned by the current user" do
			user = FactoryBot.create(:user)
			gram = FactoryBot.create(:gram, user: user)

			user2 = FactoryBot.create(:user)
			sign_in user2
			
			get :edit, params: {id: gram.id}
			expect(response).to have_http_status :unauthorized
		end

		it "should return error 404 if gram is not found" do
			user = FactoryBot.create(:user)
			sign_in user
			get :edit, params: {id: 0}
			expect(response).to have_http_status :not_found
		end
	end

	describe "grams#update action" do
		it "should require users to be logged in" do
			gram = FactoryBot.create(:gram)
			patch :update, params: {id: gram.id, message: "this should fail"} 
			expect(response).to redirect_to new_user_session_path
		end

		it "should return error 404 if gram not found" do
			user = FactoryBot.create(:user)
			sign_in user
			patch :update, params: {id: 0, message: "this should 404"}
			expect(response).to have_http_status :not_found
		end

		it "should update a gram if found and belongs to current user" do
			user = FactoryBot.create(:user)
			sign_in user

			gram = FactoryBot.create(:gram, user: user)

			patch :update, params: {id: gram.id, gram: { message: "this should succeed" }}
			gram.reload()

			expect(response).to redirect_to gram_path(gram)
			expect(gram.message).to eq("this should succeed")
		end

		it "should return unauthorized if gram is found but does not belong to current user" do
			user = FactoryBot.create(:user)
			gram = FactoryBot.create(:gram, user: user)

			user2 = FactoryBot.create(:user)
			sign_in user2

			patch :update, params: {id: gram.id, gram: { message: "this should fail" }}

			expect(response).to have_http_status :unauthorized
			expect(gram.message).to eq("Hello!")
		end

		it "should reject invalid message constraints" do
			user = FactoryBot.create(:user)
			sign_in user

			gram = FactoryBot.create(:gram, user: user)

			patch :update, params: {id: gram.id, gram: { message: "#"*4}}
			expect(response).to have_http_status :unprocessable_entity
			gram.reload()
			expect(gram.message).to eq('Hello!')

			patch :update, params: {id: gram.id, gram: { message: "#"*101}}
			expect(response).to have_http_status :unprocessable_entity
			gram.reload()
			expect(gram.message).to eq('Hello!')
		end

		it "should accept valid message constraints" do
			user = FactoryBot.create(:user)
			sign_in user

			gram = FactoryBot.create(:gram, user: user)

			patch :update, params: {id: gram.id, gram: { message: "#"*5}}
			expect(response).to redirect_to gram_path(gram)
			gram.reload()
			expect(gram.message).to eq("#"*5)

			patch :update, params: {id: gram.id, gram: { message: "#"*100}}
			expect(response).to redirect_to gram_path(gram)
			gram.reload()
			expect(gram.message).to eq("#"*100)
		end
	end

	describe "grams#destroy action" do
		it "should require users to be logged in" do
			gram = FactoryBot.create(:gram)
			delete :destroy, params: {id: gram.id}
			expect(response).to redirect_to new_user_session_path
		end

		it "should return error 404 if gram is not found" do
			user = FactoryBot.create(:user)
			sign_in user
			delete :destroy, params: {id: 0}
			expect(response).to have_http_status :not_found
		end

		it "should destroy a gram if it is found and owned by current user" do
			user = FactoryBot.create(:user)
			sign_in user

			gram = FactoryBot.create(:gram, user: user)

			delete :destroy, params: {id: gram.id}
			expect(response).to redirect_to root_path

			gram = Gram.last
			expect(gram).to be_nil
		end

		it "should return unauthorized if gram is found but does not belong to current user" do
			user = FactoryBot.create(:user)
			gram = FactoryBot.create(:gram, user: user)

			user2 = FactoryBot.create(:user)
			sign_in user2

			delete :destroy, params: {id: gram.id}

			expect(response).to have_http_status :unauthorized

			expect(Gram.last.id).to eq(gram.id)
		end
	end


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
