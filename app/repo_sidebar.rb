class RepoSidebar
  Item = Data.define(:path, :title, :children)

  def initialize(repo_name)
    @repo_name = repo_name
  end

  def items
    format_tree(tree)
  end

private

  attr_reader :repo_name

  def format_tree(items)
    items.map do |_, value|
      Item.new(
        value[:path],
        value[:name],
        format_tree(value[:children]),
      )
    end
  end

  def tree
    @tree ||= begin
      tree = {}

      docs_to_import.each do |item|
        path = item[:path].delete_prefix("/repos/#{repo_name}/")
        parts = path.split("/")
        current_level = tree

        parts.each_with_index do |part, index|
          current_level[part] ||= if index == parts.size - 1
                                    # Assign title if available, otherwise use the file name
                                    { name: item[:title] || part, path: item[:path], children: {} }
                                  else
                                    { name: part, path: parts[0..index].join("/"), children: {} }
                                  end
          current_level = current_level[part][:children]
        end
      end

      tree
    end
  end

  def docs_to_import
    @docs_to_import ||= GitHubRepoFetcher.instance.docs(repo_name) || []
  end
end
