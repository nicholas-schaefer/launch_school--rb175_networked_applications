require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require "psych"

helpers do
  def comma_separated(text)
    text.join(", ")
  end

  def count_interests(users)
    users.values.map { |user_sub_hash| user_sub_hash[:interests]}.flatten.uniq.length
  end

end

before do
  @title = "Users and Interests"
  @users = Psych.load_file("data/users.yaml")
  @users_count = @users.keys.length
end

get "/" do
  redirect to('/users')
end

get "/users" do

  erb :users
end

get "/users/:name" do
  @user_name =        params[:name]
  return "user not found" unless @users.keys.any?(@user_name.to_sym)

  @user_email =       @users[@user_name.to_sym][:email]
  @user_interests =   @users[@user_name.to_sym][:interests]

  @all_other_users = @users.reject{ |key, _value| key == @user_name.to_sym}

  erb :user
end
