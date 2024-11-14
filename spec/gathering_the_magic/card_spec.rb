# frozen_string_literal: true

require_relative '../../lib/gathering_the_magic/card'

RSpec.describe Card do
  let(:data) do
    {
      'Set Shorthand' => 'SG',
      'Set Number' => 1,
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

  describe '.from_csv' do
    let(:card) { described_class.from_csv(data) }

    it 'parses the set number' do
      expect(card.set_number).to be_nil
    end

    it 'parses the rarity' do
      expect(card).to be_common
    end

    it 'parses the name' do
      expect(card.name).to eq("The Pirate's Pirate")
    end

    it 'parses the mana cost' do
      expect(card.mana_cost).to eq('UU')
    end

    it 'parses the supertype' do
      expect(card.supertype).to be_nil
    end

    it 'parses the type' do
      expect(card).to be_creature
    end

    it 'parses the subtype' do
      expect(card.subtype).to eq('Human Pirate Rabble')
    end

    it 'parses the rules text' do
      expect(card.rules_text).to eq("Whenever The Pirate's Pirate attacks and isn't blocked, you may gain control of target artifact defending player controls. If you do, The Pirate's Pirate assigns no combat damage this turn.")
    end

    it 'parses the power' do
      expect(card.power).to eq(1)
    end

    it 'parses the toughness' do
      expect(card.toughness).to eq(1)
    end

    it 'parses the battle score' do
      expect(card.battle_score).to be_nil
    end

    it 'parses the flavor text' do
      expect(card.flavor_text).to be_nil
    end

    it 'parses the colors' do
      expect(card.color_string).to eq('blue')
    end
  end

  describe '#to_untyped_file' do
    let(:card) { described_class.from_csv(data) }

    it 'parses out to valid YAML-ish' do
      expect(card.to_untyped_file).to eq(
        <<~YAMLISH.gsub('  ', "\t")
          mse_version: 2.1.2
          card:
            has_styling: false
            notes: 
            time_created: 2024-10-10 19:02:37
            time_modified: 2024-11-09 16:07:23
            card_color: blue
            name: The Pirate's Pirate
            casting_cost: UU
            image: 
            image_2: 
            mainframe_image: 
            mainframe_image_2: 
            indicator: colorless
            super_type: <word-list-type-en>Creature</word-list-type-en>
            sub_type: <word-list-class-en>Human</word-list-class-en><atom-sep> </atom-sep><word-list-class-en>Pirate</word-list-class-en><atom-sep> </atom-sep><word-list-class-en>Rabble</word-list-class-en>
            rule_text: Whenever The Pirate's Pirate attacks and isn't blocked, you may gain control of target artifact defending player controls. If you do, The Pirate's Pirate assigns no combat damage this turn.
            flavor_text: <i-flavor></i-flavor>
            power: 1
            toughness: 1
            card_code_text: 
            card_code_text_2: 
            card_code_text_3: 
        YAMLISH
      )
    end
  end
end
