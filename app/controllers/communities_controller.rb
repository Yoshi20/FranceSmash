class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, only: [:new, :edit, :create, :update, :destroy]
  before_action { @section = 'communities' }

  # GET /communities
  def index
    @communities = Community.all_fr.order(region: :desc)
    i = -1
    prevRegion = ''
    @communities_regions_array = []
    @communities.each do |c|
      if c.region != prevRegion
        i = i + 1
        @communities_regions_array[i] = []
      end
      @communities_regions_array[i] << c
      prevRegion = c.region
    end
  end

  # GET /communities/1
  # GET /communities/1.json
  def show
    discord_keys = @community.discord.split(',').map(&:strip)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << request_discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/new
  def new
    @community = Community.new
  end

  # GET /communities/1/edit
  def edit
  end

  # POST /communities
  # POST /communities.json
  def create
    @community = Community.new(community_params)
    respond_to do |format|
      if @community.save
        format.html { redirect_to @community, notice: t('flash.notice.community_created') }
        format.json { render :show, status: :created, location: @community }
      else
        format.html { render :new }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communities/1
  # PATCH/PUT /communities/1.json
  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to @community, notice: t('flash.notice.community_updated') }
        format.json { render :show, status: :ok, location: @community }
      else
        format.html { render :edit }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communities/1
  # DELETE /communities/1.json
  def destroy
    @community.destroy
    respond_to do |format|
      format.html { redirect_to communities_path, notice: t('flash.notice.community_deleted') }
      format.json { head :no_content }
    end
  end

  def grand_est
    @region = 'Grand_Est'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def nouvelle_aquitaine
    @region = 'Nouvelle_Aquitaine'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def auvergne_rhone_alpes
    @region = 'Auvergne'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def bourgogne_franche_comte
    @region = 'Bourgogne'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def bretagne
    @region = 'Bretagne'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def centre_val_de_loire
    @region = 'Centre'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def corsica
    @region = 'Corsica'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def paris_region
    @region = 'Ile_de_France'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def occitanie
    @region = 'Occitanie'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def hauts_de_france
    @region = 'Hauts-de-France'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def normandie
    @region = 'Normandie'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def pays_de_la_loire
    @region = 'Pays_de_la_Loire'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def provence_alpes_cote_azur
    @region = 'Provence-Alpes-Cote_dAzur'
    @communities = Community.all_fr.where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  # def reunion
  #   @communities = Community.all_fr.where(region:'reunion').order(name: :desc)
  # end
  #
  # def martinique
  #   @communities = Community.all_fr.where(region:'martinique').order(name: :desc)
  # end
  #
  # def french_guiana
  #   @communities = Community.all_fr.where(region:'french_guiana').order(name: :desc)
  # end
  #
  # def guadeloupe
  #   @communities = Community.all_fr.where(region:'guadeloupe').order(name: :desc)
  # end
  #
  # def mayotte
  #   @communities = Community.all_fr.where(region:'mayotte').order(name: :desc)
  # end

  def character_discords
    @discords = [
      ["banjo_and_kazooie", "fEyhZrn"], ["bayonetta", "DC36FXc"], ["bowser", "nF9kx7W"],
      ["bowser_jr", "eFDYEfG"], ["byleth", "KDTPNfs"], ["captain_falcon", "zxxdHxU"],
      ["chrom", "wwnhVjS"], ["cloud", "acHKeyQ"], ["corrin", "F98MKp8"], ["daisy", "5EDcCC9"],
      ["dark_pit", "tRzaFXP"],  ["dark_samus", "e9vyVF2"], ["diddy_kong", "aNm6hmkwjV"],
      ["donkey_kong", "bt72UvP"], ["dr_mario", "3b2v576"], ["duck_hunt", "MEmd3C3"],
      ["falco", "EdBwraB"], ["fox", "4JfXSG9"], ["ganondorf", "3G7akxP"], ["greninja", "ERX3BSr"],
      ["hero", "sevQSfS"], ["ice_climbers", "eDqA2Xp"], ["ike", "hT6zdue"], ["incineroar", "QhyTjn7"],
      ["inkling", "TjRTWhz"], ["isabelle", "YNdU5B8"], ["jigglypuff", "dFySWuP"],
      ["joker", "x6cHgmM"], ["kazuya", "Njtpw4W656"], ["ken", "CPptRsR"], ["king_dedede", "rcseuAP"],
      ["king_k_rool", "sQCDnKx"], ["kirby", "AjFA47Q"], ["link", "8pm4FBB"], ["little_mac", "fUmq4cJ"],
      ["lucario", "ptKYD7v"], ["lucas", "yWV5NN8"], ["lucina", "XRA9RkM"], ["luigi", "DzKnQeX"],
      ["mario", "3b2v576"], ["marth", "XRA9RkM"], ["mega_man", "sKp954t"], ["meta_knight", "THs9u5f"],
      ["mewtwo", "JFtDMph"], ["mii_brawler", "2TRzK6U"], ["mii_gunner", "2TRzK6U"],
      ["mii_swordfighter", "2TRzK6U"], ["min_min", "phqePSW"], ["mr_game_and_watch", "MUMcDJF"],
      ["ness", "3c5JPBh"], ["olimar", "6yWuNQa"], ["pac_man", "CmDjRXz"], ["palutena", "2hSRYg2"],
      ["peach", "5EDcCC9"], ["pichu", "5NBk3MT"], ["pikachu", "4Zu58Q5"], ["piranha_plant", "xrHCvpX"],
      ["pit", "tRzaFXP"], ["pokemon_trainer", "Y6dhCsM"], ["pyra_and_mythra", "7g8gY7wQJH"],
      ["richter", "ZDvJWdz"], ["ridley", "yenwRqm"], ["rob", "rSx8MSf"], ["robin", "Gpc7Dbu"],
      ["rosalina_and_luma", "zfvA8xV"], ["roy", "wwnhVjS"], ["ryu", "CPptRsR"],
      ["samus", "e9vyVF2"], ["sephiroth", "APW2QScwW7"], ["sheik", "edvYN57"], ["shulk", "GneEZAC"],
      ["simon", "ZDvJWdz"], ["snake", "WgWhze4"], ["sonic", "NVWzs5M"], ["sora", "AaZjVBnANh"],
      ["steve", "7nK7ADz"], ["terry", "WXW26zN"], ["toon_link", "mSU95AB"], ["villager", "9N6Rr3B"],
      ["wario", "jTDGUC2"], ["wii_fit_trainer", "NcGbfek"], ["wolf", "esk7R3H"],
      ["yoshi", "A88DP87"], ["young_link", "zcZFt7x"], ["zelda", "ke3SBMC"], ["zero_suit_samus", "vHTu5sQ"],
    ]
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_community
    @community = Community.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def community_params
    params.require(:community).permit(
      :name, :city, :department, :region, :country_code, :discord, :twitter,
      :instagram, :facebook, :youtube, :twitch
    )
  end

  def authenticate_admin!
    unless current_user.present? && current_user.admin?
      respond_to do |format|
        format.html { redirect_to communities_path, alert: t('flash.alert.unauthorized') }
        format.json { render json: {}, status: :unauthorized }
      end
    end
  end

  require 'open-uri'
  require 'json'
  def request_discord_invite(key)
    Rails.cache.fetch("discord_invite_#{key}", expires_in: 1.day) do
      url = "https://discord.com/api/v9/invites/#{URI.escape(key)}?with_counts=true"
      puts "Requesting: GET #{url}"
      begin
        json_data = JSON.parse(URI.open(url).read)
      rescue OpenURI::HTTPError => ex
        puts ex
      end
      if json_data.present? && !json_data["guild"].nil?
        json_data
      else
        puts "=> No guild parameter found! json_data = #{json_data.to_s}"
        break # do not cache if theres no valid data
      end
    end
  end

end
