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
	erb :index
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
  @user = User.create(fname: params[:user][:fname], lname: params[:user][:lname], email: params[:user][:email], accountname: params[:user][:accountname], password: params[:user][:password])
  puts params.inspect
  # # if params[:user][:password] != nil && (for each one)
  #   user_fname = params[:user][:fname]
  #   user_lname = params[:user][:lname]
  #   user_email = params[:user][:email]
  #   user_accountname = params[:user][:accountname]
  #   user_password = params[:user][:password]

  #   flash[:signin] = "Sign in with your new created account."
  #   redirect '/signin'
  # else
  # 	# user doesnt fill out all the forms
  # end
end



# 2.1.2 :012 >   params
#  => {"user"=>{"fname"=>"Cameron", "lname"=>"Snyder", "email"=>"arshadows89", "accountname"=>"asdasd", "password"=>"qwerty123"}} 
# 2.1.2 :013 > params["user"]["email"]
#  => "arshadows89" 
# 2.1.2 :014 > params["user"]["password"]
#  => "qwerty123" 
# 2.1.2 :015 > params["user"]
#  => {"fname"=>"Cameron", "lname"=>"Snyder", "email"=>"arshadows89", "accountname"=>"asdasd", "password"=>"qwerty123"} 


#  sp params user might be able to write  a new user..., check new slide for info....