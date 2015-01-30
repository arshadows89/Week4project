require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'rack-flash'
require_relative './models'

set :database, "sqlite3:example.sqlite3"
set :sessions, true
use Rack::Flash, sweep: true

def current_user
	if session[:user_id]
		@user = User.find(session[:user_id])
	else
		nil
	end
end

get "/profile/:id" do
  @user = User.find(params[:id])
  erb :profile
end

get '/' do
	@users = User.all
	erb :home
end

get '/home' do
  erb :home
end

get '/profile' do
  @user = current_user if current_user
  erb :profile
end

get '/signin' do
	erb :signin
end

post '/signin' do
  @user = User.where(params[:user]).first
  puts params.inspect
  if @user && @user.password == params[:user][:password]
    flash[:notice] = "You've successfully logged in."
    session[:user_id] = @user.id
    redirect '/'
  else
    flash[:alert] = "No such Username exists. Try again"
    redirect '/signup'
  end
end

get '/signup' do
	erb :signup
end

post '/signup' do
  @user = User.create(fname: params[:user][:fname], lname: params[:user][:lname], email: params[:user][:email], username: params[:user][:username], password: params[:user][:password], Bio: params[:user][:Bio], Interest1: params[:user][:Interest1], Interest2: params[:user][:Interest2], Interest3: params[:user][:Interest3], location: params[:user][:location])
  puts params.inspect
  redirect '/'
end

post '/signout' do
  session[:user_id] = nil
  redirect '/'
end

get '/signout' do
  session[:user_id] = nil
  redirect '/'
end

get '/settings' do
  erb :settings
end


post '/account_delete' do
  previous_account = (session[:user_id])
  session[:user_id] = nil
  User.find(previous_account).destroy
  flash[:deleted_account] = "Your account #{previous_account} has been deleted."
  redirect '/'
end

get '/profile/:id' do
  @user = User.find(params[:id])
  erb :profile
end

post '/post_feed' do
  if params[:user][:feed] != ''
    current_user.posts.create(content: params[:user][:feed])
  end
  redirect '/profile'
end



post '/change_info' do
  if params[:user][:fname] != ''
    current_user.update(fname: params[:user][:fname])
  end
  if params[:user][:lname] != ''
    current_user.update(lname: params[:user][:lname])
  end
  if params[:user][:email] != ''
    current_user.update(email: params[:user][:email])
  end
  if params[:user][:username] != ''
    current_user.update(username: params[:user][:username])
  end
  if params[:user][:password] != ''
    current_user.update(password: params[:user][:password])
  end
  if params[:user][:Bio] != ''
    current_user.update(Bio: params[:user][:Bio])
  end
  if params[:user][:Interest1] != ''
    current_user.update(Interest1: params[:user][:Interest1])
  end
  if params[:user][:Interest2] != ''
    current_user.update(Interest2: params[:user][:Interest2])
  end
  if params[:user][:Interest3] != ''
    current_user.update(Interest3: params[:user][:Interest3])
  end
  if params[:user][:location] != ''
    current_user.update(location: params[:user][:location])
  end
  redirect '/profile'
end

get '/follow/:id' do
  @relationship = Relationship.new(follower_id: current_user.id, followed_id: params[:id])
  if @relationship.save
    flash[:notice] = "You've successfully followed #{User.find(params[:id]).fname}."
  else
    flash[:alert] = "There was an error following that user."
  end
  redirect back
end










