class Club < ActiveRecord::Base
  attr_accessible :location, :name, :president_id

  belongs_to :president, :class_name => "User"
  has_many :members, :class_name => "User", :foreign_key => :club_id
end
