Clearance.configure do |config|
  config.routes = false
  config.cookie_domain = ".jottins.co"
  config.mailer_sender = "support@jottings.co"
end

Clearance::PasswordsController.layout "clearance"
Clearance::SessionsController.layout "clearance"
Clearance::UsersController.layout "clearance"
