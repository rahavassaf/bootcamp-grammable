class Gram < ApplicationRecord
	belongs_to :user
	has_many :comments
	
	mount_uploader :picture, PictureUploader
	validates :message, presence: true, length: { maximum: 100, minimum: 5 }
	validates :picture, presence: true
end
