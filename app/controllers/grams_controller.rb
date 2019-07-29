class GramsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create]

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

	private

	def gram_params
		params.require(:gram).permit(:message)
	end
end
