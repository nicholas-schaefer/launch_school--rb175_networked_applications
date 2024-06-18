require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require "psych"

helpers do
  def comma_separated(text)
    text.join(", ")
  end
end

before do
  @users = Psych.load_file("data/users.yaml")
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

  erb :user
end

# get "/chapters/:number" do
#   number = params[:number].to_i
#   chapter_name = @contents[number - 1]

#   redirect "/" unless (1..@contents.size).cover? number

#   @title = "Chapter #{number}: #{chapter_name}"
#   @chapter = File.read("data/chp#{number}.txt")

#   erb :chapter
# end
