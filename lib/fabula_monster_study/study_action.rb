# frozen_string_literal: true

class StudyAction
  def initialize(data:, level:)
    @data = data
    @level = level
  end

  def information
    <<~INFO
      #{name}
      Level #{lvl} Rank #{rank} #{species}

      Dex | Ins | Mig | Will
      ----+-----+-----+-----
      d#{dex} | d#{ins} | d#{mig} | d#{wil}

      HP | MP | Def | M Def
      ---+----+-----+------
      #{hp} | #{mp} | #{defense} | #{magic_defense}

      * Attacks:
        * Basic Attacks: #{format_abilities(basic_attacks)}
        * Actions: #{format_abilities(actions)}
        * Spells: #{format_abilities(spells)}
        * Special: #{format_abilities(special)}
        * Weapon Attacks: #{format_abilities(weapon_attacks)}
      * Description: #{formatted_traits}
      * Location:
      * Affinities:
        * Resistances: #{resistances}
        * Vulnerabilities: #{vulnerabilities}
        * Immunities: #{immunities}
        * Absorbs: #{absorbs}
      * Gear: #{gear}
    INFO
  end

  private

  attr_reader :data, :level

  def format_abilities(abilities)
    abilities.map { |a| "\n    * #{format_ability(a)}" }.join
  end

  def format_ability(ability)
    ability.compact.reject(&:empty?).join(' - ')
  end

  def formatted_traits
    traits.split(', ').map { |trait| "\n  * #{trait}" }.join
  end

  def resistances
    affinities_by('rs')
  end

  def vulnerabilities
    affinities_by('vu')
  end

  def immunities
    affinities_by('im')
  end

  def absorbs
    affinities_by('ab')
  end

  def affinities_by(value)
    affinities.select { |_k, v| v == value }.keys.map { |affinity| affinity.to_s.capitalize }.join(', ')
  end

  def name = data[:name]
  def lvl = data[:lvl]

  def hp
    data.dig(:extra, :hp) if basic?
  end

  def mp
    data.dig(:extra, :mp) if basic?
  end

  def rank
    data[:rank] if basic?
  end

  def species
    data[:species] if basic?
  end

  def traits
    if advanced?
      data.fetch(:traits)
    else
      ''
    end
  end

  def dex
    data.dig(:attributes, :dexterity) if advanced?
  end

  def ins
    data.dig(:attributes, :insight) if advanced?
  end

  def mig
    data.dig(:attributes, :might) if advanced?
  end

  def wil
    data.dig(:attributes, :will) if advanced?
  end

  def defense
    data.dig(:extra, :def) if advanced?
  end

  def magic_defense
    data.dig(:extra, :mDef) if advanced?
  end

  def affinities
    if advanced?
      data.fetch(:affinities)
    else
      {}
    end
  end

  def basic_attacks
    if expert?
      data.fetch(:attacks, []).map do |attack|
        [
          attack[:name],
          attack[:range],
          attack[:type],
          spell_damage(attack[:attr1], attack[:attr2]),
          attack[:special]
        ]
      end
    else
      []
    end
  end

  def actions
    if expert?
      data.fetch(:actions, []).map do |action|
        [
          action[:name],
          action[:effect]
        ]
      end
    else
      []
    end
  end

  def spells
    if expert?
      data.fetch(:spells, []).map do |spell|
        [
          spell[:name],
          spell[:target],
          spell[:range],
          spell[:type],
          spell[:mp],
          spell_damage(spell[:attr1], spell[:attr2]),
          spell[:effect],
          spell[:duration],
          spell[:special]
        ]
      end
    else
      []
    end
  end

  def special
    if expert?
      data.fetch(:special, []).map do |special|
        [special[:name], "#{special.fetch(:spCost, 0)} MP", special[:effect]]
      end
    else
      []
    end
  end

  def weapon_attacks
    if expert?
      data.fetch(:weaponattacks, []).map do |weapon|
        [
          weapon[:name],
          weapon[:flatdmg],
          weapon[:flathit],
          weapon[:special],
          weapon[:weapon]
        ]
      end
    else
      []
    end
  end

  def gear
    if expert?
      data.fetch(:raregear).map do |piece|
        "\n  * #{piece[:name]} - #{piece[:effect]}"
      end.join
    else
      ''
    end
  end

  def spell_damage(attr1, attr2)
    if attr1 == attr2
      "2d#{data.dig(:attributes, attr1.to_sym)}"
    else
      "1d#{data.dig(:attributes, attr1.to_sym)} + 1d#{data.dig(:attributes, attr2.to_sym)}"
    end
  end

  def basic?
    level >= 10
  end

  def advanced?
    level >= 13
  end

  def expert?
    level >= 16
  end
end
