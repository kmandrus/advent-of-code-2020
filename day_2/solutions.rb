require_relative "password_validator.rb"
require_relative "password_validator_octp.rb"

validator = PasswordValidator.new
puts validator.count_of_valid_passwords("input.txt")

validator_otcp = PasswordValidatorOTCP.new
puts validator_otcp.count_of_valid_passwords("input.txt")