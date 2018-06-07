class AddActiveToStates < ActiveRecord::Migration[5.2]
  def change
    add_column :states, :active, :boolean, :default => true
  end
end
