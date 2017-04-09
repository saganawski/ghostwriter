require_relative 'corpus_parser'
require_relative 'probability_chain_writer'
require 'json'

class Markov_Chain
  attr_accessor :corpus, :word, :markov_chain
  
  def initialize(corpus)
    @corpus = Parser.new(corpus).parse
    @markov_chain = {}
  end

  def create_keys(key, next_word)
    if key.empty?
      next_word
    else
      "_#{next_word}"
    end
  end
  
  def make_probability_chain(key_length)
    corpus.length.times do |index|
      key = ''
      key_length.times do |n|
        if corpus[index + n]
          key << create_keys(key, corpus[index + n])
          self.markov_chain[key.to_sym] = []
        end
      end
    end
  end
  
  def populate_chain(key_length)
    corpus.each_with_index do |word, index|
      self.markov_chain[word.to_sym] << corpus[index + 1]
    end
  end
  
  def populate_chain_length_2
    corpus.each_with_index do |word, index|
      if corpus[index + 2]
        self.markov_chain["#{word}_#{corpus[index + 1]}".to_sym] << corpus[index + 2]
      end
    end
  end
  
  def calculate_probabilities(ranked_matches, match_pairs_count)
    ranked_matches.each do |match, count|
      ranked_matches[match] = (count / match_pairs_count.to_f)
    end
    ranked_matches.delete_if {|key, probability| probability < 0.003}
    ranked_matches
  end
  
  def probable_next_words(probable_words)
    # array of probable words
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
  
  def return_probability_chain(length)
    if length == 1
      make_probability_chain
      populate_chain
    elsif length == 2
      make_probability_chain_2
      populate_chain_length_2
    end
    markov_chain.each do |word, probable_words|
      markov_chain[word] = probable_next_words(probable_words)
    end
    
    Probability_chain_writer.write(markov_chain)
  end
  
  
end

# Markov_Chain.new('shakespeare-complete-body-of-text.txt').return_probability_chain(1)
Markov_Chain.new('shakespeare-complete-body-of-text.txt').make_probability_chain(3)