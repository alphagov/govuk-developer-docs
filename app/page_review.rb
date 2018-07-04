require 'chronic'

class PageReview
  attr_reader :page

  def initialize(page)
    @page = page
  end

  def reviewable?
    page.data.review_in.present?
  end

  def owner_slack
    page.data.owner_slack
  end

  def owner_slack_url
    # Slack URLs don't have the # (channels) or @ (usernames)
    slack_identifier = owner_slack.delete('#').delete('@')
    "https://gds.slack.com/messages/#{slack_identifier}"
  end

  def expired?
    reviewable? && Date.today > review_by
  end

  def expiring_soon?
    reviewable? && Date.today > (review_by - 7.days)
  end

  def review_by
    @review_by ||= Chronic.parse(
      "in #{page.data.review_in}",
      now: last_reviewed_on.to_time
    ).to_date
  end

  def last_reviewed_on
    page.data.last_reviewed_on
  end
end
