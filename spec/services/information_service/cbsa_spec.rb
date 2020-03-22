require 'rails_helper'

RSpec.describe InformationService::Cbsa do
  subject { described_class.fetch(zip_code) }

  let(:zip_code) { 404 }
  let(:cbsa) { 1000 }

  it 'return ::ZipAssociation::INVALID_ZIP if no ZIP association found' do
    expect(subject).to eq(::ZipAssociation::INVALID_ZIP)
  end

  context 'no MDIV association present' do
    let(:zip_code) { 501 }

    before { create(:zip_association, zip: zip_code, cbsa: cbsa) }

    it 'returns cbsa by zip code' do
      expect(subject).to eq(cbsa)
    end
  end

  context 'MDIV association present' do
    let(:zip_code) { 601 }

    before do
      create(:zip_association, zip: zip_code, cbsa: 5)
      create(:mdiv_cbsa_association, cbsa: cbsa, mdiv: 5)
    end

    it 'returns cbsa by zip code and mdiv' do
      expect(subject).not_to eq(5)
      expect(subject).to eq(cbsa)
    end
  end
end
