require 'json'
class Probability_chain_writer
  
  def self.write(corpus, file)
    File.open(file, 'w') do |f|
      f.write(corpus.to_json)
    end
  end
  
end