require_relative "./find_repeat_donors_recipients"

include FindRecipients
# change below to specify input and output filepaths
itcont_path = "./input/itcont.txt"
percentile_path = "./input/percentile.txt"
output_path = "./output/repeat_donors.txt"

File.open(output_path, 'w') {|file| file.truncate(0) } # wipes current output file, comment out if undesired

gather_recipient_data(itcont_path, percentile_path, output_path)
