class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]


  # GET /profiles
  # GET /profiles.json
  def index
    #@profiles = Profile.all
  end

  # GET /profiles/1
  # GET /profiles/1.json
  # GET /users/2
  def show
    redirect_to edit_profile_url if @profile.nil?
    if user_signed_in?
      @photos = Photo.where(user_id: @profile.user_id).limit(9)
    end
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
    @profile.user = current_user
  end

  # GET /profiles/1/edit
  def edit
    #@profile = Profile.find_or_initialize_by(user: current_user)
    @profile = Profile.new(user: current_user) if @profile.nil?
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  # PATCH /users/2
  def update
    respond_to do |format|
      if performing_follow?
        @profile.user.toggle_followed_by(current_user)
        format.html { redirect_to @profile.user }
        format.json { render :show, status: :ok, location: @profile }
      # can only edit your own profile
      elsif @profile.nil? || @profile.user != current_user
        redirect_to root_url
      elsif @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      if params[:id]
        # another persons profile page
        @profile = Profile.find_by!(user_id: params[:id])
      else
        # the signed in users profile
        @profile = Profile.find_by(user: current_user)
      end
    end
  
  # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:username, :name, :bio)
    end
  
  def performing_follow?
    params.dig(:user, :toggle_follow).present?
  end
end
