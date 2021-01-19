require "byebug"

class Bag_Node
    attr_accessor :name, :children

    def initialize(name)
        @name = name
        @children = []
    end

    def add_children(rules)
        inner_bags = rules[name]
        if inner_bags
            inner_bags.each do |rule|
                quantity, child_name = rule_to_quantity_and_name(rule)
                quantity.times { children << Bag_Node.new(child_name) }
            end
        end
        children.each { |child| child.add_children(rules) }
    end

    def rule_to_quantity_and_name(rule)
        [rule[0].to_i, rule[2..-1]]
    end

    def num_bags
        return 1 if children.empty?
        1 + children.sum { |child| child.num_bags }
    end
end