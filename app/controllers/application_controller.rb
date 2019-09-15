require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

#renders an index.erb file with links to signup or login
  get "/" do
    erb :index
  end

#renders a form to create a new user. The form includes fields for
#username and password
  get "/signup" do
    erb :signup
  end

#If no username or password, redirects to failure
#Else, creates a username and password and redirects to login
  post "/signup" do
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      User.create(username: params[:username], password: params[:password])
      redirect '/login'
    end
  end

#renders an account.erb page, which should be displayed once a user
#successfully logs in
  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end

#renders a form for logging in
  get "/login" do
    erb :login
  end

#Finds user by username.
#If user name is found AND password matches based on #authenticate method
#then user is redirected to account
#if login faile, then use is redirected to failure page
  post "/login" do
      @user = User.find_by(username: params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect to "/account"
      else
        redirect to "failure"
      end
    end

#renders a failure.erb page. This will be accessed if there is an error
#logging in or signing up
  get "/failure" do
    erb :failure
  end

#clears the session data and redirects to the home page
  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
