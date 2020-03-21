require 'rails_helper'

RSpec.describe ImportService::Population do
  let(:file) { file_fixture('cbsa_to_msa.csv').open }
  let(:mdiv_klass) { ::MdivCbsaAssociation }
  let(:population_klass) { ::PopulationInformation }

  subject { described_class.new(file) }

  include_examples 'import service shared'

  describe '#parse_csv' do
    it 'use persist_data_batch method to persist data' do
      expected_population = [
        [
          "10180",
          "Abilene, TX",
          "Metropolitan Statistical Area",
          "165609",
          "166639",
          "167578",
          "167549",
          "168380",
          "169578"
        ],
        [
          "10180",
          "Callahan County, TX",
          "County or equivalent",
          "13518",
          "13535",
          "13519",
          "13528",
          "13520",
          "13557"
        ],
        [
          "14460",
          "Boston-Cambridge-Newton, MA-NH",
          "Metropolitan Statistical Area",
          "4565410",
          "4608426",
          "4652342",
          "4698356",
          "4739385",
          "4774321"
        ],
        [
          "14460",
          "Boston, MA",
          "Metropolitan Division",
          "1893962",
          "1912979",
          "1932117",
          "1952426",
          "1969547",
          "1984537"
        ]
      ]
      expect(subject).to receive(:persist_data_batch).with(expected_population, population_klass).exactly(1).time
      expect(subject).to receive(:persist_data_batch).with([["14460", "14454"]], mdiv_klass).exactly(1).time
      subject.send(:parse_csv)
    end

    it 'saves mdiv association records only if MDIV present' do
      subject.send(:parse_csv)
      expect(mdiv_klass.count).to eq(1)
    end

    it 'saves all population information by year' do
      subject.send(:parse_csv)
      expect(population_klass.count).to eq(4)
    end
  end

  describe '#truncate_existing_data' do
    it 'removes all data from mdiv_cbsa_associations and population_information tables' do
      subject.import

      expect(mdiv_klass.count).to eq(1)
      expect(population_klass.count).to eq(4)

      subject.send(:truncate_existing_data)

      expect(mdiv_klass.count).to eq(0)
      expect(population_klass.count).to eq(0)
    end
  end
end
