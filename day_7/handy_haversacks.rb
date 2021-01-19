require "byebug"
require_relative "bag_node.rb"
require_relative "bag_set.rb"

class Handy_Haversacks
    attr_reader :rules

    def initialize(filepath)
        counter = 0 
        @rules = raw_to_rules(load_raw_data(filepath))
    end

    def bag_sets
        return @bag_sets if @bag_sets
        @bag_sets = @rules
            .each_key
            .map { |bag_name| Bag_Set.new(bag_name, rules) }
    end

    def all_bags_containing(bag_name)
        bag_sets
            .select do |bag_set| 
                bag_set.outermost_bag != bag_name &&
                bag_set[bag_name]
            end
            .map { |bag_set| bag_set.outermost_bag }
    end

    def build_tree_for(bag)
        root = Bag_Node.new(bag)
        root.add_children(@rules)
        root
    end

    def load_raw_data(filepath)
        File.readlines(filepath, chomp: true)
    end

    def raw_to_rules(raw)
        rules = {}
        raw.each do |line| 
            outer_bag, inner_bags = parse_raw_line(line)
            rules[outer_bag] = inner_bags
        end
        rules
    end

    def parse_raw_line(rule_str)
        words = rule_str.split
        rejected_words = ['bags', 'bags,', 'bags.', 'contain', 'bag', 'bag.', 'bag,']
        words.reject! { |word| rejected_words.include?(word) }
        outer_bag = words[0..1].join(' ')
        inner_bags = format_inner_bags(words[2..-1])
        [outer_bag, inner_bags]
    end
end

def format_inner_bags(words)
    if words.first == "no"
        return nil
    else
        inner_bags = []
        (0..(words.length/3 - 1)).each do |i|
            start_i, end_i = (i * 3 + 0), (i * 3 + 2)
            inner_bags << words[start_i..end_i].join(" ")
        end
        return inner_bags
    end
end

hh = Handy_Haversacks.new("input.txt")
#hh.rules.each { |key, val| puts "#{key} => #{val}" }
#hh.bag_sets.each { |set| puts set }
puts hh.all_bags_containing("shiny gold").length
shiny_gold_tree = hh.build_tree_for("shiny gold")
puts shiny_gold_tree.num_bags - 1