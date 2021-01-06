# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'import@linkcomercial.com.br'
  layout 'mailer'
end
