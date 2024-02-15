RSpec.describe Repo do
  describe "is_app?" do
    it "returns false if 'production_hosted_on' is omitted" do
      expect(Repo.new({}).is_app?).to be(false)
    end

    it "returns true if 'production_hosted_on' is supplied" do
      expect(Repo.new({ "production_hosted_on" => "aws" }).is_app?).to be(true)
    end
  end

  describe "is_gem?" do
    it "returns true if assiged type is Gems" do
      expect(Repo.new({ "type" => "Gems" }).is_gem?).to be(true)
    end

    it "returns false if assigned type isn't Gems" do
      expect(Repo.new({ "type" => "Utilities" }).is_gem?).to be(false)
    end
  end

  describe "app_name" do
    it "returns repo_name if app_name not specified" do
      expect(Repo.new({ "repo_name" => "foo" }).app_name).to eq("foo")
    end

    it "returns app_name if both app_name and repo_name are specified" do
      expect(Repo.new({ "app_name" => "foo", "repo_name" => "bar" }).app_name).to eq("foo")
    end
  end

  describe "api_payload" do
    it "returns a hash of keys describing the app" do
      app_details = {
        "repo_name" => "foo",
        "team" => "bar",
        "dependencies_team" => "baz",
        "production_hosted_on" => "aws",
      }
      payload = Repo.new(app_details).api_payload
      expect(payload[:app_name]).to eq(app_details["repo_name"])
      expect(payload[:team]).to eq(app_details["team"])
      expect(payload[:dependencies_team]).to eq(app_details["dependencies_team"])
      expect(payload[:production_hosted_on]).to eq(app_details["production_hosted_on"])
      expect(payload[:links]).to include(:self, :html_url, :repo_url, :sentry_url)
    end
  end

  describe "production_url" do
    it "has a good default" do
      app = Repo.new("type" => "Publishing apps", "repo_name" => "my-app")

      expect(app.production_url).to eql("https://my-app.publishing.service.gov.uk")
    end

    it "allows override" do
      app = Repo.new("type" => "Publishing apps", "production_url" => "something else")

      expect(app.production_url).to eql("something else")
    end
  end

  describe "dashboard_url" do
    let(:default_options) do
      {
        "type" => "Publishing app",
        "repo_name" => "my-app",
      }
    end
    let(:options) { default_options }
    subject(:dashboard_url) { described_class.new(options).dashboard_url }

    describe "configured dashboard_url set to false" do
      let(:options) { default_options.merge("dashboard_url" => false) }
      it { is_expected.to be_nil }
    end

    describe "configured dashboard_url" do
      let(:options) { default_options.merge("dashboard_url" => "https://example.com") }
      it { is_expected.to eql("https://example.com") }
    end

    describe "default dashboard_url for EKS hosted apps" do
      let(:production_hosted_on) { "eks" }
      let(:options) { default_options.merge("production_hosted_on" => "eks") }
      it { is_expected.to eql("https://grafana.eks.production.govuk.digital/d/app-requests/app3a-request-rates-errors-durations?var-app=my-app") }
    end

    describe "default dashboard_url" do
      it { is_expected.to eql(nil) }
    end
  end

  describe "kibana_url" do
    let(:default_options) { { "repo_name" => "content-publisher" } }
    let(:options) { default_options }
    subject(:kibana_url) { described_class.new(options).kibana_url }

    describe "default behaviour" do
      it { is_expected.to eql(nil) }
    end

    describe "hosted on EKS" do
      let(:options) { default_options.merge("production_hosted_on" => "eks") }

      it { is_expected.to eql("https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/app/discover?security_tenant=global#/?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-3h,to:now))&_a=(columns:!(level,request,status,message),filters:!(('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'filebeat-*',key:kubernetes.labels.app_kubernetes_io%2Fname,negate:!f,params:(query:content-publisher),type:phrase),query:(match_phrase:(kubernetes.labels.app_kubernetes_io%2Fname:content-publisher)))),index:'filebeat-*',interval:auto,query:(language:kuery,query:''),sort:!())"), "Actual URL returned: #{kibana_url.inspect}" }
    end
  end

  describe "kibana_worker_url" do
    let(:default_options) { { "repo_name" => "content-publisher" } }
    let(:options) { default_options }
    subject(:kibana_worker_url) { described_class.new(options).kibana_worker_url }

    describe "default behaviour" do
      it { is_expected.to eql(nil) }
    end

    describe "hosted on EKS" do
      let(:options) { default_options.merge("production_hosted_on" => "eks") }

      it { is_expected.to eql("https://kibana.logit.io/s/13d1a0b1-f54f-407b-a4e5-f53ba653fac3/app/discover?security_tenant=global#/?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-3h,to:now))&_a=(columns:!(level,message),filters:!(('$state':(store:appState),meta:(alias:!n,disabled:!f,index:'filebeat-*',key:kubernetes.labels.app_kubernetes_io%2Fname,negate:!f,params:(query:content-publisher-worker),type:phrase),query:(match_phrase:(kubernetes.labels.app_kubernetes_io%2Fname:content-publisher-worker)))),index:'filebeat-*',interval:auto,query:(language:kuery,query:''),sort:!())"), "Actual URL returned: #{kibana_worker_url.inspect}" }
    end
  end
end
