class Gram < ApplicationRecord
	belongs_to :user
	mount_uploader :picture, PictureUploader
	validates :message, presence: true, length: { maximum: 100, minimum: 5 }
end
