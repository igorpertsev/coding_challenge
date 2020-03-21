require 'rails_helper'

RSpec.describe ZipAssociation do
  let(:data) { [[1123, 2312], [1234, 5554], [1234, 5554]] }
  let(:columns) { [:zip, :cbsa] }
  let(:options) { { validate: false, on_duplicate_key_ignore: true } }

  include_examples 'models import shared'
end
