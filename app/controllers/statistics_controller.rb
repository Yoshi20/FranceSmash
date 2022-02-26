class StatisticsController < ApplicationController
  before_action { @section = 'statistics' }

  # GET /statistics
  # GET /statistics.json
  def index
    @players = Player.all_fr
    @player_count_total = @players.count
    # @player_count_2022 = @players.from_2022.count
  end

end
