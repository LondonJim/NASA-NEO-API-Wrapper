RSpec.describe NasaNeo::CloseObj::Client do
  before do
    stub_request(:get, 'https://api.nasa.gov/neo/rest/v1/feed?start_date=2019-04-08&end_date=2019-04-08&detailed=false&api_key=DEMO_KEY')
      .to_return(status: 200, body: '{"near_earth_objects": {"2019-04-08": [{"name": "neo name",
                                                                             "close_approach_data": [{"miss_distance": {"astronomical": "0.1915058335",
                                                                                                                        "lunar": "74.4957733154",
                                                                                                                        "kilometers": "28648866",
                                                                                                                        "miles": "17801580"},
                                                                                                      "relative_velocity": {"kilometers_per_second": "14.488889894",
                                                                                                                            "kilometers_per_hour": "52160.0036184644",
                                                                                                                            "miles_per_hour": "32410.1978039286"}}],
                                                                             "estimated_diameter": {"kilometers": {"estimated_diameter_min": 0.1838886721, "estimated_diameter_max": 0.411187571},
                                                                                                    "meters": {"estimated_diameter_min": 183.8886720703, "estimated_diameter_max": 411.1875710413},
                                                                                                    "miles": {"estimated_diameter_min": 0.1142630881, "estimated_diameter_max": 0.2555000322},
                                                                                                    "feet": {"estimated_diameter_min": 603.309310875, "estimated_diameter_max": 1349.040630575}},
                                                                             "is_potentially_hazardous_asteroid": false }]}}', headers: {})
    stub_request(:get, 'https://api.nasa.gov/neo/rest/v1/feed?start_date=19-04-08&end_date=19-04-08&detailed=false&api_key=DEMO_KEY')
      .to_return(status: [400, ""])
  end

  let(:config) do
    Struct.new(:host, :api_key).new(NasaNeo::CloseObj::Configuration::DEFAULT_HOST, NasaNeo::CloseObj::Configuration::DEFAULT_API_KEY)
  end

  subject { NasaNeo::CloseObj::Client.new(config) }

    before(:each) do
      subject.instance_variable_set(:@date, "2019-04-08")
    end

    describe '#neo_name' do
      it 'returns the neo name' do
        expect(subject.neo_name).to eq('neo name')
      end
    end

    describe '#miss_distance' do
      it 'returns the miss distances' do
        expect(subject.miss_distance).to eq(JSON.parse('{"astronomical": "0.1915058335",
                                                        "lunar": "74.4957733154",
                                                        "kilometers": "28648866",
                                                        "miles": "17801580"}'))
      end

      it 'returns the astronomical miss distances' do
        expect(subject.miss_distance("astronomical")).to eq(0.1915058335)
      end

      it 'returns the lunar miss distances' do
        expect(subject.miss_distance("lunar")).to eq(74.4957733154)
      end

      it 'returns the kilometers miss distances' do
        expect(subject.miss_distance("kilometers")).to eq(28648866)
      end

      it 'returns the miles miss distances' do
        expect(subject.miss_distance("miles")).to eq(17801580)
      end

      it 'returns error hash if measurement argument is not recognised' do
        expect(subject.miss_distance("unknown measurement")).to eq({error: ["measurement", "check arguments"] })
      end
    end

    describe '#veolicty' do
      it 'returns the relative velocities' do
        expect(subject.velocity).to eq(JSON.parse('{"kilometers_per_second": "14.488889894",
                                                    "kilometers_per_hour": "52160.0036184644",
                                                    "miles_per_hour": "32410.1978039286"}'))
      end

      it 'returns the kilometers_per_second relative velocities' do
        expect(subject.velocity("kilometers_per_second")).to eq(14.488889894)
      end

      it 'returns the kilometers_per_hour relative velocities' do
        expect(subject.velocity("kilometers_per_hour")).to eq(52160.0036184644)
      end

      it 'returns the miles_per_hour relative velocities' do
        expect(subject.velocity("miles_per_hour")).to eq(32410.1978039286)
      end

      it 'returns error hash if measurement argument is not recognised' do
        expect(subject.velocity("unknown measurement")).to eq({error: ["measurement", "check arguments"] })
      end
    end

    describe '#estimated_diameter' do
      it 'returns the estimated diameter' do
        expect(subject.estimated_diameter).to eq(JSON.parse('{"kilometers": {"estimated_diameter_min": 0.1838886721, "estimated_diameter_max": 0.411187571},
                                                              "meters": {"estimated_diameter_min": 183.8886720703, "estimated_diameter_max": 411.1875710413},
                                                              "miles": {"estimated_diameter_min": 0.1142630881, "estimated_diameter_max": 0.2555000322},
                                                              "feet": {"estimated_diameter_min": 603.309310875, "estimated_diameter_max": 1349.040630575}}'))
      end

      describe 'kilometers' do
        it 'returns estimated diameters' do
          expect(subject.estimated_diameter("kilometers")).to eq(JSON.parse('{"estimated_diameter_min": 0.1838886721, "estimated_diameter_max": 0.411187571}'))
        end

        it 'returns minimum estimated diameter' do
          expect(subject.estimated_diameter("kilometers", "min")).to eq(0.1838886721)
        end

        it 'returns maximum estimated diameter' do
          expect(subject.estimated_diameter("kilometers", "max")).to eq(0.411187571)
        end
      end

      describe 'meters' do
        it 'returns estimated diameters' do
          expect(subject.estimated_diameter("meters")).to eq(JSON.parse('{"estimated_diameter_min": 183.8886720703, "estimated_diameter_max": 411.1875710413}'))
        end

        it 'returns minimum estimated diameter' do
          expect(subject.estimated_diameter("meters", "min")).to eq(183.8886720703)
        end

        it 'returns maximum estimated diameter' do
          expect(subject.estimated_diameter("meters", "max")).to eq(411.1875710413)
        end
      end

      describe 'miles' do
        it 'returns estimated diameter' do
          expect(subject.estimated_diameter("miles")).to eq(JSON.parse('{"estimated_diameter_min": 0.1142630881, "estimated_diameter_max": 0.2555000322}'))
        end

        it 'returns minimum estimated diameter' do
          expect(subject.estimated_diameter("miles", "min")).to eq(0.1142630881)
        end

        it 'returns maximum estimated diameter' do
          expect(subject.estimated_diameter("miles", "max")).to eq(0.2555000322)
        end
      end

      describe 'feet' do
        it 'returns estimated diameter' do
          expect(subject.estimated_diameter("feet")).to eq(JSON.parse('{"estimated_diameter_min": 603.309310875, "estimated_diameter_max": 1349.040630575}'))
        end

        it 'returns minimum estimated diameter' do
          expect(subject.estimated_diameter("feet", "min")).to eq(603.309310875)
        end

        it 'returns maximum estimated diameter' do
          expect(subject.estimated_diameter("feet", "max")).to eq(1349.040630575)
        end
      end

      it 'returns error hash if measurement argument is not recognised' do
        expect(subject.estimated_diameter("unknown measurement")).to eq({error: ["measurement", "check arguments"] })
      end

      it 'returns error hash if min/max argument is not recognised' do
        expect(subject.estimated_diameter("kilometers", "unknown")).to eq({error: ["min_max", "check arguments"] })
      end
    end

    describe '#hazardous?' do
      it 'returns boolean of potential hazardousness' do
        expect(subject.hazardous?).to eq(false)
      end
    end

    describe '#neo_data' do
      it 'returns all data for closest near earth object' do
        expect(subject.neo_data).to eq(JSON.parse('{"name": "neo name",
                                                    "close_approach_data": [{"miss_distance": {"astronomical": "0.1915058335",
                                                                                               "lunar": "74.4957733154",
                                                                                               "kilometers": "28648866",
                                                                                               "miles": "17801580"},
                                                                             "relative_velocity": {"kilometers_per_second": "14.488889894",
                                                                                                   "kilometers_per_hour": "52160.0036184644",
                                                                                                   "miles_per_hour": "32410.1978039286"}}],
                                                    "estimated_diameter": {"kilometers": {"estimated_diameter_min": 0.1838886721, "estimated_diameter_max": 0.411187571},
                                                                           "meters": {"estimated_diameter_min": 183.8886720703, "estimated_diameter_max": 411.1875710413},
                                                                           "miles": {"estimated_diameter_min": 0.1142630881, "estimated_diameter_max": 0.2555000322},
                                                                           "feet": {"estimated_diameter_min": 603.309310875, "estimated_diameter_max": 1349.040630575}},
                                                    "is_potentially_hazardous_asteroid": false}'))
      end
    end

    it 'sets an api key' do
      subject.key = "newKey"
      expect(subject.key).to eq("newKey")
    end

    it 'sets a date' do
      subject.date = "2018-04-10"
      expect(subject.date).to eq("2018-04-10")
    end

    it 'returns 400 status error hash when date wrong' do
      subject.instance_variable_set(:@date, "19-04-08")
      expect(subject.neo_name).to eq({ error: ["400", ""]})
    end

end
