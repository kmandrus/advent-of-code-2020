class Passwords

    def count_of_valid_passwords(filepath)
        valid_password_count = 0
        file = File.open(filepath)
        file.each do |line|
            password_hash = parse_line(line)
            valid_password_count += 1 if valid_password?(password_hash) 
        end
        file.close
        puts valid_password_count
    end

    def parse_line(line)
        split_line = line.split
        min_max = split_line[0]
            .split('-')
            .map(&:to_i)
        {
            min: min_max.first,
            max: min_max.last,
            required_letter: split_line[1][0],
            password: split_line[2]
        }
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

passwords = Passwords.new
puts passwords.count_of_valid_passwords("input.txt")

#tests
# puts "\ntests"
# p passwords.count_letter('n', 'nnnnnnnnnnnnnnnnrnsn')
# pass_hash = passwords.parse_line("17-19 n: nnnnnnnnnnnnnnnnrnsn")
# p passwords.valid_password?(pass_hash)
