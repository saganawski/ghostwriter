class Markov_Chain
  attr_accessor :corpus, :word, :markov_chain
  
  def initialize(word)
    @corpus = %w(hello this is a test of my ability to type in random words that have very little connection to each
                other please ignore this nonsense because all these words have very little meaning
                in my corpus christi of the best thing that ever happened to my life is the green potato that scales the
                sears tower at night and that has a test of my ability to see all the things in their best possible
                form with none of the random crap i am typing in at the moment because chickens are green)
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
      ranked_matches[match] = count / match_pairs_count.to_f
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


chain = Markov_Chain.new('my')

chain.make_probability_chain
chain.populate_chain
p chain.probable_next_words
