# app.rb

require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/Post'

require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions

# Post Controller

get "/" do
  @posts = Post.order("created_at DESC")
  @title = "Welcome"

  erb :"posts/index"
end

get "/posts/create" do
 @title = "Create post"
 @post = Post.new
 erb :"posts/create"
end

post "/posts" do
 @post = Post.new(params[:post])
 if @post.save
   redirect "posts/#{@post.id}"
 else
   redirect "posts/create", :error => 'Something went wrong, try writing the post again!'
 end
end

get "/posts/:id" do
 @post = Post.find(params[:id])
 @title = @post.title
 erb :"posts/view"
end

# Helpers

helpers do
  def title
    if @title
      "#{@title}"
    else
      "Welcome."
    end
  end
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end






