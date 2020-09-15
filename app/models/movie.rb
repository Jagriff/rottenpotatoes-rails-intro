class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R', 'NC-17']
  end

  def self.sort_with_ratings(session)
    Movie.where(:rating => session[:ratings].keys).order(session[:sorting])
  end

end
