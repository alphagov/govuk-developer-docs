class Site
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def as_json
    {
      name: data.fetch("name"),
      url: data.fetch("url"),
      description: data["description"]
    }
  end
end
