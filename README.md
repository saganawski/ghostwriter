# Welcome to Ghostwriter's Parser/Markov Chain Generator 
---

## The Team
- Ken Saganski: [saganawski](https://github.com/saganawski)
- Armando Dollia: [armandodollia](https://github.com/armandodollia)
- Mike Bonetti: [MikeyB303](https://github.com/MikeyB303)

## Purpose
The purpose of this application is to generate Markov chains and their n-grams from a given corpus for use by the [Ghostwriter web-app](https://github.com/MikeyB303/ghostwritr-web)


## Dependencies
To run this web app on your own, it is required that you have ruby installed. For instructions on ruby installation, visit their website [here](https://www.ruby-lang.org/en/)

## Getting Started
1. Clone this repository to your local computer
    
    `$ git clone https://github.com/saganawski/ghostwriter.git`

2. Navigate to the newly cloned repo.
    
    `$ cd wherever-you-cloned-the-repo-to/ghostwriter`

3. Using your favorite text-editor, open the `markov_chain.rb` file and scroll to the bottom. You'll see a line of code that looks like this:

    ```ruby
    MarkovChain.new('text-file-to-be-parsed.txt', 0.24).return_probability_chain(2, 'parsed_file_location/parsed-file-name.json')
    ```

4. Replace the following values:
    * text-file-to-be-parsed.txt -- file name of your corpus
    * 0.24 -- probability floor (this number and all probabilities smaller than it will not be included.)
    * 2 -- The amount of additional words included in the key value (integers only, use 0 for a n = 1 gram)
    * parsed_file_location/parsed-file-name.json -- The desired directory and filename where the markov chain JSON file will be saved

5. Move the JSON files to the `ghostwritr-web/db/seeds/corpus_files/` directory of your Ghostwriter web-app.


## Contributing
If you'd like to contribute to Ghostwriter, simply fork this repo, make your desired changes, and create a pull request for us to review. If all is good, we'll accept your changes!

## License
Ghostwriter is released under the [MIT License](https://opensource.org/licenses/MIT)