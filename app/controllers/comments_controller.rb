class CommentsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

	def create
		begin
			gram = Gram.find(params[:gram_id])
		rescue
			return render :file => "/public/404.html",  :status => :not_found
		end

    	comment = gram.comments.create(comment_params.merge(user: current_user))

    	if comment.invalid?
    		return render plain: "invalid input", status: :unprocessable_entity
    	else
    		redirect_to root_path
    	end
	end

	private

	def comment_params
		params.require(:comment).permit(:message)
	end
end
