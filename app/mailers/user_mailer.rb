class UserMailer < BaseMailer
  def welcome(user)
    @user = user
    mail(:to => @user.email, :subject => "Welcome to Start Up")
  end
end
