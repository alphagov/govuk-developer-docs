require "bowler"
require "active_support/all"

class BowlerGraph
  def generate
    path = File.expand_path("./../development/Pinfile")
    dep_tree = Bowler::DependencyTree.load(path)
    tree = dep_tree.instance_variable_get('@definition').tree

    nodes = []
    links = []
    valid_app_names = {}

    tree.each_with_index do |(app_name, dependent_apps), i|
      app_name = app_name.to_s

      valid_app_names[app_name.to_s] = i
      nodes << { name: app_name, group: i }
    end

    tree.each do |app_name, dependent_apps|
      source_id = valid_app_names[app_name.to_s]
      next unless source_id

      dependent_apps.each do |dependent_app_name|
        target_id = valid_app_names[dependent_app_name.to_s]
        next unless target_id
        links << { source: source_id, target: target_id, weight: 1 }
      end
    end

    json = JSON.pretty_generate(nodes: nodes, links: links)
    File.write('assets/data/apps-dependencies.json', json)
  end
end
