class GramsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

	def index
	end

	def new
		@gram = Gram.new
	end

	def create
		@gram = current_user.grams.create(gram_params)

		if @gram.invalid?
			render :new, status: :unprocessable_entity
		else
			redirect_to root_path
		end
	end

	def show
		begin
			@gram = Gram.find(params[:id])
		rescue
			render :file => "/public/404.html",  :status => :not_found
		end
	end

	def edit
		begin
			@gram = Gram.find(params[:id])
		rescue
			return render :file => "/public/404.html",  :status => :not_found
		end

		if @gram.user != current_user
			return render plain: "Unauthorized", status: :unauthorized
		end
	end

	def update
		begin
			@gram = Gram.find(params[:id])
		rescue
			return render :file => "/public/404.html",  :status => :not_found
		end

		if @gram.user_id != current_user.id
			return render plain: "Unauthorized", status: :unauthorized
		end

		@gram.update_attributes(gram_params)

		if @gram.invalid?
			render :edit, status: :unprocessable_entity
		else
			redirect_to gram_path(@gram)
		end
	end

	def destroy
		begin
			@gram = Gram.find(params[:id])
		rescue
			return render :file => "/public/404.html",  :status => :not_found
		end

		if @gram.user != current_user
			return render plain: "Unauthorized", status: :unauthorized
		end

		@gram.destroy
		redirect_to root_path
	end

	private

	def gram_params
		params.require(:gram).permit(:message, :picture)
	end
end
