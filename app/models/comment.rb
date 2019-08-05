class Comment < ApplicationRecord
	belongs_to :user
	belongs_to :gram

	validates :message, presence: true, length: { maximum: 100, minimum: 5 }
end
