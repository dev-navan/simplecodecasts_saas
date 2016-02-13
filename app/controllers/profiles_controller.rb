class ProfilesController < ApplicationController
  before_action :authenticate_user! #if I want authentiation on one page only, write: , only[:new]
  before_action :only_current_user
  
  def new
    # form where a user can fill out their own profile
    @user = User.find( params[:user_id] )
    @profile = Profile.new
  end
  #create user profile
  def create
    @user = User.find( params[:user_id])
    @profile = @user.build_profile(profile_params)
    if @profile.save
      flash[:success] = "Profile Updated!"
      redirect_to user_path( params[:user_id] )
    else
      render action: :new
    end
  end
  #edit user profile
  def edit
    @user = User.find( params[:user_id] )
    @profile = @user.profile
  end
  #update user profile
  def update
    @user = User.find( params[:user_id])
    @profile = @user.profile
    if @profile.update_attributes(profile_params)
      flash[:success] = "Profile Updated!"
      redirect_to user_path( params[:user_id])
    else
      flash[:danger] = "Uh-oh. Try again, our hamsters stopped working!"
      render action: :edit
    end
  end
  #whitelisting form
  private
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :avatar, :job_title, :phone_number, :contact_email, :description)
    end
    
    def only_current_user
      @user = User.find( params[:user_id])
      redirect_to(root_url) unless @user == current_user
    end
end