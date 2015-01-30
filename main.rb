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


get '/' do
	@users = User.all
	erb :home
end

get '/home' do
  erb :home
end

get '/profile' do
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

get '/settings'
  erb :settings
end
