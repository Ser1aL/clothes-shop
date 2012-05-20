class CreateExchangeRates < ActiveRecord::Migration
  def self.up
    create_table :exchange_rates do |t|
      t.decimal :value, :precision => 10, :scale => 2
      t.decimal :markup, :precision => 10, :scale => 2
      t.string :currency
      t.string :domain

      t.timestamps
    end
  end

  def self.down
    drop_table :exchange_rates
  end
end
