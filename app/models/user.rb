class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :club_id, :provider, :uid
  
  has_one :club, :foreign_key => :president_id
  belongs_to :club


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    User.where(:provider => auth.provider, :uid => auth.uid).first
  end

end
