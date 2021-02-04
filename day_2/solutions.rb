require_relative "passwords.rb"
require_relative "octp_passwords.rb"

validator = PasswordValidator.new
puts validator.count_of_valid_passwords("input.txt")

validator_otcp = PasswordValidatorOTCP.new
puts validator_otcp.count_of_valid_passwords("input.txt")