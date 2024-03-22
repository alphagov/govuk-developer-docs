RSpec.describe StringToId do
  describe "convert" do
    subject(:c) { StringToId }

    it "removes HTML tags" do
      expect(c.convert("<marquee loop=\"-1\" scrolldelay='50'><b>lol</b></marquee>")).to eq("lol")
    end

    it "removes script elements and their content" do
      expect(c.convert("<script>foo</script>")).to eq("")
    end

    it "removes characters other than ASCII alphanumeric, dot, dash and underscore" do
      expect(c.convert("1!@#%^*()-+=[]{}|\\'\"`~?/,")).to eq("1-")
      expect(c.convert("💩")).to eq("")
    end

    it "removes ampersand, less-than and greater-than" do
      expect(c.convert("><<>&")).to eq("")
    end

    it "preserves entity names that are not part of actual entities" do
      expect(c.convert("ampere")).to eq("ampere")
      expect(c.convert("amp;ere")).to eq("ampere")
      expect(c.convert("felt;-tip-pen")).to eq("felt-tip-pen")
    end

    it "preserves empty string" do
      expect(c.convert("")).to eq("")
    end

    it "preserves lowercase alphanumeric ASCII, underscores and non-consecutive dashes" do
      expect(c.convert("xyz890-123abc_")).to eq("xyz890-123abc_")
    end

    it "converts space and . to -" do
      expect(c.convert("foo.bar baz")).to eq("foo-bar-baz")
    end

    it "converts to lowercase" do
      expect(c.convert("MICROPIGS")).to eq("micropigs")
    end

    it "elides runs of dashes" do
      expect(c.convert("o---o")).to eq("o-o")
      expect(c.convert("o----o")).to eq("o-o")
    end

    it "elides runs of dashes after converting characters to dashes" do
      expect(c.convert("o-...  -o")).to eq("o-o")
    end

    it "does not elide runs of underscores" do
      expect(c.convert("__")).to eq("__")
    end
  end
end
