require 'rails_helper'

RSpec.describe ImportService::Common do
  let(:zip) { file_fixture('zip_to_cbsa.csv').open }
  let(:mdiv) { file_fixture('cbsa_to_msa.csv').open }

  subject { described_class.new(zip_to_cbsa: zip, cbsa_to_msa: mdiv) }

  context 'zip_to_cbsa file missing' do
    let(:zip) { nil }

    describe '#invalid_import_request?' do
      it 'returns true' do
        expect(subject.send(:invalid_import_request?)).to be_truthy
      end

      it 'adds error for missing parameter' do
        subject.send(:invalid_import_request?)
        expect(subject.errors).to include('Missing required parameter :zip_to_cbsa')
      end
    end

    include_examples 'import service common errors'
  end

  context 'cbsa_to_msa file missing' do
    let(:mdiv) { nil }

    describe '#invalid_import_request?' do
      it 'returns true' do
        expect(subject.send(:invalid_import_request?)).to be_truthy
      end

      it 'adds error for missing parameter' do
        subject.send(:invalid_import_request?)
        expect(subject.errors).to include('Missing required parameter :cbsa_to_msa')
      end
    end

    include_examples 'import service common errors'
  end

  context 'both files missing' do
    let(:mdiv) { nil }
    let(:zip) { nil }

    describe '#invalid_import_request?' do
      it 'returns true' do
        expect(subject.send(:invalid_import_request?)).to be_truthy
      end

      it 'adds error for missing parameter' do
        subject.send(:invalid_import_request?)
        expect(subject.errors).to include('Missing required parameter :cbsa_to_msa')
        expect(subject.errors).to include('Missing required parameter :zip_to_cbsa')
      end
    end

    include_examples 'import service common errors'
  end

  context 'both files present' do
    describe '#invalid_import_request?' do
      it 'returns false' do
        expect(subject.send(:invalid_import_request?)).to be_falsey
      end

      it 'adds error for missing parameter' do
        subject.send(:invalid_import_request?)
        expect(subject.errors).to be_empty
      end
    end

    describe '#import' do
      it 'returns ok status' do
        expect(subject.import).to eq(status: :ok)
      end

      it 'calls Zip import' do
        expect(::ImportService::Zip).to receive(:import)
        subject.import
      end

      it 'calls Population import' do
        expect(::ImportService::Population).to receive(:import)
        subject.import
      end
    end
  end
end
