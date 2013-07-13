class User < ActiveRecord::Base
  has_many :confessions
  validates :grouphug_id, uniqueness: true
end
