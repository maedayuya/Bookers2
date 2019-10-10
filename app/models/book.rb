class Book < ApplicationRecord
	belongs_to :user
	has_many :book_comments, dependent: :destroy
	has_many :favorites, dependent: :destroy

	def favorited_by?(user)
    	favorites.where(user_id: user.id).exists?
  	end

  	def self.search(model,search_method,search)

	  	if model == "book"
	      if search_method == "完全一致"
	      	# 〜に完全に一致する
	        Book.where(['title LIKE ?', "#{search}"])
	      elsif search_method == "を含む"
	      	# 〜を含む
	        Book.where(['title LIKE ?', "%#{search}%"])
	      elsif search_method == "から始まる"
	        # 〜から始まる
	        Book.where(['title LIKE ?', "#{search}%"])
	      elsif search_method == "で終わる"
	        # 〜で終わる
	        Book.where(['title LIKE ?', "%#{search}"])
	      end
	    end
	end

	validates :title, presence: true
	validates :body, presence: true, length: { maximum: 200}

end
