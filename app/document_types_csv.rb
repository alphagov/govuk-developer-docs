require "csv"

class DocumentTypesCsv
  def initialize(pages)
    @pages = pages
  end

  def to_csv
    CSV.generate do |csv|
      row = [
        "Name",
        "Docs URL",
        "Number of pages",
        "Example URL",
        "Rendering apps",
      ]

      Supertypes.all.each do |supertype|
        row << supertype.name
      end

      csv << row

      @pages.each do |page|
        example_url = page.examples.first ? "https://www.gov.uk" + page.examples.first["link"] : nil

        row = [
          page.name,
          page.url,
          page.total_count,
          example_url,
          page.rendering_apps.join(", "),
        ]

        Supertypes.all.each do |supertype|
          row << supertype.for_document_type(page.name)
        end

        csv << row
      end
    end
  end
end
