require 'yaml'

require_relative './github'
require_relative './section'

class Content
  def as_json
    {
      applications: {
        name: 'Applications & development',
        columns: generate_data("applications.yml")
      },
      operations: {
        name: 'Operations',
        columns: generate_data("operations.yml")
      },
    }
  end

private

  def generate_data(file_name)
    YAML.load_file("_content/#{file_name}").map do |column|
      Column.new(column, github).as_json
    end
  end

  class Column
    attr_reader :column, :github

    def initialize(column, github)
      @column, @github = column, github
    end

    def as_json
      {
        name: column.fetch('name'),
        sections: column['sections'].map { |section| Section.new(section, github).as_json }
      }
    end
  end

  def github
    @github ||= GitHub.new
  end
end
