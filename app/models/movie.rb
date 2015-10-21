class Movie < ActiveRecord::Base
    def self.ratings
        ['G','PG','PG-13','R']
    end
    
    def self.by_rating_order(rating, sort)
        case sort
            when nil
                Movie.where('rating IN (?)', rating)
            when 'title' then
                Movie.where('rating IN (?)', rating).order('title')
            when 'release_date' then
                Movie.where('rating IN (?)', rating).order('release_date')
        end
    end
end
