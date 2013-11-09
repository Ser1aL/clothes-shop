class AddFixedMarkupToExchangeRates < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :fixed_markup, :integer
  end
end
