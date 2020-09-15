class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # on redirect, display using session
    if (params[:redirect])
      @sorting = session[:sorting]
      @checked_ratings = session[:ratings]
      @movies = Movie.sort_with_ratings(session)
      return
    end

    # if first time viewing page, fill session with no rating filters
    if (!session[:ratings])
      session[:ratings] = Hash.new
      Movie.all_ratings.each do |rating|
        session[:ratings][rating] = 1
      end
    end

    # if a column was just set to be sorted on, then update session
    session[:sorting] = params[:sorting] if params[:sorting]

    # if we have new filters that are non-empty, then update session
    session[:ratings] = params[:ratings] if params[:commit] && params[:ratings]

    # redirect to get appropriate URI
    flash.keep
    redirect_to movies_path :sorting => session[:sorting], :commit => 1, 
                            :ratings => session[:ratings], :redirect => 1
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
