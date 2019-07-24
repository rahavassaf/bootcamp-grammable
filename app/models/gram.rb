class Gram < ApplicationRecord
	validates :message, presence: true, length: { maximum: 100, minimum: 5 }
end
