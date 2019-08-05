require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
	describe "comments#create action" do
		it "should allow users to create comments on grams" do
			gram = FactoryBot.create(:gram)
			user = FactoryBot.create(:user)
			sign_in user

			post :create, params: {gram_id: gram.id, comment: {message: 'awesome gram'}}

			expect(response).to redirect_to root_path
			expect(gram.comments.length).to eq 1
			expect(gram.comments.last.message).to eq 'awesome gram'
		end

		it "should reject comments with invalid messages length" do
			gram = FactoryBot.create(:gram)
			user = FactoryBot.create(:user)
			sign_in user

			post :create, params: {gram_id: gram.id, comment: {message: '#'*4}}
			expect(response).to have_http_status :unprocessable_entity
			expect(gram.comments.length).to eq 0

			post :create, params: {gram_id: gram.id, comment: {message: '#'*101}}
			expect(response).to have_http_status :unprocessable_entity
			expect(gram.comments.length).to eq 0
		end

		it "should accept comments with valid messages length" do
			gram = FactoryBot.create(:gram)
			user = FactoryBot.create(:user)
			sign_in user

			post :create, params: {gram_id: gram.id, comment: {message: '#'*5}}
			expect(response).to redirect_to root_path
			gram.reload()
			expect(gram.comments.last.message).to eq '#'*5

			post :create, params: {gram_id: gram.id, comment: {message: '#'*100}}
			expect(response).to redirect_to root_path
			gram.reload()
			expect(gram.comments.last.message).to eq '#'*100
		end

		it "should require a user to be logged in to comment on a gram" do
			gram = FactoryBot.create(:gram)

			post :create, params: {gram_id: gram.id, comment: {message: 'awesome gram'}}

			expect(response).to redirect_to new_user_session_path
		end

		it "should return http status code 404 if the gram isn't found" do
			user = FactoryBot.create(:user)
			sign_in user
			
			post :create, params: {gram_id: 0, comment: {message: 'awesome gram'}}
			
			expect(response).to have_http_status :not_found
		end
	end
end
