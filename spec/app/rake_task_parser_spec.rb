RSpec.describe RakeTaskParser do
  describe ".parse" do
    it "returns each described task with its full name, arguments and description" do
      rake_file = <<~'RUBY'
        namespace :reslug do
          desc "Change a person slug.\n

          It republishes the person to Publishing API"
          task :person, %i[old_slug new_slug] => :environment do
          end
        end
      RUBY

      expect(described_class.parse(rake_file)).to eq([
        RakeTaskParser::RakeTask.new(
          name: "reslug:person",
          arg_names: %w[old_slug new_slug],
          description: "Change a person slug.\n\nIt republishes the person to Publishing API",
          line_number: 5,
        ),
      ])
    end

    it "builds the command to run, including nested namespaces" do
      rake_file = <<~RUBY
        namespace :outer do
          namespace :inner do
            desc "With arguments"
            task :with_args, %i[foo bar] => :environment
          end

          desc "Without arguments"
          task without_args: :environment
        end
      RUBY

      expect(described_class.parse(rake_file).map(&:command)).to eq(%w[outer:inner:with_args[foo,bar] outer:without_args])
    end

    it "skips tasks without a plain string description" do
      rake_file = <<~'RUBY'
        task :no_description

        desc "Uses #{SOME_CONSTANT}"
        task :interpolated_description

        desc "Run specs"
        RSpec::Core::RakeTask.new(:spec)
        task :description_belongs_to_the_line_above
      RUBY

      expect(described_class.parse(rake_file)).to eq([])
    end

    it "skips tasks for running tests and linters" do
      rake_file = <<~RUBY
        desc "Run all linters"
        task lint: :environment

        namespace :test do
          desc "Clean up test data"
          task :cleanup
        end

        desc "Republish all political content"
        task :republish_political_content
      RUBY

      expect(described_class.parse(rake_file).map(&:name)).to eq(%w[republish_political_content])
    end

    it "returns no tasks for invalid Ruby" do
      expect(described_class.parse("desc 'Foo'\ntask :bar do")).to eq([])
    end
  end
end
