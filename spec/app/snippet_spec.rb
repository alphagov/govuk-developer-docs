RSpec.describe Snippet do
  describe ".generate" do
    it "generates a proper snippet without the opsmanual warning" do
      html = <<~HTML
        <blockquote>
        <p><strong>This page was imported from <a href="https://github.com/alphagov/govuk-legacy-opsmanual">the opsmanual on GitHub Enterprise</a></strong>.
        It hasn&rsquo;t been reviewed for accuracy yet.
        <a href="https://github.com/alphagov/govuk-legacy-opsmanual/tree/master/2nd-line/howto-manually-remove-assets.md">View history in old opsmanual</a></p>
        </blockquote>
        <h1 id='remove-an-asset'>Remove an asset</h1>
        <p>If you need to remove an asset manually from <code>assets.publishing.sevice.gov.uk</code>,
        follow these steps:</p>
      HTML

      snippet = Snippet.generate(html)

      expect(snippet).to eql("If you need to remove an asset manually from assets.publishing.sevice.gov.uk, follow these steps:")
    end

    it "removes headings" do
      html = <<~HTML
        <h1 id='deploy-an-application-to-govuk'>Deploy an application to GOV.UK</h1>
        <h2 id='introduction'>Introduction</h2>
        <p>2nd line is responsible for:</p>

        <ul>
        <li>ensuring that software is released to GOV.UK responsibly</li>
        <li>providing access to deploy software for teams who can&rsquo;t deploy it themselves</li>
        </ul>

        <p>As far as possible, teams are responsible for deploying their own work. We believe that
        <a href="https://gds.blog.gov.uk/2012/11/02/regular-releases-reduce-risk/">regular releases minimise the risk of major problems</a> and
        improve recovery time.</p>
      HTML

      snippet = Snippet.generate(html)

      expect(snippet).to eql("2nd line is responsible for: ensuring that software is released to GOV.UK responsibly providing access to deploy software for teams who can’t deploy it themselves As far as possible, teams are responsible for deploying their own work. We believe that regular releases minimise the risk of major pr...")
    end
  end
end
