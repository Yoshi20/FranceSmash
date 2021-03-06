class Tournament < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :players, through: :registrations
  has_many :matches, dependent: :destroy
  has_many :results, dependent: :destroy

  validates :name, uniqueness: true, presence: true

  scope :all_fr, -> { where(country_code: 'fr') }
  scope :active, -> { where(active: true) }
  scope :upcoming, -> { where('date > ?', Time.now) }
  scope :upcoming_with_today, -> { where('date >= ?', Time.now.beginning_of_day) }
  scope :ongoing, -> { where('(finished IS FALSE OR finished IS NULL) AND date <= ? AND date >= ?', Time.now, Time.now - 6.hours) }
  scope :past, -> { where('started AND finished OR date < ?', Time.now - 6.hours) }
  scope :for_calendar, -> { where(active: true).where('date > ? AND date < ?', 2.weeks.ago, Date.today + 4.months) }
  scope :from_city, -> (city) { where("name ILIKE ? OR name ILIKE ? OR location ILIKE ? OR location ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(city)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city.downcase)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city)}%", "%#{ActiveRecord::Base.sanitize_sql_like(city.downcase)}%") }

  before_create :set_region
  before_create :set_country_code

  MAX_PAST_TOURNAMENTS_PER_PAGE = 20

  def self.search(search)
    if search
      sanitizedSearch = ActiveRecord::Base.sanitize_sql_like(search)
      # name location city ranking_string
      where("name ILIKE ? or location ILIKE ? or city ILIKE ?", "%#{sanitizedSearch}%", "%#{sanitizedSearch}%", "%#{sanitizedSearch}%")
    else
      :all
    end
  end

  def cancelled?
    !self.started and self.finished
  end

  def is_past?
    self.date < Time.now
  end

  def has_pools?
    self.number_of_pools.to_i > 0
  end

  def weekly?
    self.subtype == 'weekly'
  end

  def game_stations_count
    gs_count = 0
    self.registrations.where('game_stations is not NULL').each do |r|
      gs_count += r.game_stations
    end
    gs_count
  end

  def host
    User.find_by(username: self.host_username) if self.host_username.present?
  end

  def set_region
    return if self.region.present?
    regions_raw = ApplicationController.helpers.regions_raw
    regions_fr = I18n.t(regions_raw, scope: 'defines.regions', locale: :fr).map(&:downcase)
    regions_en = I18n.t(regions_raw, scope: 'defines.regions', locale: :en).map(&:downcase)
    # First: Try to determine region from city
    if self.city.present?
      city = self.city.downcase
      #city = city.gsub('basel', 'basel-stadt').gsub('b??le', 'b??le-ville').gsub('gallen', 'st. gallen')
      if (regions_fr.include?(city) || regions_en.include?(city))
        self.region = regions_raw[regions_fr.index(city)] if regions_fr.index(city).present?
        self.region = regions_raw[regions_en.index(city)] if regions_en.index(city).present?
        return # as soon as region was found
      end
    end
    # Second: Try to determine region from a word in location
    if self.location.present?
      self.location.downcase.split(' ').each do |l|
        l = l.gsub(',', '')#.gsub('basel', 'basel-stadt').gsub('b??le', 'b??le-ville').gsub('gallen', 'st. gallen')
        if (regions_fr.include?(l) || regions_en.include?(l))
          self.region = regions_raw[regions_fr.index(l)] if regions_fr.index(l).present?
          self.region = regions_raw[regions_en.index(l)] if regions_en.index(l).present?
          return # as soon as region was found
        end
      end
      # Third: Try to find the region with the help of Google Maps
      require 'open-uri'
      require 'json'
      begin
        json_data = JSON.parse(URI.open("https://maps.googleapis.com/maps/api/geocode/json?address=#{ERB::Util.url_encode(self.location)}&components=country:FR&key=#{ENV['GOOGLE_MAPS_SERVER_SIDE_API_KEY']}&outputFormat=json").read)
        if json_data["status"] == "OK" && json_data["results"].present? && json_data["results"][0].present?
          json_data["results"][0]["address_components"].each do |res|
            if (res["types"].present? && res["types"].include?('administrative_area_level_1'))
              if res["long_name"].present?
                sn = res["short_name"]
                if regions_raw.include?(sn)
                  self.region = sn
                  return # as soon as region was found
                end
                # long_name will most likely never be necessary
                ln = res["long_name"].downcase
                if (regions_fr.include?(ln) || regions_en.include?(ln))
                  self.region = regions_raw[regions_fr.index(ln)] if regions_fr.index(ln).present?
                  self.region = regions_raw[regions_en.index(ln)] if regions_en.index(ln).present?
                  return # as soon as region was found
                end
              end
            end
          end
        end
      rescue OpenURI::HTTPError => ex
        puts ex
      end
    end
  end

end
