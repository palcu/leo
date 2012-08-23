class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :club_id, :provider, :uid, :fb_token, :birthday, :bio, :profile_photo, :cover_photo
  
  has_one :club, :foreign_key => :president_id
  belongs_to :club


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    User.where(:provider => auth.provider, :uid => auth.uid).first
  end

  def get_facebook_graph
    Koala::Facebook::API.new(self.fb_token)
  end

  def update_from_facebook
    graph = self.get_facebook_graph

    # Update basic info
    profile = graph.get_object("me")
    self.name = profile['name']
    self.email = profile['email']
    self.birthday = profile['birthday']
    self.bio = profile['bio']

    # Update photos
    albums = graph.get_object('me/albums')
    new_profile = nil
    new_cover = nil
    albums.each do |album|
      break if new_profile and new_cover
      if album['name'] == "Cover Photos"
        new_cover = album['cover_photo']
      elsif album['name'] == 'Profile Pictures'
        new_profile = album['cover_photo']
      end
    end

    if new_profile
      photo = graph.get_object(new_profile)
      self.profile_photo = photo['images'][0]['source']
    end

    if new_cover
      photo = graph.get_object(new_cover)
      self.cover_photo = photo['images'][0]['source']
    end

    self.save
  end

end
