require 'base'
require 'client'
require 'configuration'

RSpec.describe NEO::CloseObj::Client do
  before do
    stub_request(:get, 'https://api.nasa.gov/neo/rest/v1/feed')
      .to_return(status: 200, body: '{"near_earth_objects": {"2019-04-08": [{"name": "neo name",
                                                                             "close_approach_data": [{"miss_distance": "miss distance data", "relative_velocity": "relative velocity data"}],
                                                                             "estimated_diameter": "estimated diameter data"}]}}', headers: {})
  end

  let(:config) do
    Struct.new(:current_date, :full_url).new("2019-04-08", NEO::CloseObj::Configuration::DEFAULT_HOST)
  end

  subject { NEO::CloseObj::Client.new(config) }

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

end
