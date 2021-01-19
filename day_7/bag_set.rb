class Bag_Set
    attr_reader :outermost_bag, :set

    def initialize(outermost_bag, rules)
        @outermost_bag = outermost_bag
        @set = Hash.new(false)
        @set[outermost_bag] = true
        @rules = rules
        build_set
    end

    def build_set
        inner_bags = rules_to_names(@rules[outermost_bag])
        while inner_bags.length > 0
            bag = inner_bags.pop
            unless @set[bag]
                @set[bag] = true
                new_bags = rules_to_names(@rules[bag])
                inner_bags.concat(new_bags)
            end
        end
    end

    def rules_to_names(rules)
        names = []
        return names unless rules
        rules.each do |rule|
            names << name_from_rule(rule)
        end
        names
    end

    def name_from_rule(rule)
        rule[2..-1]
    end

    def to_s
        "outer bag: #{outermost_bag}\nset: #{set.keys}"
    end

    def [](name)
        set[name]
    end

end