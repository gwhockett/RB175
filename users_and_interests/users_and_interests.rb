require 'yaml'
require 'sinatra'
require 'sinatra/reloader'
require "tilt/erubi"

def add_user(name, email, interests)
  users = YAML.load_file('users.yaml')
  users[name]= {
                  :email=>email,
                  :interests=>interests
                  }

  File.open('users.yaml', 'w') do |file|
    file.write(YAML.dump(users))
  end
end

# add_user(:george, "gwhockett@gmail.com", ["cycling", "psychology", "movies"])

before do
  @title = "Users and Interests"
  @users = YAML.load_file('users.yaml')
end

def number_of_interests
  total = 0
  @users.values.each do |info|
    total += info[:interests].count
  end

  total
end

helpers do
  def current_user(user)
    @users[user.to_sym]
  end

  def other_users(user)
    @users.reject {|key,_| key == user.to_sym }
  end

  def count_interests
    "There are #{@users.keys.count} users with a total of #{number_of_interests} interests."
  end
end

get "/" do
  erb :home
end

get "/users/:user" do
  @user = params[:user]

  erb :user
end

not_found do
  redirect "/"
end
