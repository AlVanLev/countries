class AddActiveToCountries < ActiveRecord::Migration[5.2]
  def change
    add_column :countries, :active, :boolean, :default => true
  end
end
