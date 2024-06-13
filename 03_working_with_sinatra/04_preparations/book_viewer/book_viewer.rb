require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")
  @public_file_local_paths = Dir["public/*"].reject{ |file| File.directory?(file) }
  @public_files = @public_file_local_paths.map{ |file| File.basename(file) }

  @public_files.reverse! if params['sort']

  erb :home
end

get "/chapters/:number" do
  @contents = File.readlines("data/toc.txt")

  number = params[:number].to_i
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"

  # this will throw error for page not fount
  @chapter = File.read("data/chp#{number}.txt")
  # @chapter = File.exist?("data/chp#{number}.txt") ? File.read("data/chp#{number}.txt") : ""


  erb :chapter
end


# get "/chapters/1" do
#   @title = "Chapter 1"
#   @contents = File.readlines("data/toc.txt")
#   @chapter = File.read("data/chp1.txt").split("\n\n").map{ |paragraph| paragraph.gsub("\n", " ") }

#   erb :chapter
# end
