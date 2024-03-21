require "sanitize"

class StringToId
  def self.convert(string)
    Sanitize.fragment(string)
      .downcase
      .gsub(/&(amp|gt|lt);/, "")
      .tr(" .", "-")
      .tr("^a-z0-9_-", "")
      .gsub(/--+/, "-")
  end
end
