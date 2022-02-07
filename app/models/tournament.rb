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

  before_create :set_federal_state
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

  def set_federal_state
    return if self.federal_state.present?
    federal_states_raw = ApplicationController.helpers.federal_states_raw
    federal_states_de = I18n.t(federal_states_raw, scope: 'defines.federal_states', locale: :de).map(&:downcase)
    federal_states_en = I18n.t(federal_states_raw, scope: 'defines.federal_states', locale: :en).map(&:downcase)
    # First: Try to determine federal_state from city
    if self.city.present?
      city = self.city.downcase
      #city = city.gsub('basel', 'basel-stadt').gsub('bâle', 'bâle-ville').gsub('gallen', 'st. gallen')
      if (federal_states_de.include?(city) || federal_states_en.include?(city))
        self.federal_state = federal_states_raw[federal_states_de.index(city)] if federal_states_de.index(city).present?
        self.federal_state = federal_states_raw[federal_states_en.index(city)] if federal_states_en.index(city).present?
        return # as soon as federal_state was found
      end
    end
    # Second: Try to determine federal_state from a word in location
    if self.location.present?
      self.location.downcase.split(' ').each do |l|
        l = l.gsub(',', '')#.gsub('basel', 'basel-stadt').gsub('bâle', 'bâle-ville').gsub('gallen', 'st. gallen')
        if (federal_states_de.include?(l) || federal_states_en.include?(l))
          self.federal_state = federal_states_raw[federal_states_de.index(l)] if federal_states_de.index(l).present?
          self.federal_state = federal_states_raw[federal_states_en.index(l)] if federal_states_en.index(l).present?
          return # as soon as federal_state was found
        end
      end
      # Third: Try to find the federal_state with the help of Google Maps
      require 'open-uri'
      require 'json'
      begin
        json_data = JSON.parse(URI.open("https://maps.googleapis.com/maps/api/geocode/json?address=#{ERB::Util.url_encode(self.location)}&components=country:DE&key=#{ENV['GOOGLE_MAPS_SERVER_SIDE_API_KEY']}&outputFormat=json").read)
        if json_data["status"] == "OK" && json_data["results"].present? && json_data["results"][0].present?
          json_data["results"][0]["address_components"].each do |res|
            if (res["types"].present? && res["types"].include?('administrative_area_level_1'))
              if res["long_name"].present?
                sn = res["short_name"]
                if federal_states_raw.include?(sn)
                  self.federal_state = sn
                  return # as soon as federal_state was found
                end
                # long_name will most likely never be necessary
                ln = res["long_name"].downcase
                if (federal_states_de.include?(ln) || federal_states_en.include?(ln))
                  self.federal_state = federal_states_raw[federal_states_de.index(ln)] if federal_states_de.index(ln).present?
                  self.federal_state = federal_states_raw[federal_states_en.index(ln)] if federal_states_en.index(ln).present?
                  return # as soon as federal_state was found
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
