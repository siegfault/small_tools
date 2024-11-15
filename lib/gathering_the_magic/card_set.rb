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

  def to_untyped_file
    Dir.mktmpdir do |dir|
      cards.each do |card|
        File.write("#{dir}/#{card.filename}", card.to_untyped_file)
      end

      `zip -FS set.zip #{dir}/*`
    end
  end

  def to_manifest
    File.write(
      'set.manifest',
      cards.map do |card|
        "include_file: #{card.filename}"
      end.join("\n")
    )
  end
end
