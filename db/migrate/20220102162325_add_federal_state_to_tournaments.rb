class AddFederalStateToTournaments < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :federal_state, :string
  end
end
