class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  attachment :profile_image

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :favorites, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship",
  foreign_key: "follower_id" , dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
  foreign_key: "following_id" , dependent: :destroy

  has_many :following, through: :active_relationships, source: 
  :following
  has_many :followers, through: :passive_relationships, source: 
  :follower

  has_many :search_histories, dependent: :destroy

  has_many :user_rooms
  has_many :messages
  has_many :rooms, through: :user_rooms



  # ユーザをフォローする
  def follow(other_user)
  	following << other_user
  end

  # ユーザをフォロー解除する
  def unfollow(other_user)
  	active_relationships.find_by(following_id: other_user.id).destroy
  end

  # 現在のユーザがフォローしてたらtrueを返す
  def following?(other_user)
  	following.include?(other_user)
  end

  def self.search(model,search_method,search)
    if model == "user"
      if search_method == "完全一致"
          # 〜に完全に一致する
          User.where(['name LIKE ?', "#{search}"])
        elsif search_method == "を含む"
          # 〜を含む
          User.where(['name LIKE ?', "%#{search}%"])
        elsif search_method == "から始まる"
          # 〜から始まる
          User.where(['name LIKE ?', "#{search}%"])
        elsif search_method == "で終わる"
          # 〜で終わる
          User.where(['name LIKE ?', "%#{search}"])
        end
    end
  end

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.new(
        uid: auth.uid,
        provider: auth.provider,
        name: auth.info.name,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
      )
      user.save(:validate => false)
    end
    user
  end

  validates :name, presence: true, length: { minimum: 2, maximum: 20}
  validates :introduction, length: { maximum: 50}
# 住所自動入力
  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
end
