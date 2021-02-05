class PasswordValidator

    def self.initialize_with_file(filepath)
        self.new(load_password_hashes_from(filepath))
    end

    def self.load_password_hashes_from(filepath)
        File.readlines(filepath, chomp: true)
            .map { |str| self.to_password_hash(str) }
    end

    def self.to_password_hash(str)
        raise "subclass must implement"
    end

    public
    def initialize(password_hashes)
        @password_hashes = password_hashes
    end

    def num_valid_passwords
        @valid_password_count ||= fetch_num_valid_passwords
    end

    private
    def fetch_num_valid_passwords
        @password_hashes.inject(0) do |count, hash| 
            valid_password?(hash) ? count += 1 : count
        end
    end

    def valid_password?(pass_hash)
        raise "subclass must implement"
    end
end