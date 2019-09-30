class Supertypes
  def self.all
    @all ||= begin
      data = HTTP.get_yaml("https://raw.githubusercontent.com/alphagov/govuk_document_types/master/data/supertypes.yml")
      data.map { |id, config| Supertype.new(id, config) }
    end
  end

  class Supertype
    attr_reader :id, :name, :description, :default, :items

    def initialize(id, config)
      @id = id
      @name = config.fetch("name")
      @description = config.fetch("description")
      @default = config.fetch("default")
      @items = config.fetch("items")
    end

    def for_document_type(document_type)
      document_type_item = items.find { |item| item.fetch("document_types").include?(document_type) }
      document_type_item ? document_type_item["id"] : default
    end
  end
end
