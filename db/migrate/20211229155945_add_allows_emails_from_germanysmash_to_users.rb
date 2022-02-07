class AddAllowsEmailsFromGermanysmashToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :allows_emails_from_germanysmash, :boolean, default: true
    add_column :users, :allows_emails_from_partners, :boolean, default: true
  end
end
