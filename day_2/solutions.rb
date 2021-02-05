require_relative "toboggan_corporate_password_validator.rb"
require_relative "sled_rental_shop_password_validator.rb"

validator = SledRentalShopPasswordValidator.initialize_with_file('input.txt')
puts validator.num_valid_passwords

validator_otcp = TobogganCorporatePasswordValidator.initialize_with_file('input.txt')
puts validator_otcp.num_valid_passwords