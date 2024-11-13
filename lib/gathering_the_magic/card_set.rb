# frozen_string_literal: true

require_relative 'card'
require 'csv'

class CardSet
  attr_reader :cards

  def self.from_csv(filename)
    CardSet.new(
      CSV.read(filename, headers: true).map do |row|
        Card.from_csv(row.to_hash)
      end
    )
  end

  def initialize(cards)
    @cards = cards
  end
end
