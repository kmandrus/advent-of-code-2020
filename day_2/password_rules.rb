module TobogganCorporatePasswordRules
    
    def self.included(containing_class)
        containing_class.extend(ClassMethods)
    end

    module ClassMethods
        def to_password_hash(str)
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

module SledRentalShopPasswordRules

    def self.included(containing_class)
        containing_class.extend(ClassMethods)
    end

    module ClassMethods
        def to_password_hash(str)
            split_str = str.split
            min_and_max = split_str[0]
                .split('-')
                .map(&:to_i)
            {
                min: min_and_max.first,
                max: min_and_max.last,
                required_letter: split_str[1][0],
                password: split_str[2]
            }
        end
    end

    def valid_password?(pass_hash)
        count = count_letter(pass_hash[:required_letter], pass_hash[:password])
        count <= pass_hash[:max] && count >= pass_hash[:min]
    end

    def count_letter(letter, word)
        count = 0
        word.each_char { |char| count += 1 if char == letter }
        count
    end

end