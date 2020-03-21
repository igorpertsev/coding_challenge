RSpec.shared_examples 'import service shared' do
  describe '#import' do
    it 'drops existing data from table' do
      expect(subject).to receive(:truncate_existing_data)
      subject.import
    end

    it 'parse csv file provided' do
      expect(subject).to receive(:parse_csv)
      subject.import
    end
  end

  describe '#persist_data_batch' do
    let(:data) { double }
    let(:klass) { double }

    before { allow(klass).to receive(:import_without_validation) }

    it 'runs import_without_validation on passed class' do
      expect(klass).to receive(:import_without_validation).with(data)
      subject.send(:persist_data_batch, data, klass)
    end

    it 'return empty batch Array' do
      expect(subject.send(:persist_data_batch, data, klass)).to eq([])
    end
  end
end
