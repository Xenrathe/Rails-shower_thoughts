# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super do |user|
      # Only ONE user will have a non-nil plumber_date at a time
      @plumber_user = User.where.not(plumber_date: nil).first

      # If there is no current plumber OR the plumber_date has 'expired', select a new plumber
      # Will NOT select admins, shadowbanned users, or the current plumber
      if (@plumber_user.nil? || @plumber_user.plumber_date < DateTime.now) && user.plumber_status == 'No'

        # Reset current plumber status (if they didn't use their one highlight, they lose it)
        unless @plumber_user.nil?
          @plumber_user.plumber_date = nil
          @plumber_user.plumber_status = 'No' if @plumber_user.plumber_status != 'Master'
          @plumber_user.save
        end

        # Update user's plumber status
        user.plumber_status = 'Plumber'
        user.plumber_date = DateTime.now + rand(14..18).hours
        user.save
        flash[:plumber] = "Congrats, you've gained Plumber status! You can highlight ONE thought from another user!"
      end
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
