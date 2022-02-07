class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    @url  = 'https://www.francesmash.fr/tournaments'
    mail(to: @user.email, subject: 'Welcome to the FranceSmash Tournament Manager')
  end

end
