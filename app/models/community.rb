class Community < ApplicationRecord
  before_create :set_country_code

  validates :name, uniqueness: true, presence: true

  scope :all_fr, -> { where(country_code: 'fr') }

end
