class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, only: [:new, :edit, :create, :update, :destroy]
  before_action { @section = 'communities' }

  # GET /communities
  def index
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
