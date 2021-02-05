require_relative 'password_validator.rb'
require_relative 'password_rules.rb'

class TobogganCorporatePasswordValidator < PasswordValidator
    include TobogganCorporatePasswordRules
end