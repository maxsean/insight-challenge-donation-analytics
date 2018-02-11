module OutputToText
  def text_writer(hash)
    output = hash.values[0..-2].join('|')
    File.open("./output/repeat_donors.txt", 'a') { |file| file.write(output + "\n") }
  end
end
