class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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

  validates :name, presence: true, length: { minimum: 2, maximum: 20}
  validates :introduction, length: { maximum: 50}
end
