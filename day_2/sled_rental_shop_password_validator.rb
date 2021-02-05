require_relative 'password_validator.rb'
require_relative 'password_rules.rb'

class SledRentalShopPasswordValidator < PasswordValidator
    include SledRentalShopPasswordRules
end