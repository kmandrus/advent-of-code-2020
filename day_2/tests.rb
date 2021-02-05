require_relative "password_validator.rb"
require_relative "toboggan_corporate_password_validator.rb"
require_relative "sled_rental_shop_password_validator.rb"

puts "TESTS\n"
puts "PasswordValidator"
validator = SledRentalShopPasswordValidator.initialize_with_file('input.txt')
p (validator.count_letter('n', 'nnnnnnnnnnnnnnnnrnsn') == 18 ) 
pass_hash = SledRentalShopPasswordValidator.to_password_hash("17-19 n: nnnnnnnnnnnnnnnnrnsn")
p validator.valid_password?(pass_hash) == true
p (validator.num_valid_passwords == 614)

puts "PasswordValidatorOTCP"
otcp_validator = TobogganCorporatePasswordValidator.initialize_with_file('input.txt')
p otcp_validator.num_valid_passwords == 354