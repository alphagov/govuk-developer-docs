RSpec.describe AppDiagramGenerator do
  before :all do
    # generate actual diagrams
    dg = AppDiagramGenerator.new
    dg.generate
    @files = Dir.glob("diagrams/*.puml")
    @parsed_diagrams = []
    parse_output
  end

  class ParsedDiagram
    attr_accessor :systems, :containers, :persons, :relationships, :file_path
    def initialize
      @systems = []
      @containers = []
      @persons = []
      @relationships = []
    end
  end

  def parse_output
    @files.each do|file_path|
      parsed_diagram = ParsedDiagram.new
      @parsed_diagrams.push parsed_diagram

      parsed_diagram.file_path = file_path

      File.foreach(file_path).all? do |line|
        line.scan(/\s*System\s*\(([^,]*)/i) do |system_matches|
          parsed_diagram.systems.push system_matches.first
        end

        line.scan(/\s*Container\s*\(([^,]*),/i) do |container_matches|
          parsed_diagram.containers.push container_matches.first
        end

        line.scan(/\s*Person.*\s*\(([^,]*),/i) do |person_matches|
          parsed_diagram.persons.push person_matches.first
        end

        line.scan(/\s*Rel.*\(([^,]*),\s*([^,]*)/i) do |rel_matches|
          parsed_diagram.relationships.push [rel_matches.first, rel_matches.second]
        end
      end
    end
  end

  describe "diagrams" do
    it "exist" do
      expect(@files.count).to be > 0
    end

    it "get updated" do
      expect(File.mtime(@files.first)).to be > Time.current - 1
    end

    it "have systems or containers" do
      @parsed_diagrams.each do |diagram|
        expect(diagram.systems.count + diagram.containers.count).to be > 0
      end
    end

    it "have valid system names" do
      @parsed_diagrams.each do |diagram|
        diagram.systems.each do |s|
          expect(s).to eq s.parameterize.underscore
        end
      end
    end

    it "have valid relationships" do
      @parsed_diagrams.each do |diagram|
        diagram.relationships.each do |rel|
          rel_from = rel[0]
          rel_to = rel[1]
          expect(diagram.systems + diagram.containers).to include(rel_to)
          expect(diagram.systems + diagram.containers + diagram.persons).to include(rel_from)
        end
      end
    end
  end
end
