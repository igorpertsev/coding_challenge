RSpec.shared_examples 'models import shared' do
  describe '#import_without_validation' do
    it 'imports data passed to method without duplicates' do
      described_class.import_without_validation(data)
      expect(described_class.count).to eq(data.size - 1)
    end

    it 'use correct flags on import' do
      expect(described_class).to receive(:import).with(columns, data, options)
      described_class.import_without_validation(data)
    end
  end
end
