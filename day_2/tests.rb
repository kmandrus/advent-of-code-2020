require_relative "password_validator.rb"
require_relative "password_validator_otcp.rb"

puts "TESTS\n"
puts "PasswordValidator"
validator = PasswordValidator.new()
p validator.count_letter('n', 'nnnnnnnnnnnnnnnnrnsn') == 18
pass_hash = validator.parse_line("17-19 n: nnnnnnnnnnnnnnnnrnsn")
p validator.valid_password?(pass_hash) == true
p (validator.count_of_valid_passwords('input.txt') == 614)

puts "PasswordValidatorOTCP"
validator_otcp = PasswordValidatorOTCP.new
p validator_otcp.count_of_valid_passwords('input.txt') == 354