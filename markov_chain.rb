require_relative 'corpus_parser'
require_relative 'probability_chain_writer'
require 'json'

class Markov_Chain
  attr_accessor :corpus, :word, :markov_chain
  
  def initialize(corpus)
    @corpus = Parser.new(corpus).parse
    @markov_chain = {}
  end

  def create_keys(index, n)
    key = corpus[index]
    n.times { |iteration| key += "_#{corpus[index + iteration + 1]}"}
    key
  end
  
  def make_probability_chain(n)
    corpus.length.times do |index|
      # key is reset between words in the corpus
      if corpus[index + n]
        key = create_keys(index, n)
        self.markov_chain[key.to_sym] = []
      end
    end
  end
  
  def populate_chain(n)
    corpus.length.times do |index|
      # key_length.times do |n|
        if corpus[index + n + 1]
          key = create_keys(index, n)
          self.markov_chain[key.to_sym] << corpus[index + n + 1]
        end
      # end
    end
  end
  
  def prune_rankings(ranked_matches)
    ranked_matches.select{ |word, probability| probability > 0.01}
  end
  
  def calculate_probabilities(ranked_matches, match_pairs_count)
    
    ranked_matches.each do |match, count|
      ranked_matches[match] = (count / match_pairs_count.to_f)
    end

    prune_rankings(ranked_matches)
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
  
  def return_probability_chain(length, file)
    make_probability_chain(length)
    populate_chain(length)

    markov_chain.each do |word, probable_words|
      markov_chain[word] = probable_next_words(probable_words)
    end
    
    Probability_chain_writer.write(markov_chain, file)
  end
  
  
end

# Markov_Chain.new('shakespeare-complete-body-of-text.txt').return_probability_chain(1)
start = Time.now
Markov_Chain.new('got-series.txt').return_probability_chain(0, 'markov_chains/game-of-thrones-n-1.json')
puts (Time.now - start)/60