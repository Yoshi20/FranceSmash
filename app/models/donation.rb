class Donation < ApplicationRecord
  before_create :set_country_code

  scope :all_fr, -> { where(country_code: 'fr') }

end
