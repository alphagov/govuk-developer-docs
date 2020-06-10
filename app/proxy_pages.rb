class ProxyPages
  def self.resources
    api_docs +
      govuk_schema_names +
      app_docs +
      app_docs_json +
      document_types +
      supertypes
  end

  def self.api_docs
    docs = AppDocs.apps_with_docs.map do |app|
      docs_for_app = GitHubRepoFetcher.client.docs(app.app_name)
      return [] unless docs_for_app.present?

      docs_for_app.map do |page|
        {
          path: page[:path],
          template: "templates/external_doc_template.html",
          frontmatter: {
            title: "#{app.app_name}: #{page[:title]}",
            locals: {
              title: "#{app.app_name}: #{page[:title]}",
              markdown: page[:markdown],
            },
          },
        }
      end
    end

    docs.flatten.compact
  end

  def self.govuk_schema_names
    GovukSchemas::Schema.schema_names.map do |schema_name|
      schema = ContentSchema.new(schema_name)

      {
        path: "/content-schemas/#{schema_name}.html",
        template: "templates/schema_template.html",
        frontmatter: {
          title: "Schema: #{schema.schema_name}",
          content: "",
          locals: {
            title: "Schema: #{schema.schema_name}",
            description: "Everything about the '#{schema.schema_name}' schema",
            schema: schema,
          },
        },
      }
    end
  end

  def self.app_docs
    AppDocs.pages.map do |application|
      {
        path: "/apps/#{application.app_name}.html",
        template: "templates/application_template.html",
        frontmatter: {
          title: application.page_title,
          locals: {
            title: application.page_title,
            description: "Everything about the #{application.app_name} application (#{application.description})",
            application: application,
          },
        },
      }
    end
  end

  def self.app_docs_json
    AppDocs.pages.map do |application|
      {
        path: "/apps/#{application.app_name}.json",
        template: "templates/json_response.json",
        frontmatter: {
          locals: {
            payload: application.api_payload,
          },
        },
      }
    end
  end

  def self.document_types
    DocumentTypes.pages.map do |document_type|
      {
        path: "/document-types/#{document_type.name}.html",
        template: "templates/document_type_template.html",
        frontmatter: {
          title: "Document type: #{document_type.name}",
          content: "",
          locals: {
            title: "Document type: #{document_type.name}",
            description: "Everything about the '#{document_type.name}' document type",
            page: document_type,
          },
        },
      }
    end
  end

  def self.supertypes
    Supertypes.all.map do |supertype|
      {
        path: "/document-types/#{supertype.id}.html",
        template: "templates/supertype_template.html",
        frontmatter: {
          title: "#{supertype.name} supertype",
          content: "",
          locals: {
            title: "#{supertype.name} supertype",
            description: supertype.description,
            supertype: supertype,
          },
        },
      }
    end
  end
end
