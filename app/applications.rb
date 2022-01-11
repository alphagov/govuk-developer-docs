class Applications
  def self.all
    @all ||= YAML.load_file("data/applications.yml").map do |app_data|
      App.new(app_data)
    end
  end

  def self.public
    Applications.all.reject(&:private_repo?)
  end

  def self.active
    Applications.all.reject(&:retired?).sort_by(&:app_name)
  end

  def self.app_data
    @app_data ||= AppData.new
  end
end
