require 'punkt-segmenter'
require 'tactful_tokenizer'
require 'treat'

module Splitter
  # RECCOMMENDED
  # Relative average time 0.002076s
  def Splitter.punkt_extract_sentences(text)
    tokenizer = Punkt::SentenceTokenizer.new(text)
    tokenizer.sentences_from_text(text, :output => :sentences_text)
  end

  # WARNING: tactful_tokenizer is massively slower, 250 times slower...
  # Relative average time = 0.495286s
  def Splitter.tactful_extract_sentences(text)
    m = TactfulTokenizer::Model.new
    m.tokenize_text(text)
  end

  # WARNING: Treat is marginally less consistent for very complex texts
  # Relative average time = 0.0249s
  def Splitter.treat_extract_sentences(text)
    Treat::Entities::Paragraph.new(text).segment.to_a
  end
end
