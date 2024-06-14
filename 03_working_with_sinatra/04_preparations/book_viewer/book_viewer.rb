require "sinatra"
require "sinatra/reloader"
require 'pry'

helpers do
  def in_paragraphs(text)
    text
    .split("\n\n")
    .map{ |paragraph| paragraph.gsub("\n", " ")
    .prepend("<p>").concat("</p>") }
    .join()
  end
end

before do
  @contents = File.readlines("data/toc.txt")

  @public_file_local_paths = Dir["public/*"].reject{ |file| File.directory?(file) }
  @public_files = @public_file_local_paths.map{ |file| File.basename(file) }

  chapter_paths_sorted =
    (Dir["data/*"].each.with_object({}) do |file_path_with_extension, hash|
      file_path = File.basename(file_path_with_extension, ".*")
      if file_path[0, 3] == "chp"
        chapter_number = file_path.delete("chp").to_i
        hash[chapter_number] = file_path_with_extension
        # p [chapter_number, file_path_with_extension]
      end
    end).sort.to_h

  chapter_paths_collection =
    chapter_paths_sorted.each_with_object({}) do | (ch_number, ch_path), hash |
      hash[ch_number] = {
        number:         ch_number.to_s,
        path:           ch_path
      }
    end

  chapter_titles_collection = @contents.map.with_index {|title, idx| [idx + 1, title.chomp]}.to_h

  @chapter_paths_and_titles_collection =
    (chapter_paths_collection.each_with_object({}) do | (key, sub_hash), new_hash |
      new_hash[key] = sub_hash.merge({title: chapter_titles_collection[key]})
    end)

end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  # @public_file_local_paths = Dir["public/*"].reject{ |file| File.directory?(file) }
  # @public_files = @public_file_local_paths.map{ |file| File.basename(file) }

  @public_files.reverse! if params['sort']

  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  redirect "/" unless (1..@contents.size).cover? number

  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/search" do

  @chapters_collection_filtered = {}

  if params[:query]
    @query = params[:query] || ""
    @query = @query.gsub(/[^0-9a-z ]/i, '')

    @chapters_collection_filtered =
      (@chapter_paths_and_titles_collection.select do |chapter_idx, chapter_values|
        Regexp.new(@query) =~ File.read(chapter_values[:path])
      end)

    @user_query_msg =
      @chapters_collection_filtered.empty? ? "Sorry, no matches were found" : "Results for '#{@query}'"
  # @user_query_msg = "Results for"
  # Results for <%= "'#{@query}'" %>
    # binding.pry
  end

  erb :search
end


not_found do
  redirect "/"
end
