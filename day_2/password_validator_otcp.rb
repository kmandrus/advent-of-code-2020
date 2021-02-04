class PasswordValidatorOTCP
    def count_of_valid_passwords(filepath)
        valid_password_count = 0
        file = File.open(filepath)
        file.each do |line|
            password_hash = parse_line(line)
            valid_password_count += 1 if valid_password?(password_hash) 
        end
        file.close
        valid_password_count
    end

    def parse_line(line)
        split_line = line.split
        positions = split_line[0]
            .split('-')
            .map(&:to_i)
        {
            first_pos: positions.first,
            last_pos: positions.last,
            required_letter: split_line[1][0],
            password: split_line[2]
        }
    end

    def valid_password?(hash)
        is_letter_at_pos?(
            hash[:required_letter], 
            hash[:first_pos], 
            hash[:password]
        ) ^ is_letter_at_pos?(
            hash[:required_letter], 
            hash[:last_pos], 
            hash[:password]
        )
    end

    def is_letter_at_pos?(letter, pos, string)
        string[pos - 1] == letter
    end
end