require 'rails_helper'

RSpec.describe PopulationInformation do
  let(:data) do
    [
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
        "Abilene, TX",
        "Metropolitan Statistical Area",
        "165609",
        "166639",
        "167578",
        "167549",
        "168380",
        "169578"
      ]
    ]
  end

  let(:columns) { [:cbsa, :name, :lsad, :pop_2010, :pop_2011, :pop_2012, :pop_2013, :pop_2014, :pop_2015] }
  let(:options) { { validate: false, on_duplicate_key_ignore: true } }

  include_examples 'models import shared'
end
