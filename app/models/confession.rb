class Confession < ActiveRecord::Base
  belongs_to :user
  validates :signature, uniqueness: true
  
end
