RSpec.describe PageReview do
  describe '#review_by' do
    it "calculates it correctly" do
      review_by = PageReview.new(
        double(data: double(last_reviewed_on: Date.parse("2016-01-01"), review_in: "6 months"))
      )

      expect(review_by.review_by).to eql(Date.parse("2016-07-01"))
    end
  end
end
