require 'rails_helper'

RSpec.describe ImportService::Zip do
  let(:file) { file_fixture('zip_to_cbsa.csv').open }

  subject { described_class.new(file) }

  include_examples 'import service shared'

  describe '#parse_csv' do
    it 'use persist_data_batch method to persist data' do
      expected = [['501', '10180'], ['601', '14454'], ['602', '14460']]
      expect(subject).to receive(:persist_data_batch).with(expected, ::ZipAssociation).exactly(1).time
      subject.send(:parse_csv)
    end

    it 'dont save records with cbsa 99999' do
      subject.send(:parse_csv)
      expect(::ZipAssociation.where(cbsa: '99999').count).to eq(0)
    end

    it 'saves records from csv file' do
      subject.send(:parse_csv)
      expect(::ZipAssociation.count).to eq(3)
    end
  end

  describe '#truncate_existing_data' do
    it 'removes all data from zip_associations table' do
      subject.import

      expect(::ZipAssociation.count).to eq(3)

      subject.send(:truncate_existing_data)

      expect(::ZipAssociation.count).to eq(0)
    end
  end
end
