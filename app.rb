# app.rb < Sinatra::Application

require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/Post'
require './models/Comment'

require 'sinatra/flash'
require 'sinatra/redirect_with_flash'

enable :sessions

# Post Controller

 #index posts
get "/" do
  @posts = Post.order("created_at DESC")
  @title = "Welcome"

  erb :"posts/index"
end

get "/posts" do
  redirect "/"
end
  
 #create posts
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
 
  #view post
get "/posts/:id" do
 @post = Post.find(params[:id])
 @title = @post.title
	
 erb :"posts/view"
end

  #edit posts
get "/posts/:id/edit" do
 @post = Post.find(params[:id])
 @title = "Edit post"
 
 erb :"posts/edit"
end

put "/posts/:id" do
 @post = Post.find(params[:id])
 @post.update(params[:post])

 redirect "/posts/#{@post.id}"	
end
  
 #delete post
get "/posts/:id/destroy" do
 @post = Post.find(params[:id])
	
 erb :"posts/delete"
end

delete "/posts/:id" do
 @post = Post.find(params[:id])
 @post.comments.each do |comment|
	 comment.destroy
 end
 @post.destroy
 
 redirect "/"
end


#Comment Controller

get "/posts/:id/comments/create" do
  @title = "New Comment"
	
  @post = Post.find(params[:id])
  @comment = Comment.new
	
  erb :"posts/view"
end

post "/posts/:id" do
	@post = Post.find(params[:id])
    @post.comments.create(params[:comment])
		
	if @post.save
		redirect "posts/#{@post.id}"
	else
		redirect "posts/#{@post.id}/comments/create", :error => 'Something went wrong, try writing the comment again!'
	end
end

# Helpers

helpers do
  def title
    if @title
      "#{@title}"
    else
      "Welcome"
    end
  end
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end