# require 'yaml'

# class AppDependencyGenerator
#   def initialize
#     @repository_path = Dir.getwd
#     @application_data_load_path = File.join(@repository_path, "data/applications.yml")
#     @application_data_save_path = File.join(@repository_path, "data/applications2.yml")

#     @all_applications = YAML.load_file(@application_data_load_path)
#     @active_applications =
#       @all_applications.reject { |a| a.fetch("retired", false) }
#       .to_h { |a| [a["github_repo_name"], a] }

#     @app_name_by_label = {
#       "whitehall-admin" => "whitehall",
#       "search" => "search-api",
#       "rummager" => "search-api",
#       "content-data" => "content-data-api",
#       "www-origin" => "router",
#       "assets-origin" => "asset-manager",
#       "draft-content-store" => "content-store",
#       "draft-origin" => "router",
#       "draft-assets" => "asset-manager",
#     }

#     @plek_ref_count = 0
#   end

#   def is_active_app(app_name)
#     @active_applications.key? app_name
#   end

#   def update_app_dependencies folder_path, yaml_app
#     app_name = yaml_app["github_repo_name"]
#     dependencies = yaml_app["dependencies"]
#     if dependencies.nil?
#       dependencies = {}
#       yaml_app["dependencies"] = dependencies
#     end

#     # scan for plek references that match regex
#     Dir.glob(File.join(folder_path, "**/*.rb")).each do|file_path|
#       next if file_path.include? "spec/"
#       next if file_path.include? "test/"

#       File.foreach(file_path).all? do |l|
#         l.scan(/(?<=plek).*\(\s*['"]([0-9a-zA-Z_-]*)['"]/i) do |matches|
#           matches.each do |app_label|
#             next if app_label.empty?

#             dep_app_name = @app_name_by_label[app_label]
#             if dep_app_name.nil?
#               dep_app_name = app_label
#             end

#             next if dependencies.key? dep_app_name

#             if is_active_app(dep_app_name)
#               dependencies[dep_app_name] = {
#                 #"protocol" => "HTTPS",
#                 "description" => "",
#               }
#             else
#               puts "Warning: #{app_name} has a plek reference to #{dep_app_name} which is not a known and active app"
#             end

#             @plek_ref_count = @plek_ref_count + 1
#             # useful for debugging
#             # puts "#{appName}  #{dep}  #{l}"
#           end
#         end
#       end
#     end
#   end

#   def update_all_app_dependencies
#     govuk_projects_path = File.join(@repository_path, "../")
#     @plek_ref_count = 0

#     #iterate folders assuming each folder is an app
#     Dir.glob(File.join(govuk_projects_path, "*/")).each do |folder_path|
#       app_name = File.basename(folder_path) #folder may be an app
#       yaml_app = @active_applications[app_name]

#       if yaml_app.nil?
#         puts "Skipping #{app_name} - not an active app as per applications.yml"
#       else
#         update_app_dependencies folder_path, yaml_app
#       end
#     end

#     puts "Saving application data to #{@application_data_save_path}"
#     File.write(@application_data_save_path, @all_applications.to_yaml)

#     puts "Plek match plekRefCount: #{@plek_ref_count}"
#   end
# end

# g = AppDependencyGenerator.new
# g.update_all_app_dependencies
