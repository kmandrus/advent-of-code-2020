require "byebug"

class AdapterArray
    attr_reader :adapters

    def initialize(adapters)
        @adapters = adapters.sort
        add_charger_and_device!(@adapters)
    end

    def jolt_diffs_of_one_times_jolt_diffs_of_three
        jolt_differences[1] * jolt_differences[3]
    end

    def all_possible_charger_arrangements
        ways_to_reach_charger(@adapters.last)
    end

    private
    CHARGER_RATING = 0
    def add_charger_and_device!(adapters)
        adapters
            .unshift(CHARGER_RATING)
            .push(device_rating)
    end

    def jolt_differences
        @jolt_differences ||= fetch_jolt_differences
    end

    def fetch_jolt_differences
        Hash.new(0).tap do |result|
            adapters.each_with_index do |adapter, i|
                next if is_charger?(adapter)

                prev_adapter = @adapters[i-1]
                result[adapter - prev_adapter] += 1
            end
        end
    end

    def ways_to_reach_charger(adapter)
        @ways_to_reach_charger ||= { 0 => 1 }
        if @ways_to_reach_charger[adapter]
            return @ways_to_reach_charger[adapter]
        end
        
        @ways_to_reach_charger[adapter] = lower_jolt_connections(adapter)
            .sum { |connection| ways_to_reach_charger(connection) }
    end

    def lower_jolt_connections(adapter)
        return [] if is_charger?(adapter)

        i = (to_index(adapter) - 1)
        [].tap do |connections|
            potential_connection = adapters[i]
            while valid_connection?(adapter, potential_connection) && i >= 0
                connections << potential_connection
                i -= 1
                potential_connection = adapters[i]
            end
        end
    end

    def valid_connection?(adapter_1, adapter_2)
        (adapter_1 - adapter_2).abs <= 3
    end

    def to_index(adapter)
        return @adapter_to_index_hash[adapter] if @adapter_to_index_hash

        @adapter_to_index_hash = Hash.new
        @adapters.each_with_index do |an_adapter, i|
            @adapter_to_index_hash[an_adapter] = i
        end
        @adapter_to_index_hash[adapter]
    end

    def device_rating
        adapters.last + 3
    end

    def is_charger?(adapter)
        adapter.zero?
    end

end