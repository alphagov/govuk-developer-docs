RSpec.describe Manual do
  describe "#manual_pages_grouped_by_section" do
    it "returns the correct groups" do
      sitemap = double(resources: [
        double(path: "foo.html", data: double(title: "Won't be included", important: true, review_by: Date.today, section: "Foo", type: nil)),
        double(path: "manual/foo.html", data: double(title: "Foo", important: true, review_by: Date.today, section: "Foo", type: nil)),
        double(path: "manual/bar.html", data: double(title: "Bar", important: true, review_by: Date.today, section: "Bar", type: nil)),
      ])

      manual_pages_grouped_by_section = Manual.new(sitemap).manual_pages_grouped_by_section

      expect(manual_pages_grouped_by_section.map(&:first)).to eql(["Common tasks", "Bar", "Foo"])
    end
  end

  describe "#other_pages_from_section" do
    it "returns the correct groups" do
      one = double(path: "manual/foo.html", data: double(title: "Foo", important: true, section: "A section", type: nil))
      other = double(path: "manual/bar.html", data: double(title: "Bar", important: true, section: "A section", type: nil))

      sitemap = double(resources: [
        one,
        other,
        double(path: "manual/baz.html", data: double(title: "Baz", section: "B section", type: nil)),
      ])

      other_pages_from_section = Manual.new(sitemap).other_pages_from_section(one)

      expect(other_pages_from_section).to eql([other])
    end
  end

  describe "#other_alerts_from_subsection" do
    it "returns other Icinga Alert pages that have the same subsection" do
      def stub_page(data_args)
        double(path: "manual/#{SecureRandom.uuid}.html", data: double({ important: true, type: nil, subsection: nil }.merge(data_args)))
      end

      matching_subsection_and_alert = stub_page(title: "Foo", section: "Icinga alerts", subsection: "Emails")
      another_matching_subsection_and_alert = stub_page(title: "Bar", section: "Icinga alerts", subsection: "Emails")
      alert_but_not_matching_subsection = stub_page(title: "Alert about something else", section: "Icinga alerts", subsection: "Some other subject")
      matching_subsection_but_not_alert = stub_page(title: "NOT an alert", section: "Sausages", subsection: "Emails")

      sitemap = double(resources: [
        matching_subsection_and_alert,
        another_matching_subsection_and_alert,
        alert_but_not_matching_subsection,
        matching_subsection_but_not_alert,
      ])

      other_alerts_from_subsection = Manual.new(sitemap).other_alerts_from_subsection(matching_subsection_and_alert)

      expect(other_alerts_from_subsection).to eql([another_matching_subsection_and_alert])
    end
  end

  describe "#pages_for_application" do
    it "returns the pages that are relevant to an application" do
      sitemap = double(resources: [
        double(path: "foo.html", data: double(title: "Won't be included", important: true, review_by: Date.today, section: "Foo", type: nil)),
        double(path: "manual/foo.html", data: double(title: "Foo", related_applications: %w[publisher], section: "Foo", type: nil)),
        double(path: "manual/bar.html", data: double(title: "Bar", related_applications: %w[collections], section: "Bar", type: nil)),
      ])

      pages_for_application = Manual.new(sitemap).pages_for_application("publisher")

      expect(pages_for_application.map(&:path)).to eql(["manual/foo.html"])
    end
  end
end
