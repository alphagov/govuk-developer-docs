rule "MY001", "No parentheses allowed after shortcut reference link (use collapsed reference link instead, e.g. `[foo]` => `[foo][]`)" do
  aliases "no-parentheses-after-shortcut-reference-link"
  check do |doc|
    # matches `[foo] (bar)`, doesn't match `[foo][baz] (bar)`
    doc.matching_lines(/ \[[^\]]+\] \(/)
  end
end
