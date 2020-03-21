RSpec.shared_examples 'import service common errors' do
  describe '#import' do
    it 'returns error message' do
      expect(subject.import).to eq(errors: subject.errors)
    end

    it 'dont call Zip import' do
      expect(::ImportService::Zip).not_to receive(:import)
      subject.import
    end

    it 'dont call Population import' do
      expect(::ImportService::Population).not_to receive(:import)
      subject.import
    end
  end
end
