require 'sinatra/base'
require 'rack-flash'

class SongsController < ApplicationController
  enable :sessions
  use Rack::Flash
  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all
    erb :'songs/new'
  end
    
  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

  post '/songs' do
    @song = Song.create(:name => params[:song][:name])
    @song.artist = Artist.find_or_create_by(:name => params[:song][:artist])
    
    genre = params[:song][:genres]
    genre.each do |genre|
      @song.genres << Genre.find(genre)
    end
    
    @song.save
    
    flash[:notice] = "Successfully created song."
    redirect "songs/#{@song.slug}"
  end

  get '/songs/:slug' do
    slug = params[:slug]
    @song = Song.find_by_slug(slug)
    erb :"songs/show"
  end

  patch '/songs/:slug' do
    song = Song.find_by_slug(params[:slug])
    song.name = params[:song][:name]
    song.artist = Artist.find_or_create_by(:name => params[:song][:artist])

    genres = params[:song][:genres]
    genres.each do |genre|
      song.genres << Genre.find(genre)
    end

    song.save
    flash[:notice] = "Successfully updated song."
    redirect to "songs/#{song.slug}"
  end

  get '/songs/:slug/edit' do
    slug = params[:slug]
    @song = Song.find_by_slug(slug)
    erb :"songs/edit"
  end



end