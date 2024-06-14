toc = ["A Scandal in Bohemia", "The Red-headed League", "A Case of Identity",
"The Boscombe Valley Mystery", "The Five Orange Pips", "The Man with the Twisted Lip",
"The Adventure of the Blue Carbuncle", "The Adventure of the Speckled Band",
"The Adventure of the Engineer's Thumb","The Adventure of the Noble Bachelor",
"The Adventure of the Beryl Coronet","The Adventure of the Copper Beeches"]



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
      number: ch_number.to_s,
      path:   ch_path,
    }
  end

# pp chapter_paths_collection

chapter_titles_collection = toc.map.with_index {|title, idx| [idx + 1, title.chomp]}.to_h

chapter_paths_and_titles_collection =
  (chapter_paths_collection.each_with_object({}) do | (key, sub_hash), new_hash |
    new_hash[key] = sub_hash.merge({title: chapter_titles_collection[key]})
  end)

# pp chapter_paths_and_titles_collection

chapters_collection_filtered =
  (chapter_paths_and_titles_collection.select do |chapter_idx, chapter_values|
    /THE/ =~ File.read(chapter_values[:path])
  end)

  pp chapters_collection_filtered

# {1=>{:number=>"1", :path=>"data/chp1.txt", :title=>"A Scandal in Bohemia"},
#  2=>{:number=>"2", :path=>"data/chp2.txt", :title=>"The Red-headed League"},

# p chapter_paths_unsorted
# p File.read("data/chp1.txt")
