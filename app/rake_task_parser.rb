require "prism"

# Reads the source of a `.rake` file and returns the tasks that have a `desc`,
# in the same way that `rake -T` only lists described tasks.
class RakeTaskParser
  # Tasks for running tests and linters, which nobody runs on a live app.
  DEVELOPMENT_TASK_NAMESPACES = %w[cucumber factorybot jasmine lint spec test].freeze

  RakeTask = Data.define(:name, :arg_names, :description, :line_number) do
    def command
      arg_names.any? ? "#{name}[#{arg_names.join(',')}]" : name
    end
  end

  def self.parse(rake_file_source)
    parse_result = Prism.parse(rake_file_source)
    return [] if parse_result.failure?

    rake_file_visitor = RakeFileVisitor.new
    parse_result.value.accept(rake_file_visitor)
    rake_file_visitor.tasks
  end

  class RakeFileVisitor < Prism::Visitor
    attr_reader :tasks

    def initialize
      @tasks = []
      @namespace_names = []
      @pending_description = nil
      super
    end

    def visit_call_node(method_call)
      case rake_method_name(method_call)
      when :desc
        @pending_description = literal_text(first_argument_of(method_call))
      when :namespace
        @namespace_names.push(literal_text(first_argument_of(method_call)))
        super
        @namespace_names.pop
      when :task
        record_task(method_call)
      else
        @pending_description = nil
        super
      end
    end

  private

    def rake_method_name(method_call)
      method_call.name if method_call.receiver.nil?
    end

    def record_task(task_call)
      description = @pending_description
      @pending_description = nil # each `desc` describes one task only
      task_name, arg_names = task_name_and_arg_names(task_call)
      return if description.blank? || task_name.blank?

      full_name = (@namespace_names + [task_name]).join(":")
      return if DEVELOPMENT_TASK_NAMESPACES.include?(full_name.split(":").first)

      @tasks << RakeTask.new(
        name: full_name,
        arg_names:,
        description: tidy_description(description),
        line_number: task_call.location.start_line, # used to link to the exact line on GitHub
      )
    end

    def task_name_and_arg_names(task_call)
      first_argument, second_argument = task_call.arguments&.arguments

      if first_argument.is_a?(Prism::KeywordHashNode)
        [literal_text(first_key_of(first_argument)), []]
      else
        [literal_text(first_argument), arg_names_from(first_key_of(second_argument))]
      end
    end

    def arg_names_from(arg_names_list)
      return [] unless arg_names_list.is_a?(Prism::ArrayNode)

      arg_names_list.elements.map { |arg_name| literal_text(arg_name) }
    end

    def first_key_of(hash)
      hash.elements.first.try(:key) if hash.is_a?(Prism::KeywordHashNode)
    end

    def first_argument_of(method_call)
      method_call.arguments&.arguments&.first
    end

    def literal_text(literal)
      literal.unescaped if literal.is_a?(Prism::StringNode) || literal.is_a?(Prism::SymbolNode)
    end

    # Long descriptions are often written over several lines, indented to line
    # up with the code. ActiveSupport's `strip_heredoc` removes that shared
    # indentation from the lines after the first.
    def tidy_description(description)
      first_line, following_lines = description.strip.split("\n", 2)
      [first_line, following_lines&.strip_heredoc]
        .compact
        .join("\n")
        .gsub(/[ \t]+$/, "")
        .gsub(/\n{3,}/, "\n\n")
    end
  end
end
