require 'json'
class Probability_chain_writer
  
  def self.write(corpus)
    File.open('shakespeare-probability-chain_test.json', 'w') do |f|
      f.write(corpus.to_json)
    end
  end
  
end