require_relative 'corpus_parser'

class Markov_Chain
  attr_accessor :corpus, :word, :markov_chain
  
  def initialize(word, corpus)
    @corpus = corpus
    @word = word
    @markov_chain = {}
  end
  
  def make_probability_chain
    corpus.each do |word|
      self.markov_chain[word.to_sym] = []
    end
  end
  
  def populate_chain
    corpus.each_with_index do |word, index|
      self.markov_chain[word.to_sym] << corpus[index + 1]
    end
  end
  
  def calculate_probabilities(ranked_matches, match_pairs_count)
    ranked_matches.each do |match, count|
      # wrapped the count line in parens and then times 100 to get a better percentage
      ranked_matches[match] = (count / match_pairs_count.to_f) * 100
    end
    ranked_matches
  end
  
  def probable_next_words
    match_pairs = markov_chain[word.to_sym]
    ranked_matches = {}
    
    if match_pairs
      match_pairs.each do |match_pair|
        if ranked_matches[match_pair.to_sym]
          ranked_matches[match_pair.to_sym] += 1
        else
          ranked_matches[match_pair.to_sym] = 1
        end
      end
      calculate_probabilities(ranked_matches, match_pairs.length)
    else
      nil
    end
  end
  
end

parser = Parser.new('Romeo-And-Juliet.txt')
parsed = parser.parse
chain = Markov_Chain.new('and', parsed)

chain.make_probability_chain
chain.populate_chain
p chain.probable_next_words
