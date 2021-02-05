class PasswordValidatorOTCP < PasswordValidator

    def self.to_password_hash(str)
        split_str = str.split
        positions = split_str[0]
            .split('-')
            .map(&:to_i)
        {
            first_pos: positions.first,
            last_pos: positions.last,
            required_letter: split_str[1][0],
            password: split_str[2]
        }
    end
    
    def valid_password?(pass_hash)
        is_letter_at_pos?(
            pass_hash[:required_letter], 
            pass_hash[:first_pos], 
            pass_hash[:password]
        ) ^ is_letter_at_pos?(
            pass_hash[:required_letter], 
            pass_hash[:last_pos], 
            pass_hash[:password]
        )
    end

    def is_letter_at_pos?(letter, pos, str)
        str[pos - 1] == letter
    end
end