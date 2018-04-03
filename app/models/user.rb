class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :login
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end
  
  has_one :kitchen, dependent: :destroy
  has_many :yoris, dependent: :destroy
  has_many :posts, through: :yoris
  has_many :likes, dependent: :destroy
  has_many :scraps, dependent: :destroy
  
  # follower_follows "names" the Follow join table for accessing through the follower association
  has_many :follower_follows, foreign_key: :followee_id, class_name: "Follow", dependent: :destroy
  # source: :follower matches with the belong_to :follower identification in the Follow model 
  has_many :followers, through: :follower_follows, source: :follower

  # followee_follows "names" the Follow join table for accessing through the followee association
  has_many :followee_follows, foreign_key: :follower_id, class_name: "Follow", dependent: :destroy
  # source: :followee matches with the belong_to :followee identification in the Follow model   
  has_many :followees, through: :followee_follows, source: :followee
end
