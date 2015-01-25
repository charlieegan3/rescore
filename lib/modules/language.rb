module Language
  def Language.check_language(text)
    return text.language.to_s == "english"
  end
end
