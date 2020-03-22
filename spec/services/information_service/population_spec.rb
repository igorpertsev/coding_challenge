require 'rails_helper'

RSpec.describe InformationService::Population do
  subject { described_class.fetch(zip_code) }

  let(:zip_code) { 404 }
  let(:cbsa) { 1000 }

  context 'no cbsa found' do
    it 'returns empty response with invalid zip CBSA value' do
      expect(subject).to eq(
        cbsa: '99999',
        name: 'N/A',
        lsad: 'N/A',
        pop_2010: 'N/A',
        pop_2011: 'N/A',
        pop_2012: 'N/A',
        pop_2013: 'N/A',
        pop_2014: 'N/A',
        pop_2015: 'N/A',
        zip: zip_code
      )
    end
  end

  context 'no population information present' do
    context 'no MDIV association present' do
      let(:zip_code) { 501 }

      before { create(:zip_association, zip: zip_code, cbsa: cbsa) }

      it 'returns empty response with correct CBSA' do
        expect(subject).to eq(
          cbsa: cbsa,
          name: 'N/A',
          lsad: 'N/A',
          pop_2010: 'N/A',
          pop_2011: 'N/A',
          pop_2012: 'N/A',
          pop_2013: 'N/A',
          pop_2014: 'N/A',
          pop_2015: 'N/A',
          zip: zip_code
        )
      end
    end

    context 'MDIV association present' do
      let(:zip_code) { 601 }

      before do
        create(:zip_association, zip: zip_code, cbsa: 5)
        create(:mdiv_cbsa_association, cbsa: cbsa, mdiv: 5)
      end

      it 'returns empty response with correct CBSA' do
        expect(subject).to eq(
          cbsa: cbsa,
          name: 'N/A',
          lsad: 'N/A',
          pop_2010: 'N/A',
          pop_2011: 'N/A',
          pop_2012: 'N/A',
          pop_2013: 'N/A',
          pop_2014: 'N/A',
          pop_2015: 'N/A',
          zip: zip_code
        )
      end
    end
  end

  context 'population information exist' do
    context 'no MDIV association present' do
      let(:zip_code) { 501 }
      let!(:population) { create(:population_information, cbsa: cbsa) }

      before do
        create(:zip_association, zip: zip_code, cbsa: cbsa)
        create(:population_information, cbsa: cbsa, lsad: 'test')
      end

      it 'returns full response with correct cbsa and lsad' do
        expect(subject.symbolize_keys).to eq(
          cbsa: cbsa,
          name: population.name,
          lsad: population.lsad,
          pop_2010: population.pop_2010,
          pop_2011: population.pop_2011,
          pop_2012: population.pop_2012,
          pop_2013: population.pop_2013,
          pop_2014: population.pop_2014,
          pop_2015: population.pop_2015,
          zip: zip_code
        )
      end
    end

    context 'MDIV association present' do
      let(:zip_code) { 601 }
      let!(:population) { create(:population_information, cbsa: cbsa) }

      before do
        create(:zip_association, zip: zip_code, cbsa: 5)
        create(:mdiv_cbsa_association, cbsa: cbsa, mdiv: 5)
        create(:population_information, cbsa: cbsa, lsad: 'test')
        create(:population_information, cbsa: 5, lsad: 'test2')
      end

      it 'returns full response with correct cbsa and lsad' do
        expect(subject.symbolize_keys).to eq(
          cbsa: cbsa,
          name: population.name,
          lsad: population.lsad,
          pop_2010: population.pop_2010,
          pop_2011: population.pop_2011,
          pop_2012: population.pop_2012,
          pop_2013: population.pop_2013,
          pop_2014: population.pop_2014,
          pop_2015: population.pop_2015,
          zip: zip_code
        )
      end
    end
  end
end
