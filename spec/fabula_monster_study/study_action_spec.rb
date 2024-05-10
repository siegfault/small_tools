# frozen_string_literal: true

require_relative '../../lib/fabula_monster_study/study_action'

RSpec.describe StudyAction do
  let(:data) do
     {"extra":{"hp":"30","def":0,"mp":"0","mDef":0},"lvl":20,"special":[{"spCost":"2","effect":"Forebo gains immunity to all types except ice. Create a 12 clock. Chompers being destroyed count as a clock as well as a successful 13 difficulty might might check to smash the mage's glass globe.","name":"Shielded by a a gassed up wizard"},{"spCost":"0","effect":"If Forebo cannot cast Summon Chomper or Get to work! it takes 10 damage, gains 20 mp, and uses Flail.","name":"Those who can't do, manage"}],"traits":"Foreman, metal, mad, bad, all gassed up","uid":"PUdNjKyQh1T5lJEkwKM45XYAAA93","attributes":{"might":10,"dexterity":8,"insight":8,"will":8},"name":"Factory Forebo","affinities":{"ice":"vu","earth":"rs"},"raregear":[{"name":"Chomped Shoe","effect":""}],"actions":[],"rank":"champion2","id":"1SwWEmlIQz4EAhaHmP2C","attacks":[{"type":"physical","attr1":"might","name":"Flail","range":"melee","special":["Damages itself equal to (HR + 15) / 2 physical damage regardless of hit result."],"extraDamage":true,"attr2":"might"}],"species":"Construct","spells":[{"duration":"scene","mp":"10","special":[],"type":"physical","effect":"Summon a Chomper","name":"Summon Chomper","attr1":"dexterity","range":"melee","attr2":"dexterity","target":"self"},{"duration":"Instantaneous","name":"Get to work!","effect":"Two allies perform an additional turn. Count down their clocks by one tick.","attr1":"dexterity","type":"physical","target":"Up to two allies","special":[],"mp":"20","range":"melee","attr2":"dexterity"}]}
  end
  let(:study_action) { described_class.new(data:, level:) }

  context 'when the level is low' do
    let(:level) { 3 }

    it 'includes minimal information' do
      expect(study_action.information).to eq(
        <<~DATA
          Factory Forebo
          Level 20 Rank  

          Dex | Ins | Mig | Will
          ----+-----+-----+-----
          d | d | d | d

          HP | MP | Def | M Def
          ---+----+-----+------
           |  |  | 

          * Attacks:
            * Basic Attacks: 
            * Actions: 
            * Spells: 
            * Special: 
            * Weapon Attacks: 
          * Description: 
          * Location:
          * Affinities:
            * Resistances: 
            * Vulnerabilities: 
            * Immunities: 
            * Absorbs: 
          * Gear: 
        DATA
      )
    end
  end

  context 'when the level is basic' do
    let(:level) { 11 }

    it 'includes minimal information' do
      expect(study_action.information).to eq(
        <<~DATA
          Factory Forebo
          Level 20 Rank champion2 Construct

          Dex | Ins | Mig | Will
          ----+-----+-----+-----
          d | d | d | d

          HP | MP | Def | M Def
          ---+----+-----+------
          30 | 0 |  | 

          * Attacks:
            * Basic Attacks: 
            * Actions: 
            * Spells: 
            * Special: 
            * Weapon Attacks: 
          * Description: 
          * Location:
          * Affinities:
            * Resistances: 
            * Vulnerabilities: 
            * Immunities: 
            * Absorbs: 
          * Gear: 
        DATA
      )
    end
  end

  context 'when the level is advanced' do
    let(:level) { 14 }

    it 'includes minimal information' do
      expect(study_action.information).to eq(
        <<~DATA
          Factory Forebo
          Level 20 Rank champion2 Construct

          Dex | Ins | Mig | Will
          ----+-----+-----+-----
          d8 | d8 | d10 | d8

          HP | MP | Def | M Def
          ---+----+-----+------
          30 | 0 | 0 | 0

          * Attacks:
            * Basic Attacks: 
            * Actions: 
            * Spells: 
            * Special: 
            * Weapon Attacks: 
          * Description: 
            * Foreman
            * metal
            * mad
            * bad
            * all gassed up
          * Location:
          * Affinities:
            * Resistances: Earth
            * Vulnerabilities: Ice
            * Immunities: 
            * Absorbs: 
          * Gear: 
        DATA
      )
    end
  end

  context 'when the level is expert' do
    let(:level) { 9_001 }

    it 'includes minimal information' do
      expect(study_action.information).to eq(
        <<~DATA
          Factory Forebo
          Level 20 Rank champion2 Construct

          Dex | Ins | Mig | Will
          ----+-----+-----+-----
          d8 | d8 | d10 | d8

          HP | MP | Def | M Def
          ---+----+-----+------
          30 | 0 | 0 | 0

          * Attacks:
            * Basic Attacks: 
              * Flail - melee - physical - 2d10 - Damages itself equal to (HR + 15) / 2 physical damage regardless of hit result.
            * Actions: 
            * Spells: 
              * Summon Chomper - self - melee - physical - 10 - 2d8 - Summon a Chomper - scene
              * Get to work! - Up to two allies - melee - physical - 20 - 2d8 - Two allies perform an additional turn. Count down their clocks by one tick. - Instantaneous
            * Special: 
              * Shielded by a a gassed up wizard - 2 MP - Forebo gains immunity to all types except ice. Create a 12 clock. Chompers being destroyed count as a clock as well as a successful 13 difficulty might might check to smash the mage's glass globe.
              * Those who can't do, manage - 0 MP - If Forebo cannot cast Summon Chomper or Get to work! it takes 10 damage, gains 20 mp, and uses Flail.
            * Weapon Attacks: 
          * Description: 
            * Foreman
            * metal
            * mad
            * bad
            * all gassed up
          * Location:
          * Affinities:
            * Resistances: Earth
            * Vulnerabilities: Ice
            * Immunities: 
            * Absorbs: 
          * Gear: 
            * Chomped Shoe - 
        DATA
      )
    end
  end
end
