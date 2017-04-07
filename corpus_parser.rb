require 'csv'

class Parser
	attr_reader :parsed_filtered_array

	def initialize(file)
		@corpus = file
		@parsed_filtered_array = []
	end

	def parse
		parsed_text = []
		parsed = CSV.foreach(@corpus) do |row|
			# check for empty arrays
			if row != []
				row.to_s.split(' ').each do |line|
					parsed_text << line
				end
			end
		end
		filtered_array = text_punctuation_filter(parsed_text)
		text_space_filter(filtered_array)
	end

	# filter out unwanted characters
	def text_punctuation_filter(parsed_text)
		filtered_array = []

		parsed_text.each do |text|
			 filtered_array << text.gsub(/\W/, "").downcase
		end
		filtered_array
	end

	# filter out empty strings
	def text_space_filter(filtered_array)
		@parsed_filtered_array = filtered_array.reject { |word|  word == '' || word == 'nil'}
	end

end

