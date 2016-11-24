module Utils
  DO_NOT_EDIT = "<!-- This file was automatically generated. DO NOT EDIT DIRECTLY. -->"

  def self.frontmatter(params)
    YAML.dump(params.stringify_keys) + "---\n"
  end

  def self.remove_first_line(string)
    string.lines[2..-1].join
  end

  def self.remove_frontmatter(string)
    string.split('---').last
  end
end
