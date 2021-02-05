class PasswordValidator

    def self.initialize_with_file(filepath)
        self.new(load_password_hashes_from(filepath))
    end

    def self.load_password_hashes_from(filepath)
        File.readlines(filepath, chomp: true)
            .map { |str| self.to_password_hash(str) }
    end

    def self.to_password_hash(str)
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

    def initialize(password_hashes)
        @password_hashes = password_hashes
    end

    def num_valid_passwords
        @valid_password_count ||= fetch_num_valid_passwords
    end

    def fetch_num_valid_passwords
        @password_hashes.inject(0) do |count, hash| 
            valid_password?(hash) ? count += 1 : count
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