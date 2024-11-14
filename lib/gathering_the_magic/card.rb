# frozen_string_literal: true

require 'active_model'
require 'active_support/core_ext/enumerable'
require 'action_view/helpers/tag_helper'

class Card
  include ActiveModel::Validations
  include ActionView::Helpers::TagHelper

  def self.from_csv(hash)
    ability_score = hash.fetch('Power/Toughness/Battle Score') || ''

    if hash.fetch('Type') == 'Battle'
      power = ability_score.to_i
    else
      power, toughness = ability_score.split('/').map(&:to_i)
    end

    Card.new(
      colors: hash.fetch('Colors').split(',').map(&:strip),
      flavor_text: hash.fetch('Flavor Text'),
      mana_cost: hash.fetch('Mana Cost'),
      name: hash.fetch('Name'),
      power:,
      rarity: rarities.detect { |rarity| rarity.start_with?(hash.fetch('Rarity')) },
      rules_text: (hash.fetch('Rules Text') || '').gsub('{N}', hash.fetch('Name')).gsub('{', '<sym>').gsub('}', '</sym>'),
      set_number: hash.fetch('Set Number'),
      set_shorthand: hash.fetch('Set Shorthand'),
      subtype: hash.fetch('Subtype') || '',
      supertype: hash.fetch('Supertype')&.downcase,
      toughness:,
      type: hash.fetch('Type').downcase,
    )
  end

  def self.rarities
    %w[common uncommon rare mythic]
  end

  def self.supertypes
    %w[basic kindred legendary snow token]
  end

  def self.types
    %w[artifact battle creature emblem enchantment instant land planeswalker scheme sorcery]
  end

  attr_reader :colors, :flavor_text, :mana_cost, :name, :power, :rules_text, :set_number, :subtype, :supertype, :toughness

  validates :name, presence: true
  validates :power, presence: true, if: :powerful?
  validates :toughness, presence: true, if: :creature?
  validates :rarity, inclusion: { in: rarities }
  validates :supertype, inclusion: { in: supertypes }, allow_nil: true
  validates :type, inclusion: { in: types }, presence: true

  def initialize(colors:, flavor_text:, mana_cost:, name:, power:, rarity:, rules_text:, set_number:, set_shorthand:, subtype:, supertype:, toughness:, type:)
    @colors = colors
    @flavor_text = flavor_text
    @mana_cost = mana_cost
    @name = name
    @power = power
    @rarity = rarity
    @rules_text = rules_text
    @subtype = subtype
    @supertype = supertype
    @toughness = toughness
    @type = type
  end

  rarities.each do |r|
    define_method("#{r}?") do
      rarity == r
    end
  end

  supertypes.each do |s|
    define_method("#{s}?") do
      super_type == s
    end
  end

  types.each do |t|
    define_method("#{t}?") do
      type == t.to_s
    end
  end

  def to_untyped_file
    <<~YAML.gsub('  ', "\t")
      mse_version: 2.1.2
      card:
        has_styling: false
        notes: 
        time_created: #{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}
        time_modified: #{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}
        card_color: #{color_string}
        name: #{name}
        casting_cost: #{mana_cost}
        image: 
        image_2: 
        mainframe_image: 
        mainframe_image_2: 
        indicator: colorless
        super_type: #{supertype_html}
        sub_type: #{subtype_html}
        rule_text: #{rules_text}
        flavor_text: #{flavor_text_html}
        power: #{power}
        toughness: #{toughness}
        card_code_text: 
        card_code_text_2: 
        card_code_text_3: 
    YAML
  end

  def filename
    "card #{name.downcase.gsub(/[^a-z0-9\- ]+/i, '' )}"
  end

  def color_string
    card_colors = colors.count >= 3 ? 'multicolored' : colors.join(',')
    card_colors += ', artifact' if artifact?
    card_colors += ', land' if land?
    card_colors + ', hybrid, radial'
  end

  private

  attr_reader :rarity, :set_shorthand, :type

  def powerful?
    creature? || battle?
  end

  def supertype_html
    content_tag('word-list-type-en', [supertype, type].map(&:presence).compact.map(&:humanize).join(' '))
  end

  def subtype_html
    subtype.split(' ').map do |st|
      content_tag('word-list-class-en', st)
    end.join(content_tag('atom-sep', ' '))
  end

  def flavor_text_html
    content_tag('i-flavor', flavor_text)
  end
end
