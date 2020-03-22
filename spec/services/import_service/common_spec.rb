require 'rails_helper'

RSpec.describe ImportService::Common do
  let(:zip) { double(tempfile: double(path: file_fixture('zip_to_cbsa.csv').to_s), original_filename: 'zip_to_cbsa.csv') }
  let(:mdiv) { double(tempfile: double(path: file_fixture('cbsa_to_msa.csv').to_s), original_filename: 'cbsa_to_msa.csv') }

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

      it 'calls ImportDataJob to import data' do
        expect(::ImportDataJob).to receive(:perform_later)
        subject.import
      end
    end
  end
end
