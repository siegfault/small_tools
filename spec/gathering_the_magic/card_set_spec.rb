# frozen_string_literal: true

require_relative '../../lib/gathering_the_magic/card_set'

RSpec.describe CardSet do
  let(:csv) { 'spec/gathering_the_magic/fixtures/cards.csv' }
  let(:lands_unreachable_rules_text) do
    <<~TEXT.strip
      When this enters the battlefield gain an emblem "Lands you control lose all abilities and gain: "{T}: choose one which hasn't yet been chosen:
      -- Add {W}
      -- Add {G}
      -- Add {R}
      -- Add {U}
      -- Add {B}
      -- Exile all emblems you control and The Lands Unreachable""
    TEXT
  end

  let(:lands_unreachable) do
    {
      'Set Code' => 'SG',
      'Set Number' => nil,
      'Rarity' => 'r',
      'Name' => 'The Lands Unreachable',
      'Mana Cost' => nil,
      'Supertype' => 'Legendary',
      'Type' => 'Land',
      'Subtype' => nil,
      'Rules Text' => lands_unreachable_rules_text,
      'Power/Toughness/Battle Score' => nil,
      'Flavor Text' => nil,
      'Colors' => 'colorless',
      'Image Link' => nil,
      'Prompt' => 'magic: the gathering" style art of a land called "The Lands Unreachable" all five colors --niji 6 --ar 11:8',
      'In Magic Set Editor?' => 'Fin',
      nil => ' '
    }
  end
  let(:pirates_pirate) do
    {
      'Set Code' => 'SG',
      'Set Number' => nil,
      'Rarity' => 'c',
      'Name' => "The Pirate's Pirate",
      'Mana Cost' => 'UU',
      'Supertype' => nil,
      'Type' => 'Creature',
      'Subtype' => 'Human Pirate Rabble',
      'Rules Text' => "Whenever {N} attacks and isn't blocked, you may gain control of target artifact defending player controls. If you do, {N} assigns no combat damage this turn.",
      'Power/Toughness/Battle Score' => '1/1',
      'Flavor Text' => nil,
      'Colors' => 'blue',
      'Image Link' => nil,
      'Prompt' => nil,
      'In Magic Set Editor?' => nil,
      nil => ' '
    }
  end

  it 'initializes cards from rows' do
    allow(Card).to receive(:from_csv).twice

    described_class.from_csv(csv)

    expect(Card).to have_received(:from_csv).with(lands_unreachable).once
    expect(Card).to have_received(:from_csv).with(pirates_pirate).once
  end

  it 'creates valid cards' do
    set = described_class.from_csv(csv)

    expect(set.cards).to all(be_valid)
  end
end
