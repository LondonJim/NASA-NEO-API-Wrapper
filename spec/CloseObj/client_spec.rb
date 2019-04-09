require 'base'
require 'client'
require 'configuration'

RSpec.describe NEO::CloseObj::Client do
  before do
    stub_request(:get, 'https://api.nasa.gov/neo/rest/v1/feed?start_date=2019-04-08&end_date=2019-04-08&detailed=false&api_key=DEMO_KEY')
      .to_return(status: 200, body: '{"near_earth_objects": {"2019-04-08": [{"name": "neo name",
                                                                             "close_approach_data": [{"miss_distance": "miss distance data", "relative_velocity": "relative velocity data"}],
                                                                             "estimated_diameter": "estimated diameter data"}]}}', headers: {})
  end

  let(:config) do
    Struct.new(:host, :api_key).new(NEO::CloseObj::Configuration::DEFAULT_HOST, NEO::CloseObj::Configuration::DEFAULT_API_KEY)
  end

  subject { NEO::CloseObj::Client.new(config) }

    before(:each) do
      subject.instance_variable_set(:@date, "2019-04-08")
    end

    it 'returns the neo name' do
      expect(subject.neo_name).to eq('neo name')
    end

    it 'returns the miss distances' do
      expect(subject.miss_distance).to eq('miss distance data')
    end

    it 'returns the relative velocities' do
      expect(subject.velocity).to eq('relative velocity data')
    end

    it 'returns the estimated diameter' do
      expect(subject.estimated_diameter).to eq('estimated diameter data')
    end

    it 'sets an api key' do
      subject.key = "newKey"
      expect(subject.key).to eq("newKey")
    end

    it 'sets a date' do
      subject.date = "2018-04-10"
      expect(subject.date).to eq("2018-04-10")
    end

end
