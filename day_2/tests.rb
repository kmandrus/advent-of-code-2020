require_relative "password_validator.rb"
require_relative "password_validator_otcp.rb"

puts "TESTS\n"
puts "PasswordValidator"
validator = PasswordValidator.initialize_with_file('input.txt')
p (validator.count_letter('n', 'nnnnnnnnnnnnnnnnrnsn') == 18 ) 
pass_hash = PasswordValidator.to_password_hash("17-19 n: nnnnnnnnnnnnnnnnrnsn")
p validator.valid_password?(pass_hash) == true
p (validator.num_valid_passwords == 614)

puts "PasswordValidatorOTCP"
validator_otcp = PasswordValidatorOTCP.new
p validator_otcp.count_of_valid_passwords('input.txt') == 354