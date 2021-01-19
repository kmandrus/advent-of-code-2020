class Passport_Validator
    attr_reader :passports, :required_fields

    def initialize(filepath)
        @required_fields = [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
        @passports = load_batch(filepath)
    end

    def num_valid_passports
        @passports.count { |passport| valid_passport?(passport) }
    end

    def valid_passport?(passport)
        all_required_fields?(passport) &&
        valid_byr?(passport[:byr]) &&
        valid_iyr?(passport[:iyr]) &&
        valid_eyr?(passport[:eyr]) &&
        valid_hgt?(passport[:hgt]) &&
        valid_hcl?(passport[:hcl]) &&
        valid_ecl?(passport[:ecl]) &&
        valid_pid?(passport[:pid])
    end
    
    def all_required_fields?(passport)
        @required_fields.all? { |field| passport[field] }
    end

    def load_batch(filepath)
        raw_data = File.read(filepath)
        passport_strings = raw_data.split("\n\n")
        passport_strings.map { |str| str_to_passport_hash(str) }
    end

    def str_to_passport_hash(str)
        passport_hash = {}
        fields = str.split
        fields.each do |field|
            pair = field.split(":")
            passport_hash[pair.first.to_sym] = pair.last
        end
        passport_hash
    end

    def valid_byr?(year)
        year.to_i.between?(1920, 2002)
    end

    def valid_iyr?(year)
        year.to_i.between?(2010, 2020)
    end

    def valid_eyr?(year)
        year.to_i.between?(2020, 2030)
    end

    def valid_hgt?(hgt)
        unit = hgt[-2..-1]
        num = hgt[0...-2].to_i
        if unit == 'in'
            return num.between?(59, 76)
        elsif unit == 'cm'
            return num.between?(150, 193)
        end
        false
    end

    def valid_hcl?(hcl)
        return false unless hcl[0] == '#' && hcl.length == 7
        hcl_chars = hcl[1..-1].split('')
        valid_chars = ('a'..'z').to_a + ('0'..'9').to_a
        hcl_chars.all? { |char| valid_chars.include?(char) }
    end

    def valid_ecl?(ecl)
        valid_ecls = ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
        valid_ecls.include?(ecl)
    end

    def valid_pid?(pid)
        return false unless pid.length == 9
        valid_digits = ('0'..'9').to_a
        pid.split('').all? { |digit| valid_digits.include?(digit) }
    end

end

validator = Passport_Validator.new("input.txt")
puts validator.num_valid_passports
#tests
#puts
#p validator.passports
# p validator.valid_byr?(1900) == false
# p validator.valid_byr?(1942) == true
# p validator.valid_byr?(2004) == false

