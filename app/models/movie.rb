class Movie < ActiveRecord::Base
  
  def self.get_all_ratings
    ratings = []
    self.group(:rating).each { |p| ratings << p.rating }
    ratings
  end
  
end
