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
    @all_ratings = Movie.ratings
    @ratings = params[:ratings].nil? ? Movie.ratings : params[:ratings].keys
    
    @ratings_from_user = params[:ratings] || session[:ratings] || {}
    if @ratings_from_user == {}
      @ratings_from_user = Hash[@all_ratings.map { |rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = params[:sort] || session[:sort]
      session[:ratings] = @ratings_from_user
    
      redirect_to :sort => params[:sort] || session[:sort], :ratings => @ratings_from_user and return
    end
    
    if params[:sort].present?
      @movies = Movie.by_rating_order(@ratings, params[:sort] || session[:sort])
    else 
      @movies = Movie.by_rating_order(@ratings, nil)
    end
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
