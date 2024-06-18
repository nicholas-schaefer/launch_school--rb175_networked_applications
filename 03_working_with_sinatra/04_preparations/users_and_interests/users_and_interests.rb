require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require "psych"

helpers do
  # def in_list()
  # end
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
 name = params[:name]

 return "user not found" unless @users.keys.any?(name.to_sym)
  "User found!"

end

# get "/chapters/:number" do
#   number = params[:number].to_i
#   chapter_name = @contents[number - 1]

#   redirect "/" unless (1..@contents.size).cover? number

#   @title = "Chapter #{number}: #{chapter_name}"
#   @chapter = File.read("data/chp#{number}.txt")

#   erb :chapter
# end
