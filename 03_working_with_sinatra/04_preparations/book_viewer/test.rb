query_string = "Sherlock Holmes"

chapter_paragraphs =
  File.read("data/chp1.txt")
  .split("\n\n")
  .map{ |paragraph| paragraph.gsub("\n", " ")}

# puts chapter_paragraphs

matched_paragraphs = (chapter_paragraphs.filter_map do |paragraph|
  if Regexp.new(query_string) =~ paragraph
    paragraph.gsub(query_string, "<strong>#{query_string}</strong>")
  end
end)

puts matched_paragraphs


