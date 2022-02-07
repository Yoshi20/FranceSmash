module PlayerHelper

  def self_assessment_defines
    t(['beginner', 'noob', 'doing_okay', 'intermediate', 'advanced', 'expert', 'professional', 'godlike'],
      scope: 'defines.self_assessments')
  end

  def tournament_experience_defines
    t(['none', 'a_little', 'some', 'a_lot', 'very_much'],
      scope: 'defines.tournament_experiences')
  end

  def regions_raw
    ["Auvergne", "Bourgogne", "Bretagne", "Centre", "Corsica", "Grand_Est", "Hauts-de-France", "Ile_de_France", "Normandie", "Nouvelle_Aquitaine", "Occitanie", "Pays_de_la_Loire", "Provence-Alpes-Cote_d'Azur"]
  end

  def regions
    t(regions_raw, scope: 'defines.regions')
  end

  def regions_for_select
    regions.zip(regions_raw)
  end

  def genders_raw
    ['male', 'female', 'other']
  end

  def genders
    t(genders_raw, scope: 'defines.genders')
  end

  def genders_for_select
    genders.zip(genders_raw)
  end

  def birth_years
    year = Date.today.year
    ((year-100)..year).to_a.sort().reverse()
  end

  def seed_players(players)
    players.sort_by do |p|
      [p.seed_points, -p.created_at.to_i]
    end.reverse
  end

  def top_players_s12_21
    ['Jaka', 'Destany', 'DeepFreeze', 'Deox6', 'Crash', 'Phonky', 'Karpador64', 'Kimbo', 'PATOO', 'colinmee', 'mistic', 'Rohan Doge', 'SickBoy', 'Fr0zen', 'Bigniouf', 'Clipho', 'Mirio', 'Tuzzi', 'ItseMePG', 'Jodel']
  end

end
