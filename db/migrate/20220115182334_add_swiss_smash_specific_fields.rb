class AddSwissSmashSpecificFields < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :canton, :string
    add_column :tournaments, :canton, :string

    add_column :users, :allows_emails_from_swisssmash, :boolean, default: true

    add_column :users, :country_code, :string, default: 'fr'
    add_column :players, :country_code, :string, default: 'fr'
    add_column :tournaments, :country_code, :string, default: 'fr'
  end
end
