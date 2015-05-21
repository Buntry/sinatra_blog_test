class Post < ActiveRecord::Base
	has_many :comments
	
	validates :title, presence: true, length: { minimum: 5 }
 	validates :body, presence: true, length: {minimum: 14 }
end