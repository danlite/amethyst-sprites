class UserMailer < ActionMailer::Base
  default :from => "Amethyst Sprite System <dan@appsbydan.com>"
  
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Amethyst Password Reset"
  end
end
