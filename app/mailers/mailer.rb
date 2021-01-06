# frozen_string_literal: true

class Mailer < ApplicationMailer
  def expired_user(user)
    @user = user
    @base_url = Rails.env.production? ? 'https://import.linkcomercial.com.br' : 'http://127.0.0.1:3000'

    mail(to: @user.email, subject: '[Link Track]Sua senha expirou')
  end
end
