module Flaggy
module Rule
class << self
  def satisfied?(rule, meta)
    if rule.key?("all")
      rule.fetch("all").all? { |nested_rule| satisfied?(nested_rule, meta) }
    elsif rule.key?("any")
      rule.fetch("any").any? { |nested_rule| satisfied?(nested_rule, meta) }
    elsif rule.key?("not")
      !satisfied?(rule.fetch("not"), meta)
    elsif rule.key?("attribute") && rule.key?("is")
      fetch_or_false(meta, rule.fetch("attribute")) { |value| rule.fetch("is") == value }
    elsif rule.key?("attribute") && rule.key?("in")
      fetch_or_false(meta, rule.fetch("attribute")) { |value| rule.fetch("in").include?(value) }
    else
      false
    end
  end

  private

  def fetch_or_false(meta, attribute, &block)
    if meta.key?(attribute)
      block.call(meta.fetch(attribute))
    else
      false
    end
  end
end
end
end
