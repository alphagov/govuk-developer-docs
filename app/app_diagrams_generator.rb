require 'yaml'
require 'fileutils'
require 'active_support/all'

class AppDiagramGenerator
  def initialize
    repository_path = Dir.getwd
    @application_data_load_path = File.join(repository_path, "data/applications.yml")
    @application_diagrams_save_path = File.join(repository_path, "diagrams/")

    @applications =
      YAML.load_file(@application_data_load_path)
        .reject { |a| a.fetch("retired", false) }

    @applications_by_type =
      @applications
      .sort_by { |a| a["github_repo_name"] }
      .group_by { |a| a["type"] }

    @application_type =
      Hash[@applications.collect { |a| [a["github_repo_name"], a["type"]] }]

    @actors_by_application_type =
      @applications_by_type
      .map { |type, apps|
        [
          type,
          apps.map { |app| app["actors"] }
          .flatten
          .reject(&:nil?)
          .uniq
        ]
      }.to_h
  end

  def get_valid_alias(title)
    title.parameterize.underscore
  end

  def add_system_actors(file)
    actors = @actors_by_application_type.values.flatten.uniq

    file.puts "skinparam rectangle {"
    file.puts "  borderColor transparent"
    file.puts "}"
    file.puts "rectangle Users {"
    actors.each do |actor|
      actor_alias = get_valid_alias(actor)
      file.puts "Person_Ext(#{actor_alias}, \"#{actor}\", \"\")"
    end
    file.puts "}"

    @actors_by_application_type.keys.each do |key|
      app_type_actors = @actors_by_application_type[key]
      app_type_alias = get_valid_alias(key)

      app_type_actors.each do |actor|
        actor_alias = get_valid_alias(actor)
        file.puts "Rel_Down(#{actor_alias}, #{app_type_alias}, \" \")"
      end
    end
  end

  def generate_system_context_diagram
    file_path = File.join(@application_diagrams_save_path, "context.puml")
    puts "generating #{file_path}"

    File.open(file_path, "w") do |file|
      file.puts "@startuml C4_GOVUK_System_Context"
      file.puts "!includeurl https://raw.githubusercontent.com/RicardoNiepel/C4-PlantUML/master/C4_Context.puml"
      file.puts ""

      @applications_by_type.keys.each do |key|
        system_alias = get_valid_alias(key)
        system_label = key
        file.puts "System(#{system_alias}, \"#{system_label}\", \"Optional Description\")"
      end

      @system_dependencies.keys.each do |key|
        system_alias = get_valid_alias(key)
        dependencies = @system_dependencies[key]
        dependencies.each do |dep|
          system_dep_alias = get_valid_alias(dep)

          if key.downcase.include? "api"
            #helps to push API's down on the diagram
            file.puts "Rel_Up(#{system_alias}, #{system_dep_alias}, \" \")"
          else
            file.puts "Rel_Down(#{system_alias}, #{system_dep_alias}, \" \")"
          end
        end
      end

      add_system_actors(file)

      file.puts ""
      file.puts "@enduml"
    end
  end

  def init_system_dependencies
    @system_dependencies = {}
    @app_system_dependencies = {}

    @applications_by_type.keys.each do |key|
      system_dependencies = []
      system_apps = @applications_by_type[key]

      system_apps.each do |app|
        app_name = app["github_repo_name"]
        app_system_dependencies = []

        app_dependencies = app["dependencies"]
        next if app_dependencies.nil?

        app_dependencies.keys.each do |dep_app|
          dep_app_type = @application_type[dep_app]

          if dep_app_type != key
            system_dependencies.push dep_app_type unless system_dependencies.include? dep_app_type
            app_system_dependencies.push dep_app_type unless app_system_dependencies.include? dep_app_type
            #puts "#{key}:#{app_name} -> #{dep_app_type}:#{dep_app}"
          end
        end

        @app_system_dependencies[app_name] = app_system_dependencies
      end

      @system_dependencies[key] = system_dependencies
    end
  end

  def add_dep_systems(file, app_system)
    # add all systems this system depends on
    system_dependencies = @system_dependencies[app_system]
    if not system_dependencies.nil?
      system_dependencies.each do |dep_system|
        dep_system_alias = get_valid_alias(dep_system)
        file.puts "System(#{dep_system_alias}, \"#{dep_system}\", \"Optional Description\")"
      end
    end
  end

  def add_system_actors_for(file, app_system)
    app_type_actors = @actors_by_application_type[app_system]
    if not app_type_actors.nil?
      app_type_actors.each do |actor|
        actor_alias = get_valid_alias(actor)
        file.puts "Person_Ext(#{actor_alias}, \"#{actor}\", \"\")"
      end
    end
  end

  def add_app_relationships(file, app)
    app_name = app["github_repo_name"]
    app_alias = get_valid_alias(app_name)

    app_system_dependencies = @app_system_dependencies[app_name]
    if not app_system_dependencies.nil?
      app_system_dependencies.each do |system_dep|
        system_dep_alias = get_valid_alias(system_dep)
        file.puts "Rel_Up(#{app_alias}, #{system_dep_alias}, \" \")"
      end
    end

    app_actors = app["actors"]
    if not app_actors.nil?
      app_actors.each do |actor|
        actor_alias = get_valid_alias(actor)
        file.puts "Rel_Down(#{actor_alias}, #{app_alias}, \" \")"
      end
    end
  end

  def generate_container_diagram(app_system)
    system_alias = get_valid_alias(app_system)
    file_path = File.join(@application_diagrams_save_path, "#{system_alias}.puml")
    puts "generating #{file_path}"

    system_apps = @applications_by_type[app_system]

    # add apps within the system boundary
    File.open(file_path, "w") do |file|
      file.puts "@startuml C4_GOVUK_Container_#{system_alias}"
      file.puts "!includeurl https://raw.githubusercontent.com/RicardoNiepel/C4-PlantUML/release/1-0/C4_Container.puml"
      file.puts ""
      file.puts "System_Boundary(#{system_alias}, \"#{app_system}\"){"
      system_apps.each do |app|
        app_name = app["github_repo_name"]
        app_alias = get_valid_alias(app_name)
        file.puts "Container(#{app_alias}, \"#{app_name}\", \"optional technology\", \"\")"
        # example ContainerDb(rel_db, "Relational Database", "MySQL 5.5.x", "Stores people, tribes, tribe membership, talks, events, jobs, badges, GitHub repos, etc.")
      end
      file.puts "}"

      add_dep_systems file, app_system
      add_system_actors_for file, app_system
      system_apps.each do |app|
        add_app_relationships file, app
      end

      file.puts ""
      file.puts "@enduml"
    end
  end

  def generate
    FileUtils.mkdir_p @application_diagrams_save_path

    init_system_dependencies
    generate_system_context_diagram

    @applications_by_type.keys.each do |key|
      generate_container_diagram(key)
    end
  end
end
