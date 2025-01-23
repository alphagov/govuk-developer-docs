class ProxyPages
  def self.resources
    repo_docs +
      govuk_schema_names +
      repo_overviews +
      repo_overviews_json +
      document_types +
      supertypes
  end

  def self.repo_docs
    docs = Repos.with_docs.map do |repo|
      docs_for_repo = GitHubRepoFetcher.instance.docs(repo.repo_name) || []
      docs_for_repo.map do |page|
        {
          path: page[:path],
          template: "templates/external_doc_template.html",
          frontmatter: {
            title: "#{repo.repo_name}: #{page[:title]}",
            locals: {
              title: "#{repo.repo_name}: #{page[:title]}",
              markdown: page[:markdown],
              repo:,
              relative_path: page[:relative_path],
            },
            data: {
              repo_name: repo.repo_name,
              source_url: page[:source_url],
              latest_commit: page[:latest_commit],
            },
          },
        }
      end
    end

    docs.flatten.compact
  end

  def self.govuk_schema_names
    SchemaNames.all.map do |schema_name|
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
            schema:,
          },
        },
      }
    end
  end

  def self.repo_overviews
    Repos.all.map do |repo|
      {
        path: "/repos/#{repo.app_name}.html",
        template: "templates/repo_template.html",
        frontmatter: {
          title: repo.page_title,
          locals: {
            title: repo.page_title,
            description: "Everything about #{repo.app_name} (#{repo.description})",
            repo:,
          },
        },
      }
    end
  end

  def self.repo_overviews_json
    Repos.all.map do |repo|
      {
        path: "/repos/#{repo.repo_name}.json",
        template: "templates/json_response.json",
        frontmatter: {
          locals: {
            payload: repo.api_payload,
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
            supertype:,
          },
        },
      }
    end
  end
end
