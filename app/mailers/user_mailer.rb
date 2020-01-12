class UserMailer < ApplicationMailer
	default from: 'test@test'

	def welcome_email
		@user = params[:user]
		@url = 'http://localhost:3000/users/sign_in'
		mail(to: @user.email, subject: '私の素敵なサイトへようこそ')
	end
end
