require_relative 'corpus_parser'
require_relative 'probability_chain_writer'
require 'json'

class Markov_Chain
  attr_accessor :corpus, :word, :markov_chain
  
  def initialize(corpus)
    @corpus = Parser.new(corpus).parse
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
  
  def probable_next_words(probable_words)
    match_pairs = probable_words
    ranked_matches = {}
    
    if match_pairs
      match_pairs.each do |match_pair|
        if ranked_matches[match_pair.to_s.to_sym]
          ranked_matches[match_pair.to_s.to_sym] += 1
        else
          ranked_matches[match_pair.to_s.to_sym] = 1
        end
      end
      calculate_probabilities(ranked_matches, match_pairs.length)
    else
      nil
    end
  end
  
  def return_probability_chain
    make_probability_chain
    populate_chain
    markov_chain.each do |word, probable_words|
      markov_chain[word] = probable_next_words(probable_words)
    end
    
    Probability_chain_writer.write(markov_chain)
  end
  
end

Markov_Chain.new('shakespeare-complete-body-of-text.txt').return_probability_chain