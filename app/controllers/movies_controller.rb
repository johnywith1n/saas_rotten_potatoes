class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:sort] != nil
      session[:sort] = params[:sort]
    elsif params[:sort] == nil and session[:sort] != nil
      params[:sort] = session[:sort]
      @do_redirect = true
    end
    if params["ratings"] != nil
      session["ratings"] = params["ratings"]
    elsif params["ratings"] == nil and session["ratings"] != nil
      params["ratings"] = session["ratings"]
      @do_redirect = true
    end
    
    if @do_redirect
      flash.keep
      redirect_to movies_path(params)
    end
      
    @all_ratings = Movie.get_all_ratings
    @title_link_class = ""
    @release_date_link_class = ""
    @selected_ratings = params["ratings"] == nil ? @all_ratings : params["ratings"].keys
    if params[:sort] == nil
      @movies = Movie.where("rating IN (?)", @selected_ratings).all
    else
      @movies = Movie.where("rating IN (?)", @selected_ratings).order("#{params[:sort]} ASC").all
      self.instance_variable_set("@#{params[:sort]}_link_class", "hilite")
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
