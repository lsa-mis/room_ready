class ApplicationMailer < ActionMailer::Base
  prepend_view_path "app/views/mailers"
  default from: "lsa-spaceready-issues@umich.edu"
  layout "mailer"
end
