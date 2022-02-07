class AddFederalStateToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :federal_state, :string
    add_column :players, :gender, :string
    add_column :players, :birth_year, :integer

  end
end
